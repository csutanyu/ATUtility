//
//  LocalESStreamVideoProcessor.m
//  H264DecoderForiOS
//
//  Created by arvin.tan on 2/25/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "LocalESStreamVideoProcessor.h"
#import "NALU.h"

#import "H264DecoderDefine.h"

@interface LocalESStreamVideoProcessor () {
    uint8_t *_buffer;
    NSInteger _bufferSize;
    NSInteger _bufferCap;
}

@property (strong, nonatomic) NSInputStream *fileStream;
@property (strong, nonatomic) NSOperationQueue *operationQueue;
@end

@implementation LocalESStreamVideoProcessor

- (instancetype)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        NSAssert([filePath length] > 0, @"filePath cannot be nil or empty");
        self.filePath = filePath;
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)open {
    _bufferSize = 0;
    _bufferCap = 512 * 1024;
    _buffer = malloc(_bufferCap);
    self.fileStream = [NSInputStream inputStreamWithFileAtPath:self.filePath];
    [self.fileStream open];
}

- (void)startProcess {
    __weak typeof(self)weakSelf = self;
    [self.operationQueue addOperationWithBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf open];
        for (NALU * nalu = [strongSelf nextPacket]; nalu; nalu = [strongSelf nextPacket]) {
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(videoPreprocessor:didReceiveNALU:)]) {
                [self.delegate videoPreprocessor:strongSelf didReceiveNALU:nalu];
            }
            sleep(0.04);
        }
        [strongSelf close];
    }];
}

- (NALU*)nextPacket {
    if(_bufferSize < _bufferCap && self.fileStream.hasBytesAvailable) {
        NSInteger readBytes = [self.fileStream read:_buffer + _bufferSize maxLength:_bufferCap - _bufferSize];
        _bufferSize += readBytes;
    }
    
    if(memcmp(_buffer, NALUStartCode, 4) != 0) {
        return nil;
    }
    
    if(_bufferSize >= 5) {
        uint8_t *bufferBegin = _buffer + 4;
        uint8_t *bufferEnd = _buffer + _bufferSize;
#if 1
        while(bufferBegin != bufferEnd) {
            if(*bufferBegin == 0x01) {
                if(memcmp(bufferBegin - 3, NALUStartCode, 4) == 0) {
                    NSInteger packetSize = bufferBegin - _buffer - 3;
                    NALU *vp = [[NALU alloc] initWithBuffer:_buffer size:packetSize];
                    memmove(_buffer, _buffer + packetSize, _bufferSize - packetSize);
                    _bufferSize -= packetSize;
                    
                    return vp;
                }
            }
            ++bufferBegin;
        }
#else
        while (bufferEnd - bufferBegin + 1 >= sizeof(KStartCode)) {
            if (memcmp((void *)KStartCode, bufferBegin, sizeof(KStartCode))) {
                if(memcmp(bufferBegin - 3, KStartCode, 4) == 0) {
                    NSInteger packetSize = bufferBegin - _buffer - 3;
                    NALU *vp = [[NALU alloc] initWithBuffer:_buffer size:packetSize];
                    memmove(_buffer, _buffer + packetSize, _bufferSize - packetSize);
                    _bufferSize -= packetSize;
                    
                    return vp;
                }
            } else {
                ++bufferBegin;
            }
        }
#endif
    }
    
    return nil;
}

-(void)close {
    free(_buffer);
    [self.fileStream close];
}

@end
