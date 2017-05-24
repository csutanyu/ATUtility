//
//  UIImageView+ClickToFullScreen.m
//  TestUUID
//
//  Created by arvin.tan on 2017/5/19.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import "UIImageView+ClickToFullScreen.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <objc/runtime.h>

@interface UIImageView (ClickToFullScreen_Private)
@property (strong, nonatomic) UITapGestureRecognizer *scaleScaleTapGetsture;
@property (nonatomic) CGRect defaultFrame;
@property (strong, nonatomic) UIImageView *fakeOriginalLittleImageView;
@end

@implementation UIImageView (ClickToFullScreen)

static void *DurationContext = &DurationContext;

- (NSTimeInterval)duration {
  id object = objc_getAssociatedObject(self, DurationContext);
  return object ? [object doubleValue] : 0.3;
}

- (void)setDuration:(NSTimeInterval)duration {
  objc_setAssociatedObject(self, DurationContext, @(duration), OBJC_ASSOCIATION_RETAIN);
}

static void *BigImageContext = &BigImageContext;

- (FLAnimatedImage *)bigAnimatedImage {
  id object = objc_getAssociatedObject(self, BigImageContext);
  if ([object isKindOfClass:[FLAnimatedImage class]]) {
    return (FLAnimatedImage *)object;
  } else {
    return nil;
  }
}

- (void)setBigAnimatedImage:(FLAnimatedImage *)bigAnimatedImage {
  objc_setAssociatedObject(self, BigImageContext, bigAnimatedImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)bigImage {
  id object = objc_getAssociatedObject(self, BigImageContext);
  if ([object isKindOfClass:[UIImage class]]) {
    return (UIImage *)object;
  } else {
    return nil;
  }
}

- (void)setBigImage:(UIImage *)bigImage {
  objc_setAssociatedObject(self, BigImageContext, bigImage, OBJC_ASSOCIATION_RETAIN);
}

static void *DefaultFrameContext = &DefaultFrameContext;

- (CGRect)defaultFrame {
  NSValue *value = objc_getAssociatedObject(self, DefaultFrameContext);
  return value ? [value CGRectValue] : CGRectZero;
}

- (void)setDefaultFrame:(CGRect)defaultFrame {
  objc_setAssociatedObject(self, DefaultFrameContext, [NSValue valueWithCGRect:defaultFrame], OBJC_ASSOCIATION_RETAIN);
}

static void *FakeOriginalLittleImageViewContext = &FakeOriginalLittleImageViewContext;

- (UIImageView *)fakeOriginalLittleImageView {
  return objc_getAssociatedObject(self, FakeOriginalLittleImageViewContext);
}

- (void)setFakeOriginalLittleImageView:(UIImageView *)fakeOriginalLittleImageView {
  objc_setAssociatedObject(self, FakeOriginalLittleImageViewContext, fakeOriginalLittleImageView, OBJC_ASSOCIATION_RETAIN);
}

static void *ClickAbleContext = &ClickAbleContext;

- (BOOL)clickable {
  return [objc_getAssociatedObject(self, ClickAbleContext) boolValue];
}
- (void)setClickable:(BOOL)clickable {
  if (self.clickable == clickable) {
    return;
  }
  
  if (clickable) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIt:)];
    [tap setNumberOfTapsRequired:1];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    self.scaleScaleTapGetsture = tap;
  } else {
    if (self.scaleScaleTapGetsture) {
      [self removeGestureRecognizer:self.scaleScaleTapGetsture];
      self.userInteractionEnabled = NO;
    }
  }
}

static void *ScaleTapGetstureContext = &ScaleTapGetstureContext;

- (UIGestureRecognizer *)scaleScaleTapGetsture {
  return objc_getAssociatedObject(self, ScaleTapGetstureContext);
}

- (void)setScaleScaleTapGetsture:(UITapGestureRecognizer *)scaleScaleTapGetsture {
  objc_setAssociatedObject(self, ScaleTapGetstureContext, scaleScaleTapGetsture, OBJC_ASSOCIATION_RETAIN);
}

- (void)tapIt:(UIGestureRecognizer*)sender {
  [self showInFullScreen];
}

- (void)showInFullScreen {
  UIImage *image = self.image;
    
  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
  self.defaultFrame = [self convertRect:self.bounds toView:window];//关键代码，坐标系转换
  backgroundView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
  backgroundView.alpha = 0;
  self.fakeOriginalLittleImageView = self;
  
  UIImageView *imageView;
  if ([self isKindOfClass:[FLAnimatedImageView class]] && (FLAnimatedImageView *)self.animationImages) {
    FLAnimatedImageView *flself = (FLAnimatedImageView *)self;
    imageView = [[FLAnimatedImageView alloc] initWithFrame:self.defaultFrame];
    ((FLAnimatedImageView *)imageView).animatedImage = self.bigAnimatedImage ?: flself.animatedImage;
  } else {
    imageView = [[UIImageView alloc]initWithFrame:self.defaultFrame];
    imageView.image = self.bigImage ?: self.image;
  }
  
  imageView.tag = 1;
  [backgroundView addSubview:imageView];
  [window addSubview:backgroundView];
  
  UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
  [backgroundView addGestureRecognizer:tap];
  
  [UIView animateWithDuration:self.duration animations:^{
    self.alpha = 0;
    if (image.size.height < [UIScreen mainScreen].bounds.size.height && image.size.width < [UIScreen mainScreen].bounds.size.width) {
      imageView.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width-image.size.width)/2,([UIScreen mainScreen].bounds.size.height-image.size.height)/2, image.size.width, image.size.height);
    } else {
      imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
    }
    backgroundView.alpha=1;
  } completion:^(BOOL finished) {
  }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
  UIView *backgroundView = tap.view;
  UIImageView *imageView = (UIImageView*)[tap.view viewWithTag:1];
  [UIView animateWithDuration:self.duration animations:^{
    imageView.frame = self.defaultFrame;
    backgroundView.alpha = 0;
  } completion:^(BOOL finished) {
    ((UIImageView*)self.fakeOriginalLittleImageView).alpha = 1;
    [backgroundView removeFromSuperview];
    imageView.hidden = YES;
  }];
}

@end
