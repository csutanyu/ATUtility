//
//  NSObject+ATUtility.m
//  ATUtility
//
//  Created by tanyu on 7/5/15.
//

#import "NSObject+ATUtility.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>

static void *KeyboardWillShowHandlerKey = &KeyboardWillShowHandlerKey;
static void *KeyboardWillHideHandlerKey = &KeyboardWillHideHandlerKey;

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

#pragma mark - Keyboard

- (NSObjectKeyboardWillShowHandler)keyboardWillShowHandler {
    return objc_getAssociatedObject(self, &KeyboardWillShowHandlerKey);
}

- (void)setKeyboardWillShowHandler:(NSObjectKeyboardWillShowHandler)keyboardWillShowHandler {
    [self willChangeValueForKey:@"keyboardWillShowHandler"];
    objc_setAssociatedObject(self, &KeyboardWillShowHandlerKey, keyboardWillShowHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"keyboardWillShowHandler"];
}

- (NSObjectKeyboardWillHideHandler)keyboardWillHideHandler {
    return objc_getAssociatedObject(self, &KeyboardWillHideHandlerKey);
}

- (void)setKeyboardWillHideHandler:(NSObjectKeyboardWillHideHandler)keyboardWillHideHandler {
    [self willChangeValueForKey:@"keyboardWillHideHandler"];
    objc_setAssociatedObject(self, &KeyboardWillHideHandlerKey, keyboardWillHideHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"keyboardWillHideHandler"];
}

- (void)dismissKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)addObserverWithKeyboardWillShowHandler:(NSObjectKeyboardWillShowHandler)showHandler keyboardWillHideHandler:(NSObjectKeyboardWillHideHandler)hideHandler {
    if (self.keyboardWillShowHandler == nil) {
        self.keyboardWillShowHandler = showHandler;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    if (self.keyboardWillHideHandler == nil) {
        self.keyboardWillHideHandler = hideHandler;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeObserverForKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.keyboardWillShowHandler = nil;
    self.keyboardWillHideHandler = nil;
}

- (void)keyboardWillShowAction:(NSNotification *)notification {
    if (self.keyboardWillShowHandler) {
        self.keyboardWillShowHandler(notification);
    }
}

- (void)keyboardWillHideAction:(NSNotification *)notification {
    if (self.keyboardWillHideHandler) {
        self.keyboardWillHideHandler(notification);
    }
}


#pragma mark - Directory

- (NSString *)cachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSString *)documentsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSURL *)cacheURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Project Info

/*
 Recommended Keys for iOS Apps
 It is recommended that an iOS app include the following keys in its information property list file. Most are set by Xcode automatically when you create your project.
 
 CFBundleDevelopmentRegion
 CFBundleDisplayName
 CFBundleExecutable
 CFBundleIconFiles
 CFBundleIdentifier
 CFBundleInfoDictionaryVersion
 CFBundlePackageType
 CFBundleVersion
 LSRequiresIPhoneOS
 UIMainStoryboardFile
 In addition to these keys, there are several that are commonly included:
 
 UIRequiredDeviceCapabilities (required)
 UIStatusBarStyle
 UIInterfaceOrientation
 UIRequiresPersistentWiFi
 */

+ (NSString *)bundleShortVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleDisplayName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)launchImageName {
    NSString *launchImageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImageFile"];
    NSMutableString *result = nil;
    if (launchImageName.length > 0) {
        if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
            result = [launchImageName mutableCopy];
            NSRange range = [result rangeOfString:@"." options:NSBackwardsSearch];
            NSUInteger length = range.length;
            NSUInteger location = range.location;
            if (length > 0 && location > 0 && location < result.length - 1) {
                [result insertString:@"-568h" atIndex:location];
            }
            return [result copy];
        } else {
            return launchImageName;
        }
    } else {
        return nil;
    }
}

- (NSString *)bundleShortVersion {
    return [[self class] bundleShortVersion];
}

- (NSString *)bundleVersion {
    return [[self class] bundleVersion];
}

- (NSString *)bundleName {
    return [[self class] bundleName];
}

- (NSString *)bundleDisplayName {
    return [[self class] bundleDisplayName];
}

- (NSString *)bundleIdentifier {
    return [[self class] bundleIdentifier];
}

- (NSString *)launchImageName {
    return [[self class] launchImageName];
}

@end
