//
//  ATSpinLock.m
//  QLVEngine
//
//  Created by arvin.tan on 2017/11/20.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "ATSpinLock.h"

inline bool ATSpinLockTryLock( volatile ATSpinLock *__lock ) {
#if TARGET_OS_IPHONE
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
    return os_unfair_lock_trylock((ATSpinLock *)__lock);
#else
    return OSSpinLockTry(__lock);
#endif
#elif TARGET_OS_MAC
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_12
    return os_unfair_lock_trylock(__lock);
#else
    return OSSpinLockTry(__lock);
#endif
#endif
}


inline void ATSpinLockLock( volatile ATSpinLock *__lock ) {
#if TARGET_OS_IPHONE
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
    os_unfair_lock_lock((ATSpinLock *)__lock);
#else
    OSSpinLockLock(__lock);
#endif
#elif TARGET_OS_MAC
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_12
    os_unfair_lock_lock(__lock);
#else
    OSSpinLockLock(__lock);
#endif
#endif
}


inline void ATSpinLockUnlock( volatile ATSpinLock *__lock ) {
#if TARGET_OS_IPHONE
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
    os_unfair_lock_unlock((ATSpinLock *)__lock);
#else
    OSSpinLockUnlock(__lock);
#endif
#elif TARGET_OS_MAC
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_12
    os_unfair_lock_unlock(__lock);
#else
    OSSpinLockUnlock(__lock);
#endif
#endif
}
