//
//  UIImage+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 15/11/20.
//  Copyright © 2015年 arvin.tan. All rights reserved.
//

#import "UIImage+ATUtility.h"
#import <Accelerate/Accelerate.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImage (Blur)

- (UIImage *)imageWithBlur {
    return [self imageWithLightAlpha:0.1 radius:3 colorSaturationFactor:1.8];
}

- (UIImage *)imageWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor {
    UIColor *tintColor = [UIColor colorWithWhite:0 alpha:alpha];
    return [self imageBluredWithRadius:radius tintColor:tintColor saturationDeltaFactor:colorSaturationFactor maskImage:nil];
}

// 内部方法,核心代码,封装了毛玻璃效果 参数:半径,颜色,色彩饱和度
- (UIImage *)imageBluredWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // 开启上下文 用于输出图像
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // 开始画底图
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // 开始画模糊效果
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // 添加颜色渲染
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // 输出成品,并关闭上下文
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

// sometimes the will get a wrong colorspace, and then nil context, nil image
- (UIImage *)cgScaledImageWithScaleFactor:(CGFloat)factor {
    CGImageRef theCGImage = self.CGImage;
    CGFloat width = CGImageGetWidth(theCGImage) * factor;
    CGFloat height = CGImageGetHeight(theCGImage) * factor;
    size_t bitsPerComponent = CGImageGetBitsPerComponent(theCGImage);
    size_t bytesPerRow = CGImageGetBytesPerRow(theCGImage);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(theCGImage);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(theCGImage);
    CGContextRef context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
    CGRect rect = CGRectMake(CGPointZero.x, CGPointZero.y, width, height);
    CGContextDrawImage(context, rect, theCGImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    UIImage *reultImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    CGContextRelease(context);
    return reultImage;
}

- (UIImage *)uiScaledImageWithScaleFactor:(CGFloat)factor {
    CGSize size = CGSizeApplyAffineTransform(self.size, CGAffineTransformMakeScale(factor, factor));
    BOOL hasAlpha = false;
    CGFloat scale = 0.0; // Automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale);
    [self drawInRect:CGRectMake(CGPointZero.x, CGPointZero.y, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// TODO: sometimes we should use cgScale sometimes use uiScale, fix the issue
- (UIImage *)scanedImageWithMaxBytes:(NSUInteger)maxBytes {
    UIImage *thumbnailImage = self;
    size_t originalSize = UIImageJPEGRepresentation(thumbnailImage, 1).length;
    if (originalSize > maxBytes) {
        float percent = maxBytes/((float)originalSize);
        float factor = sqrtf(percent) - 0.001;
        UIImage *temp = [thumbnailImage cgScaledImageWithScaleFactor:factor];
        if (!temp) {
            temp = [thumbnailImage uiScaledImageWithScaleFactor:factor];
        }
        thumbnailImage = temp;
    }
    return thumbnailImage;
}

- (UIImage *)imageWithGaussianBlurWithRadius:(NSNumber *)radius {
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Let's log the list of "blur" filters that are available on the device.
    // From this we see that "CIGaussianBlur" is available.
    // It's best to play with this in GDB. Try:
    // p [CIFilter filterNamesInCategory:kCICategoryBlur]
    // in the debugger.
    NSLog(@"%@", [CIFilter filterNamesInCategory:kCICategoryBlur]);
    // What other categories can you find?
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    // Logging a CIFilter's attributes gives all of the information on the filter
    // and what values it accepts.
    NSLog(@"%@", [blurFilter attributes]);
    [blurFilter setDefaults];
    
    // So in some cases we don't get a CIImage from a UIImage.
    // That's ok - we can make a CIImage from the UIImage's CGImage. Hooray!
    CIImage *imageToBlur = [CIImage imageWithCGImage:self.CGImage];
    
    // iOS provides a nice constant for the input image key
    [blurFilter setValue:imageToBlur forKey:kCIInputImageKey];
    // ... but not for anything else
    if (radius) {
        [blurFilter setValue:radius forKey:@"inputRadius"];
    }
    
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[imageToBlur extent]];
    
    return [UIImage imageWithCGImage:cgImage];
}

@end

@implementation UIImage (Alpha)

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
  
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
  CGContextSetAlpha(ctx, alpha);
  
  CGContextDrawImage(ctx, area, self.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return newImage;
}

@end

@implementation UIImage (RoundCorner)

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit {
  return [self imageWithRoundCornerRadius:radius sizeToFit:sizeToFit borderWidth:0 borderColor:nil];
}

- (UIImage *)imageWithRoundCornerRadius:(CGFloat)radius sizeToFit:(CGSize)sizeToFit borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
  CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
  UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
  CGContextBeginPath(UIGraphicsGetCurrentContext());
  CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), rect);
  CGContextClosePath(UIGraphicsGetCurrentContext());
  CGContextClip(UIGraphicsGetCurrentContext());
  
  [self drawInRect:rect];
  
  if (borderWidth > 0 && borderColor) {
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextAddEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(borderWidth / 2, borderWidth / 2, sizeToFit.width - borderWidth, sizeToFit.height - borderWidth));
    CGContextClosePath(UIGraphicsGetCurrentContext());
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), borderWidth);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), borderColor.CGColor);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
  }
  UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return outImage;
}

@end

@implementation UIImage (Color)

+ (UIImage *)imageFromColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return theImage;
}

@end

BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }
    
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }
    
    CFRelease(destination);
    return YES;
}
