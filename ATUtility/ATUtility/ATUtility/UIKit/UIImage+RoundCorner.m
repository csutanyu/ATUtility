//
//  UIImage+RoundCorner.m
//  ATUtility
//
//  Created by arvintan on 16/8/6.
//  Copyright © 2016年 arvin.tan. All rights reserved.
//

#import "UIImage+RoundCorner.h"

@implementation UIImage (RoundCorner)

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit {
    return [self imageWithRoundCornerRadius:radius sizeToFit:sizeToFit borderWidth:0 borderColor:nil];
}

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), rect);
    CGContextClosePath(UIGraphicsGetCurrentContext());
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    
    if (borderWidth > 0 && borderColor) {
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(borderWidth / 2, borderWidth / 2, sizeToFit.width - borderWidth, sizeToFit.height - borderWidth));
        CGContextClosePath(UIGraphicsGetCurrentContext());
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), borderWidth);
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), borderColor.CGColor);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outImage;
}

@end
