//
//  UIImageView+KeyFrameAnimation.m
//  ATUtility
//
//  Created by arvin.tan on 9/20/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "UIImageView+KeyFrameAnimation.h"
#import <objc/runtime.h>

@interface UIImageView ()

@property (strong, nonatomic) NSString *keyframeAnimationKey;

@end

@implementation UIImageView (KeyFrameAnimation)

static void *keyTimesContext = &keyTimesContext;
- (NSArray *)keyTimes {
  return objc_getAssociatedObject(self, keyTimesContext);
}

- (void)setKeyTimes:(NSArray *)keyTimes {
  objc_setAssociatedObject(self, keyTimesContext, keyTimes, OBJC_ASSOCIATION_COPY);
}

static void *keyframeAnimationImagesContext = &keyframeAnimationImagesContext;
- (NSArray *)keyframeAnimationImages {
  return objc_getAssociatedObject(self, keyframeAnimationImagesContext);
}

- (void)setKeyframeAnimationImages:(NSArray *)keyframeAnimationImages {
  objc_setAssociatedObject(self, keyframeAnimationImagesContext, keyframeAnimationImages, OBJC_ASSOCIATION_COPY);
}

static void *keyframeAutoreversesContext = &keyframeAutoreversesContext;
- (BOOL)keyframeAutoreverses {
  return [objc_getAssociatedObject(self, &keyframeAutoreversesContext) boolValue];
}

- (void)setKeyframeAutoreverses:(BOOL)keyframeAutoreverses {
  objc_setAssociatedObject(self, keyframeAutoreversesContext, @(keyframeAutoreverses), OBJC_ASSOCIATION_RETAIN);
}

static void *keyframeAniamtionRepeatCountContext = &keyframeAniamtionRepeatCountContext;
- (float)keyframeAniamtionRepeatCount {
  return [objc_getAssociatedObject(self, keyframeAniamtionRepeatCountContext) floatValue];
}

- (void) setKeyframeAniamtionRepeatCount:(float)keyframeAniamtionRepeatCount {
  objc_setAssociatedObject(self, keyframeAniamtionRepeatCountContext, @(keyframeAniamtionRepeatCount), OBJC_ASSOCIATION_RETAIN);
}

static void *keyframeAnimationDurationContext = &keyframeAnimationDurationContext;
- (CFTimeInterval)keyframeAnimationDuration {
  return [objc_getAssociatedObject(self, keyframeAnimationDurationContext) doubleValue];
}

- (void)setKeyframeAnimationDuration:(CFTimeInterval)keyframeAnimationDuration {
  objc_setAssociatedObject(self, keyframeAnimationDurationContext, @(keyframeAnimationDuration), OBJC_ASSOCIATION_RETAIN);
}

static void *keyframeAnimationKeyContext = &keyframeAnimationKeyContext;
- (NSString *)keyframeAnimationKey {
  return objc_getAssociatedObject(self, keyframeAnimationKeyContext);
}

- (void)setKeyframeAnimationKey:(NSString *)keyframeAnimationKey {
  objc_setAssociatedObject(self, keyframeAnimationKeyContext, keyframeAnimationKey, OBJC_ASSOCIATION_RETAIN);
}

- (void)startKeyFrameAnimation {
  NSAssert(self.keyTimes.count == self.keyframeAnimationImages.count, @"keyTimes count(%lud) != keyFrameanImationImages.cout(%lud)", (unsigned long)self.keyTimes.count, (unsigned long)self.keyframeAnimationImages.count);
  NSAssert(self.keyframeAnimationDuration != 0, @"keyframeAnimationDuration(%.4f) must be setted to non-zero", self.keyframeAnimationDuration);
  CAKeyframeAnimation *imageAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
  //imageAnimation.calculationMode = kCAAnimationLinear; // or maybe kCAAnimationPaced
  imageAnimation.duration = self.keyframeAnimationDuration;
  imageAnimation.keyTimes = self.keyTimes;
  imageAnimation.repeatCount = self.keyframeAniamtionRepeatCount;
  imageAnimation.values = [self animationCGImagesArrayFromImageArray:self.keyframeAnimationImages];
  imageAnimation.autoreverses = self.keyframeAutoreverses;
  self.keyframeAnimationKey = [[NSUUID UUID] UUIDString];
  [self.layer addAnimation:imageAnimation forKey:self.keyframeAnimationKey];
}

-(NSArray*)animationCGImagesArrayFromImageArray:(NSArray*)imageArray {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:imageArray.count];
  for (UIImage *image in imageArray) {
    [array addObject:(id)[image CGImage]];
  }
  return [NSArray arrayWithArray:array];
}

- (void)stopKeyFrameAnimation {
  if (self.keyframeAnimationKey) {
    [self.layer removeAnimationForKey:self.keyframeAnimationKey];
    self.keyframeAnimationKey = nil;
  }
}

@end
