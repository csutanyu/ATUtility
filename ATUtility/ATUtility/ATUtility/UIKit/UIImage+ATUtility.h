//
//  UIImage+ATUtility.h
//  ATUtility
//
//  Created by arvin.tan on 15/11/20.
//  Copyright © 2015年 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

// http://code4app.com/ios/%E5%90%8E%E5%8F%B0%E6%A8%A1%E7%B3%8A%E6%95%88%E6%9E%9C/54912828933bf0d5388b4f25

@interface UIImage (Blur)

/*
 1.白色,参数:
 透明度 0~1,  0为白,   1为深灰色
 半径:默认30,推荐值 3   半径值越大越模糊 ,值越小越清楚
 色彩饱和度(浓度)因子:  0是黑白灰, 9是浓彩色, 1是原色  默认1.8
 “彩度”，英文是称Saturation，即饱和度。将无彩色的黑白灰定为0，最鲜艳定为9s，这样大致分成十阶段，让数值和人的感官直觉一致。
 */
- (UIImage *)imageWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;
- (UIImage *)imageWithBlur;
/*
 *  @factor The factor is (0, 1]
 */
- (UIImage *)cgScaledImageWithScaleFactor:(CGFloat)factor;
- (UIImage *)uiScaledImageWithScaleFactor:(CGFloat)factor;

- (UIImage *)scanedImageWithMaxBytes:(NSUInteger)maxBytes;

- (UIImage *)imageWithGaussianBlurWithRadius:(NSNumber *)radius;

@end

@interface UIImage (Alpha)

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

@end

@interface UIImage (RoundCorner)

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit;

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

@interface UIImage (Color)

+ (UIImage *)imageFromColor:(UIColor *)color;

@end
