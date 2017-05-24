//
//  UIImageView+ClickToFullScreen.h
//  TestUUID
//
//  Created by arvin.tan on 2017/5/19.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface UIImageView (ClickToFullScreen)

@property (nonatomic) NSTimeInterval duration; //动画时间，默认0.3

// YES时，点击图片有放大到全屏的动画效果，再次点击缩小到原始坐标动画效果
@property (nonatomic) BOOL clickable;

/**
 以下两个参数表示全屏大图时使用的图片资源，只有一个有产生效果。
 
 如果ImageView是FLAnimatedImageView且self.animationImages != nil时，bigAnimatedImage有效；
 如果ImageView是FLAnimatedImageView且self.animationImages == nil时 或者 ImageView是UIImageView时，bigImage有效；
 如果此两者都为空，则全屏的时候根据情况使用self.animationImages或者self.image
 */
@property (strong, nonatomic) FLAnimatedImage *bigAnimatedImage;
@property (strong, nonatomic) UIImage *bigImage;

- (void)showInFullScreen;

@end
