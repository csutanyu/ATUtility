//
//  ATSpinLock.h
//  QLVEngine
//
//  Created by arvin.tan on 2017/11/20.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_10_0
#import <os/lock.h>
typedef os_unfair_lock ATSpinLock;
#define ATSpinLockInit OS_UNFAIR_LOCK_INIT;
#else
#import <libkern/OSAtomic.h>
#define ATSpinLockInit OS_SPINLOCK_INIT;
typedef OSSpinLock ATSpinLock;
#endif

#elif TARGET_OS_MAC

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_12
#import <os/lock.h>
typedef os_unfair_lock ATSpinLock;
#define ATSpinLockInit OS_UNFAIR_LOCK_INIT;
#else
#import <libkern/OSAtomic.h>
#define ATSpinLockInit OS_SPINLOCK_INIT;
typedef OSSpinLock ATSpinLock;
#endif

#endif

FOUNDATION_EXTERN bool ATSpinLockTryLock( volatile ATSpinLock *__lock );
FOUNDATION_EXTERN void ATSpinLockLock( volatile ATSpinLock *__lock );
FOUNDATION_EXTERN void ATSpinLockUnlock( volatile ATSpinLock *__lock );

