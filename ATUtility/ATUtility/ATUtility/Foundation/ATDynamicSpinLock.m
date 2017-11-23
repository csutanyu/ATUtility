//
//  ATDynamicSpinLock.m
//  ATUtility
//
//  Created by arvin.tan on 2017/11/23.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import "ATDynamicSpinLock.h"
#import <os/lock.h>
#import <libkern/OSAtomic.h>


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
@interface ATDynamicSpinLock ()

@property (nonatomic) os_unfair_lock unfairLock;
@property (nonatomic) OSSpinLock spinLock;

@end

NS_INLINE BOOL isThereUnfairLock() {
    NSOperatingSystemVersion version;
#if TARGET_OS_IPHONE
    version.majorVersion = 10;
    version.minorVersion = 0;
    version.patchVersion = 0;
#elif TARGET_OS_MAC
    version.majorVersion = 10;
    version.minorVersion = 12;
    version.patchVersion = 0;
#elif TARGET_OS_WATCH
    version.majorVersion = 3;
    version.minorVersion = 0;
    version.patchVersion = 0;
#elif TARGET_OS_TV
    version.majorVersion = 10;
    version.minorVersion = 0;
    version.patchVersion = 0;
#else
    version.majorVersion = 1;
    version.minorVersion = 0;
    version.patchVersion = 0;
#endif
    return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
}

@implementation ATDynamicSpinLock

- (instancetype)init {
    if (self = [super init]) {
        if (isThereUnfairLock()) {
            self.unfairLock = OS_UNFAIR_LOCK_INIT;
        } else {
            self.spinLock = OS_SPINLOCK_INIT;
        }
    }
    return self;
}

- (BOOL)tryLock {
    if (isThereUnfairLock()) {
        return os_unfair_lock_trylock(&_unfairLock);
    } else {
        return OSSpinLockTry(&_spinLock);
    }
}

- (void)lock {
    if (isThereUnfairLock()) {
        os_unfair_lock_lock(&_unfairLock);
    } else {
        OSSpinLockLock(&_spinLock);
    }
}

- (void)unlock {
    if (isThereUnfairLock()) {
        os_unfair_lock_unlock(&_unfairLock);
    } else {
        OSSpinLockUnlock(&_spinLock);
    }
}

@end
#pragma clang diagnostic pop
