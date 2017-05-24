//
//  UIImageView+QQLBroadcastGif.m
//  TestUUID
//
//  Created by arvin.tan on 2017/5/18.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import "UIImageView+QQLBroadcastGif.h"
#import "QQLSettingsManager.h"

#if SD_UIKIT
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UIView+WebCache.h"
#import "NSData+ImageContentType.h"
#import "FLAnimatedImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (QQLBroadcastGif)

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url {
  [self qql_sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil setImageBlock:nil completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock {
  [self qql_sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil setImageBlock:setImageBlock completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder {
  [self qql_sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil setImageBlock:nil completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock {
  [self qql_sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil setImageBlock:setImageBlock completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options {
  [self qql_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil setImageBlock:nil completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock {
  [self qql_sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil setImageBlock:setImageBlock completed:nil];
}

- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                      progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock {
  
  url = [[self class] qqlReplaceHttpToHttpsIfMatch:url];
  __weak typeof(self)weakSelf = self;
  [self sd_internalSetImageWithURL:url
                  placeholderImage:placeholder
                           options:options
                      operationKey:nil
                     setImageBlock:^(UIImage *image, NSData *imageData) {
                       if (image == nil && imageData == nil) {
                         weakSelf.image = image;
                         if ([weakSelf isKindOfClass:[FLAnimatedImageView class]]) {
                           ((FLAnimatedImageView *)weakSelf).animatedImage = nil;
                         }
                         return;
                       }
                       
                       SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:imageData];
                       if (setImageBlock) {
                         setImageBlock(image, imageData, imageFormat);
                       } else {
                         if ([weakSelf isKindOfClass:[FLAnimatedImageView class]]) {
                           __weak FLAnimatedImageView *weakFLAnimatedImageView = (FLAnimatedImageView *)weakSelf;
                           if (imageFormat == SDImageFormatGIF) {
                             weakFLAnimatedImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:imageData];
                             weakFLAnimatedImageView.image = nil;
                           } else {
                             weakFLAnimatedImageView.image = image;
                             weakFLAnimatedImageView.animatedImage = nil;
                           }
                         } else {
                           weakSelf.image = image;
                         }
                       }
                     }
                          progress:progressBlock
                         completed:completedBlock];
}

+ (NSURL *)qqlReplaceHttpToHttpsIfMatch:(NSURL *)url {
  NSArray *hosts = @[@"puui.qpic.cn", @"p.qpic.cn"];
  if (![url.scheme isEqualToString:@"http"] || ![hosts containsObject:url.host] || ![QQLSettingsManager.manager.currentSettings.stage.HTTPSHostArray containsObject:url.host]) {
    return url;
  }
  return [NSURL URLWithString:[url.absoluteString stringByReplacingOccurrencesOfString:@"http" withString:@"https"]];
}

@end

#endif
