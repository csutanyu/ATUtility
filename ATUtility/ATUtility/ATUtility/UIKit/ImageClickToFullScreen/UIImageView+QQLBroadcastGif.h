//
//  UIImageView+QQLBroadcastGif.h
//  TestUUID
//
//  Created by arvin.tan on 2017/5/18.
//  Copyright © 2017年 arvin.tan. All rights reserved.
//

#import <SDWebImage/SDWebImageCompat.h>

#if SD_UIKIT

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
#import <FLAnimatedImage/FLAnimatedImage.h>
#else
#import "FLAnimatedImageView.h"
#endif

#import "SDWebImageManager.h"
#import <NSData+ImageContentType.h>


/**
 *  A category for the FLAnimatedImage imageView class that hooks it to the SDWebImage system.
 *  Very similar to the base class category (UIImageView (WebCache))
 */
@interface UIImageView (QQLBroadcastGif)

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock;


/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url         The url for the image.
 *  @param placeholder The image to be set initially, until the image request finishes.
 *  @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url         The url for the image.
 *  @param placeholder The image to be set initially, until the image request finishes.
 *  @param options     The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 *  @param setImageBlock  Block used for custom set image code
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock;

/**
 * Load the image at the given url (either from cache or download) and load it in this imageView. It works with both static and dynamic images
 * The download is asynchronous and cached.
 * Uses a placeholder until the request finishes.
 *
 *  @param url            The url for the image.
 *  @param placeholder    The image to be set initially, until the image request finishes.
 *  @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 *  @param progressBlock  A block called while image is downloading
 *                        @note the progress block is executed on a background queue
 *  @param setImageBlock  Block used for custom set image code
 *  @param completedBlock A block called when operation has been completed. This block has no return value
 *                        and takes the requested UIImage as first parameter. In case of error the image parameter
 *                        is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                        indicating if the image was retrieved from the local cache or from the network.
 *                        The fourth parameter is the original image url.
 */
- (void)qql_sd_setImageWithURL:(nullable NSURL *)url
              placeholderImage:(nullable UIImage *)placeholder
                       options:(SDWebImageOptions)options
                      progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 setImageBlock:(nullable void (^)(UIImage * _Nullable image, NSData * _Nullable imageData, SDImageFormat imageFormat))setImageBlock
                     completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

#endif
