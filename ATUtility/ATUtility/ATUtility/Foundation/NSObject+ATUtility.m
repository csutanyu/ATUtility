//
//  NSObject+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 7/13/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import "NSObject+ATUtility.h"
#import <AudioToolbox/AudioToolbox.h>


@implementation NSObject (ATUtility)

- (void)playSystemSoundWithPath:(NSString *)path {
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
