//
//  LumberjackLogFormatter.m
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "LumberjackLogFormatter.h"
#import <libkern/OSAtomic.h>

static NSString *DateFormatString = @"yyyy/MM/dd HH:mm:ss:SSS";

@interface LumberjackLogFormatter () {
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}

@end

@implementation LumberjackLogFormatter


- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:DateFormatString];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:DateFormatString];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"Error"; break;
        case DDLogFlagWarning  : logLevel = @"Waring"; break;
        case DDLogFlagInfo     : logLevel = @"Info"; break;
        case DDLogFlagDebug    : logLevel = @"Debug"; break;
        default                : logLevel = @"Verbose"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    NSString *logMsg = logMessage->_message;
    
    return [NSString stringWithFormat:@"%@ | %@ %@ line %lu %@ | %@\n", logLevel, logMessage->_fileName, logMessage->_function, (unsigned long)logMessage->_line, dateAndTime, logMsg];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end
