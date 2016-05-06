//
//  UIScreen+ATUtitlity.h
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScreenType) {
    ScreenType3_5,
    ScreenType4_0,
    ScreenType4_7,
    ScreenType5_5
};

@interface UIScreen (ATUtitlity)

+ (ScreenType)screenType;

@end
