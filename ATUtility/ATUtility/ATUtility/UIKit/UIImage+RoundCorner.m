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
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill);
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    return outImage;
}

@end
