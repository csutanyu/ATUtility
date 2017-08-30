//
//  PaddingLabel.m
//  ATUtility
//
//  Created by arvin.tan on 2017/8/30.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel

- (void)drawRect:(CGRect)rect {
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(_topInset, _leftInset, _bottomInset, _rightInset))];
}

-(CGSize)intrinsicContentSize{
  CGSize contentSize = [super intrinsicContentSize];
  return CGSizeMake(contentSize.width + _leftInset + _rightInset, contentSize.height + _topInset + _bottomInset);
}

@end
