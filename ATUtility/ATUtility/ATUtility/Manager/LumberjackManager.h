//
//  LumberjackManager.h
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"


#if DEBUG || DAILYBUILD
#define EnableLogExportUI 1
#else
#define EnableLogExportUI 0
#endif

// if you want some files has a diffrent log level, please add a new define in the .m:
// #define ddLogLevel  NewLogLevel


#if DEBUG
static DDLogLevel ddLogLevel = DDLogLevelDebug;
#elif  DAILYBUILD
static DDLogLevel ddLogLevel = DDLogLevelInfo;
#else
static DDLogLevel ddLogLevel = DDLogLevelError;
#endif

@interface LumberjackManager : NSObject

+ (void)initTheLogSystem;
+ (DDFileLogger *)fileLogger;

@end
