//
//  ATSearchBarView.h
//  ATUtility
//
//  Created by arvin.tan on 2017/9/29.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATSearchBarViewDelegate<UITextFieldDelegate>
@optional
- (void)textFieldDidChange:(UITextField *)textField;
@end

@interface ATSearchBarView : UITextField
@property (nonatomic) IBInspectable CGFloat searchIconLeftInset; // Default 12
@property (nonatomic) IBInspectable CGFloat searchIconRightInset; // Default 10
@property (strong, nonatomic) IBInspectable UIImage *searchIconImage; // Default "tianjiahuati_search"
@property (strong, nonatomic) IBInspectable UIImage *backgroundImage; // Default "search_di"
@property (weak, nonatomic) id<ATSearchBarViewDelegate> delegate;
@end
