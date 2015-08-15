//
//  NSObject+ATUtility.m
//  ATUtility
//
//  Created by tanyu on 7/5/15.
//

#import "NSObject+ATUtility.h"
#import <UIKit/UIKit.h>
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

- (void)dismissKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
