//
//  ATDynamicSpinLock.h
//  ATUtility
//
//  Created by arvin.tan on 2017/11/23.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATDynamicSpinLock : NSObject <NSLocking>

- (BOOL)tryLock;

@end
