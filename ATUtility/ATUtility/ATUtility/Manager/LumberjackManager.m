//
//  LumberjackManager.m
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "LumberjackManager.h"
#import "LumberjackLogFormatter.h"

@interface LumberjackManager ()

@property (strong, nonatomic) DDFileLogger *fileLogger;

@end

@implementation LumberjackManager

+ (void)initTheLogSystem {
    [self share];
}

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static LumberjackManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (DDFileLogger *)fileLogger {
    return [[self share] fileLogger];
}

- (instancetype)init {
    if (self = [super init]) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        self.fileLogger = [[DDFileLogger alloc] init];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
        
        // if we use two formater object, then there is no multi-thread issue, and won't use thread local variable
        [DDTTYLogger sharedInstance].logFormatter = [LumberjackLogFormatter new];
        _fileLogger.logFormatter = [LumberjackLogFormatter new];
    }
    return self;
}

@end
