//
//  NSObject+ATUtility.h
//  ATUtility
//
//  Created by tanyu on 7/5/15.
//

#import <Foundation/Foundation.h>

typedef void(^NSObjectKeyboardWillShowHandler)(NSNotification *notification);
typedef void(^NSObjectKeyboardWillHideHandler)(NSNotification *notification);

@interface NSObject (ATUtility)

#pragma mark - System sound

- (void)playSystemSoundWithPath:(NSString *)path;
- (void)vibrate;

#pragma makr - Keyboard

- (void)dismissKeyBoard;

- (void)addObserverWithKeyboardWillShowHandler:(NSObjectKeyboardWillShowHandler)showHandler keyboardWillHideHandler:(NSObjectKeyboardWillHideHandler)hideHandler;
- (void)removeObserverForKeyboard;


#pragma mark - Access user space in SandBox

- (NSString *)cachePath;
- (NSString *)documentsPath;
- (NSURL *)cacheURL;
- (NSURL *)documentsURL;

#pragma mark - Project Info

+ (NSString *)bundleShortVersion;
+ (NSString *)bundleVersion;
+ (NSString *)bundleName;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleIdentifier;
+ (NSString *)launchImageName;

- (NSString *)bundleShortVersion;
- (NSString *)bundleVersion;
- (NSString *)bundleName;
- (NSString *)bundleDisplayName;
- (NSString *)bundleIdentifier;
- (NSString *)launchImageName;

@end
