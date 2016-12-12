//
//  UIView+ATUTility.m
//  ATUtility
//
//  Created by arvin.tan on 7/3/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import "UIView+ATUtility.h"

@implementation UIView (ATUtility)

- (void)addDashLineInPosition:(LinePosition)position unitLength:(CGFloat)unitLength lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (position & LinePositionBottom) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height - lineWidth / 2)];
        while (path.currentPoint.x < self.frame.size.width) {
            [path addLineToPoint:CGPointMake(MIN(self.frame.size.width, path.currentPoint.x + unitLength), path.currentPoint.y)];
            [path moveToPoint:CGPointMake(path.currentPoint.x + unitLength, path.currentPoint.y)];
        }
    }
    if (position & LinePositionLeft) {
        [path moveToPoint:CGPointMake(lineWidth / 2, 0)];
        while (path.currentPoint.y < self.frame.size.height) {
            [path addLineToPoint:CGPointMake(path.currentPoint.x, MIN(self.frame.size.height,path.currentPoint.y + unitLength))];
            [path moveToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y + unitLength)];
        }
    }
    if (position & LinePositionTop) {
        [path moveToPoint:CGPointMake(0, lineWidth / 2)];
        while (path.currentPoint.x < self.frame.size.width) {
            [path addLineToPoint:CGPointMake(MIN(self.frame.size.width, path.currentPoint.x + unitLength), path.currentPoint.y)];
            [path moveToPoint:CGPointMake(path.currentPoint.x + unitLength, path.currentPoint.y)];
        }
    }
    if (position & LinePositionRight) {
        [path moveToPoint:CGPointMake(self.frame.size.width - lineWidth / 2, 0)];
        while (path.currentPoint.y < self.frame.size.height) {
            [path addLineToPoint:CGPointMake(path.currentPoint.x, MIN(self.frame.size.height, path.currentPoint.y + unitLength))];
            [path moveToPoint:CGPointMake(path.currentPoint.x, path.currentPoint.y + unitLength)];
        }
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
}

- (void)addSolidLineInPosition:(LinePosition)position lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (position & LinePositionBottom) {
        [path moveToPoint:CGPointMake(0, self.frame.size.height - lineWidth / 2)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, path.currentPoint.y)];
    }
    if (position & LinePositionLeft) {
        [path moveToPoint:CGPointMake(lineWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(path.currentPoint.x, self.frame.size.height)];
    }
    if (position & LinePositionTop) {
        [path moveToPoint:CGPointMake(0, lineWidth / 2)];
        [path addLineToPoint:CGPointMake(self.frame.size.width, path.currentPoint.y)];
    }
    if (position & LinePositionRight) {
        [path moveToPoint:CGPointMake(self.frame.size.width - lineWidth / 2, 0)];
        [path addLineToPoint:CGPointMake(path.currentPoint.x, self.frame.size.height)];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:shapeLayer];
}

- (void)addBorderWithWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius color:(UIColor *) borderColor {
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)addDashLineInPosition:(LinePosition)position unitLength:(CGFloat)unitLength lineWidth:(CGFloat)lineWidth color:(UIColor *)color scale:(BOOL)scale {
  [self addDashLineInPosition:position unitLength:unitLength lineWidth: scale ? lineWidth / [UIScreen mainScreen].scale : lineWidth color:color];
}

- (void)addSolidLineInPosition:(LinePosition)position lineWidth:(CGFloat)lineWidth color:(UIColor *)color scale:(BOOL)scale {
  [self addSolidLineInPosition:position lineWidth:scale ? lineWidth / [UIScreen mainScreen].scale : lineWidth color:color];
}

- (void)addBorderWithWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius color:(UIColor *) borderColor scale:(BOOL)scale {
  [self addBorderWithWidth:scale ? borderWidth / [UIScreen mainScreen].scale : borderWidth cornerRadius:cornerRadius color:borderColor];
}


- (UIImage * _Null_unspecified)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
