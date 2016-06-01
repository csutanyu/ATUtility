//
//  AdjustHitAreaButton.m
//  Test
//
//  Created by arvin.tan on 6/1/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "AdjustHitAreaButton.h"
#import <objc/runtime.h>

@implementation AdjustHitAreaButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)commanInit {
    _hitEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)topHitInset {
    return _hitEdgeInset.top;
}

- (void)setTopHitInset:(CGFloat)topHitInset {
    _hitEdgeInset.top = topHitInset;
}

- (CGFloat)leftHitInset {
    return _hitEdgeInset.left;
}

- (void)setLeftHitInset:(CGFloat)leftHitInset {
    _hitEdgeInset.left = leftHitInset;
}

- (CGFloat)bottomHitInset {
    return _hitEdgeInset.bottom;
}

- (void)setBottomHitInset:(CGFloat)bottomHitInset {
    _hitEdgeInset.bottom = bottomHitInset;
}

- (CGFloat)rightHitInset {
    return _hitEdgeInset.right;
}

- (void)setRightHitInset:(CGFloat)rightHitInset {
    _hitEdgeInset.right = rightHitInset;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(!self.enabled || self.hidden || UIEdgeInsetsEqualToEdgeInsets(_hitEdgeInset, UIEdgeInsetsZero)) {
        return [super pointInside:point withEvent:event];
    }

    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, _hitEdgeInset);
    
    return CGRectContainsPoint(hitFrame, point);
}

@end
