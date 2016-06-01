//
//  AdjustHitAreaButton.h
//  Test
//
//  Created by arvin.tan on 6/1/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustHitAreaButton : UIButton

@property(nonatomic) IBInspectable CGFloat topHitInset;
@property(nonatomic) IBInspectable CGFloat leftHitInset;
@property(nonatomic) IBInspectable CGFloat bottomHitInset;
@property(nonatomic) IBInspectable CGFloat rightHitInset;

@property(nonatomic) UIEdgeInsets hitEdgeInset;

@end
