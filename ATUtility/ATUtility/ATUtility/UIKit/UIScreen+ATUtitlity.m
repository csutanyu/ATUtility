//
//  UIScreen+ATUtitlity.m
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "UIScreen+ATUtitlity.h"

@implementation UIScreen (ATUtitlity)

+ (ScreenType)screenType {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = MAX(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    if (screenHeight >= 736) {
        return ScreenType5_5;
    } else if (screenHeight >= 667) {
        return ScreenType4_7;
    } else if (screenHeight >= 568) {
        return ScreenType4_0;
    } else {
        return ScreenType3_5;
    }
}

@end
