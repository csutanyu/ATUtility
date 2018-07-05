//
//  CALayer+ToImage.m
//  TestMacOSApp
//
//  Created by arvin tan on 2018/7/4.
//  Copyright © 2018 arvin tan. All rights reserved.
//

#import "CALayer+ToImage.h"
#import <CoreGraphics/CoreGraphics.h>

// Reference: https://stackoverflow.com/questions/41386423/get-image-from-calayer-or-nsview-swift-3?rq=1
@implementation CALayer (ToImage)
- (NSImage *)toImage {
    CGFloat width = NSWidth(self.bounds) * [[NSScreen mainScreen] backingScaleFactor];
    CGFloat height = NSHeight(self.bounds) * [[NSScreen mainScreen] backingScaleFactor];
    NSBitmapImageRep *imageRepresentation = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:FALSE colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    imageRepresentation.size = self.bounds.size;
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRepresentation];
    [self renderInContext:context.CGContext];
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRepresentation.CGImage size:self.bounds.size];
    return image;
}

- (NSData *)toData {
    return [self toDataWithFileType:NSBitmapImageFileTypePNG];
}

- (NSData *)toDataWithFileType:(NSBitmapImageFileType)fileType {

    CGFloat width = NSWidth(self.bounds) * [[NSScreen mainScreen] backingScaleFactor];
    CGFloat height = NSHeight(self.bounds) * [[NSScreen mainScreen] backingScaleFactor];
    NSBitmapImageRep *imageRepresentation = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil pixelsWide:width pixelsHigh:height bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:FALSE colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    imageRepresentation.size = self.bounds.size;
    NSGraphicsContext *context = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRepresentation];
    [self renderInContext:context.CGContext];
    
    NSData *data = [imageRepresentation representationUsingType:fileType properties: @{}];
    return data;
}
@end
