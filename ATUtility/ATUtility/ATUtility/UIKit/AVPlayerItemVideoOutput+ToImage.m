//
//  AVPlayerItemVideoOutput+ToImage.m
//  QLVPlatform
//
//  Created by arvin tan on 2018/7/5.
//  Copyright © 2018 arvin.tan. All rights reserved.
//

#import "AVPlayerItemVideoOutput+ToImage.h"

@implementation AVPlayerItemVideoOutput (ToImage)
- (CIImage *)ciImageForTime:(CMTime)time {
    CVPixelBufferRef pixelBuffer = [self copyPixelBufferForItemTime:time itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    return ciImage;
}

- (CGImageRef)cgImageForTime:(CMTime)time {
    CVPixelBufferRef pixelBuffer = [self copyPixelBufferForItemTime:time itemTimeForDisplay:nil];
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    return videoImage;
}

- (NSImage *)nsImageForTime:(CMTime)time {
    CGImageRef videoImage = [self cgImageForTime:time];
    
    NSImage *image = [[NSImage alloc] initWithCGImage:videoImage size:NSMakeSize(CGImageGetWidth(videoImage), CGImageGetHeight(videoImage))];
    CGImageRelease(videoImage);
    return image;
}


@end
