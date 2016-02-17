//
//  Coordinator.m
//
//
//  Created by arvin.tan on 8/6/15.
//

#import "EACoordinator.h"
#import <ExternalAccessory/ExternalAccessory.h>

#if EnableNSLogger
#import "LoggerClient.h"
#define DDLogError(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogWarn(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogInfo(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogDebug(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogVerbose(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#else
#define DDLogError(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#define DDLogWarn(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#define DDLogInfo(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#define DDLogDebug(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#define DDLogVerbose(fmt, ...) NSLog(fmt, ##__VA_ARGS__);
#endif

static NSInteger const INPUT_BUFFER_SIZE = 128;
static NSString *GAccessoryProtocol = nil;

@interface EACoordinatorPacket : NSObject {
@public
    NSData *buffer;
    long tag;
}
- (id)initWithData:(NSData *)d tag:(long)i;

@end

@implementation EACoordinatorPacket

- (id)initWithData:(NSData *)d tag:(long)i {
    if((self = [super init])) {
        buffer = d; // Retain not copy. For performance as documented in header file.
        tag = i;
    }
    return self;
}

@end

#define UseOperationQueue 1

@interface EACoordinator () <EAAccessoryDelegate, NSStreamDelegate> {
    EAAccessory *_accessory;
    EASession *_session;
    NSMutableArray *_writeDataBuffer;
    dispatch_queue_t _dataQueue;
    NSOperationQueue *_sendQueue;
    
    CFAbsoluteTime _lastWriteTime;
}

@end

@implementation EACoordinator

+ (void)setAccessoryProtocol:(NSString *)accessoryProtocol {
    NSAssert(accessoryProtocol != nil && accessoryProtocol.length > 0, @"Error: Accessory protocol cannot be nil or have 0 length!");
    GAccessoryProtocol = [accessoryProtocol copy];
}

+ (instancetype)shared {
    static EACoordinator *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [self new];
    });
    return _shared;
}

- (instancetype)init {
    DDLogDebug(@"init");
    self = [super init];
    if (self) {
        NSAssert(GAccessoryProtocol != nil && GAccessoryProtocol.length > 0, @"Error: Please call setAccessoryProtocol before use %@", NSStringFromClass([self class]));
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnectNotification:) name:EAAccessoryDidConnectNotification object:nil];
        _dataQueue = dispatch_queue_create("com.tencent.ea.data.queue", DISPATCH_QUEUE_SERIAL);
        _sendQueue = [[NSOperationQueue alloc] init];
        _sendQueue.maxConcurrentOperationCount = 1;
        
        [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
        [self operationThread];
        [self searchForAlreadyConnectedAccessory];
        _writeDataBuffer = [NSMutableArray new];
        _lastWriteTime = 0;
        _sendTimeinterval = 0;
    }
    return self;
}

- (void)dealloc {
    DDLogDebug(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[EAAccessoryManager sharedAccessoryManager] unregisterForLocalNotifications];
    [self closeSession];
}

- (BOOL)isConnected {
//    DDLogDebug(@"isConnected");
    return _accessory && _session;
}

- (void)sendData:(NSData *)data withTag:(NSInteger)tag {
    EACoordinatorPacket *packet = [[EACoordinatorPacket alloc] initWithData:data tag:tag];
    if (data.length == 0) {
        DDLogDebug(@"send with error, as data len == 0");
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(_dataQueue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->_writeDataBuffer addObject:packet];
        [strongSelf _writeData];
    });
}

- (void)_writeData {
//    if ([NSThread currentThread] == [self operationThread]) {
//        [self _doWrite];
//    } else {
//        [self performSelector:@selector(_doWrite) onThread:[self operationThread] withObject:nil waitUntilDone:NO];
//    }
    if (_sendQueue.operationCount == 0) {
        __weak typeof(self) weakSelf = self;
        [_sendQueue addOperationWithBlock:^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf _doWrite];
        }];
    }
}

- (void)_doWrite {
    while (([[_session outputStream] hasSpaceAvailable]) && ([_writeDataBuffer count] > 0)) {
        DDLogDebug(@"It's ok to write");
        __weak typeof(self) weakSelf = self;
        __block EACoordinatorPacket *packet;
        dispatch_sync(_dataQueue, ^{
            __strong typeof(self) strongSelf = weakSelf;
            packet = strongSelf->_writeDataBuffer[0];
            [strongSelf->_writeDataBuffer removeObjectAtIndex:0];
        });

        if (self.sendTimeinterval != 0) {
            CFAbsoluteTime timeIntervalSinceLastSend = (CFAbsoluteTimeGetCurrent() - _lastWriteTime);
            while (_lastWriteTime != 0 && timeIntervalSinceLastSend < self.sendTimeinterval) {
                DDLogDebug(@"Sleep for a while");
                usleep((self.sendTimeinterval - timeIntervalSinceLastSend) * 1000 * 1000);
                timeIntervalSinceLastSend = (CFAbsoluteTimeGetCurrent() - _lastWriteTime);
            }
        }
        
        NSInteger totoalBytesWritten = 0;
        while ([[_session outputStream] hasSpaceAvailable] && totoalBytesWritten < packet->buffer.length) {
            NSInteger bytesWritten = [[_session outputStream] write:((Byte *)[packet->buffer bytes] + totoalBytesWritten) maxLength:[packet->buffer length] - totoalBytesWritten];
            _lastWriteTime = CFAbsoluteTimeGetCurrent();
            if (bytesWritten == -1) {
                DDLogDebug(@"---- write data via External Accessory with error");
                break;
            } else {
                totoalBytesWritten += bytesWritten;
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:didSendData:withTag:)]) {
            [self.delegate coordinator:self didSendData:packet->buffer withTag:packet->tag];
        }
    }
}

- (void)_readData {
    uint8_t buf[INPUT_BUFFER_SIZE];
    NSMutableData *readData = [NSMutableData new];
    while ([[_session inputStream] hasBytesAvailable]) {
        NSInteger bytesRead = [[_session inputStream] read:buf maxLength:INPUT_BUFFER_SIZE];
        [readData appendBytes:(void *)buf length:bytesRead];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:didReceiveData:)]) {
        [self.delegate coordinator:self didReceiveData:readData];
    }
}

- (NSThread *)operationThread {
    static NSThread *_theThread;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theThread = [[NSThread alloc] initWithTarget:self selector:@selector(operationTheadEntryPoint) object:nil];
        [_theThread start];
    });
    return _theThread;
}

- (void)operationTheadEntryPoint {
    @autoreleasepool {
        [[NSThread currentThread] setName:NSStringFromClass([self class])];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

- (void)searchForAlreadyConnectedAccessory {
    for (EAAccessory *connectedAccessory in [[EAAccessoryManager sharedAccessoryManager] connectedAccessories]) {
        if ([connectedAccessory.protocolStrings containsObject:GAccessoryProtocol]) {
            _accessory = connectedAccessory;
            break;
        }
    }
    if (!_accessory) {
        return;
    }
    [self openSession];
}

- (void)openSession {
    [self performSelector:@selector(_openSession) onThread:[self operationThread] withObject:nil waitUntilDone:NO];
}

- (void)_openSession{
    DDLogDebug(@"open session, accessory: %@", _accessory);
    if (!_accessory) return;
    _accessory.delegate = self;
    _session = [[EASession alloc] initWithAccessory:_accessory forProtocol:GAccessoryProtocol];
    if (!_session) {
        DDLogDebug(@"Alloc session with error");
        return;
    }
    
    _session.inputStream.delegate = self;
    [_session.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_session.inputStream open];
    
    _session.outputStream.delegate = self;
    [_session.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_session.outputStream open];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:didConnectToAccessoryProtocol:)]) {
        [self.delegate coordinator:self didConnectToAccessoryProtocol:GAccessoryProtocol];
    }
}

- (void)closeSession {
    DDLogDebug(@"close session");
    [_session.inputStream close];
    [_session.inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _session.inputStream.delegate = nil;
    
    [_session.outputStream close];
    [_session.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    _session.outputStream.delegate = nil;
    
    _session = nil;
    _accessory.delegate = nil;
    _accessory = nil;
    
    dispatch_async(_dataQueue, ^{
        [_writeDataBuffer removeAllObjects];
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(coordinator:didDisconnectToAccessoryProtocol:)]) {
        [self.delegate coordinator:self didDisconnectToAccessoryProtocol:GAccessoryProtocol];
    }
}

#pragma mark - EAAccessory Notifications

- (void)accessoryDidConnectNotification:(NSNotification *)notification {
//    DDLogDebug(@"accessoryDidConnectNotification:%@", notification);
    if (_accessory) {
        return;
    }
    EAAccessory *connectedAccessory = [notification.userInfo objectForKey:EAAccessoryKey];
    if (![connectedAccessory.protocolStrings containsObject:GAccessoryProtocol]) {
        return;
    }
    _accessory = connectedAccessory;
    [self openSession];
}

#pragma mark - EAAccessoryDelegate

- (void)accessoryDidDisconnect:(EAAccessory *)accessory {
    DDLogDebug(@"accessoryDidDisconnect:%@", accessory);
    if (![accessory.protocolStrings containsObject:GAccessoryProtocol]) {
        return;
    }
    [self closeSession];
}

#pragma mark - NSStreamDelegateEventExtensions

// asynchronous NSStream handleEvent method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    DDLogDebug(@"stream event: %lu", (unsigned long)eventCode);
    if (aStream == _session.outputStream) {
        switch (eventCode) {
            case NSStreamEventHasSpaceAvailable:
                [self _writeData];
                break;
            case NSStreamEventErrorOccurred:
                DDLogDebug(@"--- External Accessory oupput stream encountered with an error: %@", aStream.streamError);
                break;
            default:
                break;
        }
    } else if (aStream == _session.inputStream) {
        switch (eventCode) {
            case NSStreamEventHasBytesAvailable:
                [self _readData];
                break;
            case NSStreamEventErrorOccurred:
                DDLogDebug(@"--- External Accessory input stream encountered with an error: %@", aStream.streamError);
            default:
                break;
        }
    }
}

@end
