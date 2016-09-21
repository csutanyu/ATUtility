//
//  UIImageView+KeyFrameAnimation.h
//  ATUtility
//
//  Created by arvin.tan on 9/20/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (KeyFrameAnimation)
@property (strong, nonatomic) NSArray *keyTimes;
@property (strong, nonatomic) NSArray *keyframeAnimationImages;
@property (nonatomic) BOOL keyframeAutoreverses; // Default NO
@property (nonatomic) float keyframeAniamtionRepeatCount;
@property (nonatomic) CFTimeInterval keyframeAnimationDuration;
- (void)startKeyFrameAnimation;
- (void)stopKeyFrameAnimation;
@end
