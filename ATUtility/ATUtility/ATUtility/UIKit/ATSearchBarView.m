//
//  ATSearchBarView.m
//  ATUtility
//
//  Created by arvin.tan on 2017/9/29.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import "ATSearchBarView.h"

@interface ATSearchBarView ()
@property (strong, nonatomic) UIImageView *leftImageView;
@end

@implementation ATSearchBarView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self commanInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self commanInit];
  }
  return self;
}

- (instancetype)init {
  if (self = [super init]) {
    [self commanInit];
  }
  return self;
}

- (CGFloat)searchIconLeftInset {
  if (_searchIconLeftInset == 0) {
    _searchIconLeftInset = 12;
  }
  return _searchIconLeftInset;
}

- (CGFloat)searchIconRightInset {
  if (_searchIconRightInset == 0) {
    _searchIconRightInset = 10;
  }
  return _searchIconRightInset;
}

- (void)commanInit {
  self.returnKeyType = UIReturnKeySearch;
  self.borderStyle = UITextBorderStyleNone;
  self.background = self.backgroundImage;
  UIImage *leftImage = self.searchIconImage;
  self.leftImageView = [[UIImageView alloc] initWithImage:leftImage];
  self.leftImageView.frame = CGRectMake(self.searchIconLeftInset, 0, leftImage.size.width, leftImage.size.height);
  self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width + self.searchIconLeftInset + self.searchIconRightInset, leftImage.size.height)];
  [self.leftView addSubview:self.leftImageView];
  self.leftViewMode = UITextFieldViewModeAlways;
  self.clearButtonMode = UITextFieldViewModeWhileEditing;
  
  // Add a "textFieldDidChange" notification method to the text field control.
  [self addTarget:self
           action:@selector(textFieldDidChange:)
 forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
  if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidChange:)]) {
    [self.delegate textFieldDidChange:self];
  }
}

@end
