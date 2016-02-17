//
//  UIWindow+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 1/19/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "UIWindow+ATUtility.h"

@implementation UIWindow (ATUtility)

- (void)addTrasitionAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.layer addAnimation:transition forKey:nil];
}

@end
