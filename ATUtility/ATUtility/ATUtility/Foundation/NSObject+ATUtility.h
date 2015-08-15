//
//  NSObject+ATUtility.h
//  ATUtility
//
//  Created by tanyu on 7/5/15.
//

#import <Foundation/Foundation.h>

@interface NSObject (ATUtility)

// System sound
- (void)playSystemSoundWithPath:(NSString *)path;
- (void)vibrate;

// Keyboard
- (void)dismissKeyBoard;

@end
