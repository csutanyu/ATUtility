//
//  NSView+ToImage.m
//  TestMacOSApp
//
//  Created by arvin tan on 2018/7/4.
//  Copyright © 2018 arvin tan. All rights reserved.
//

#import "NSView+ToImage.h"

@implementation NSView (ToImage)
- (NSImage *)toImage {
    NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
    
    NSImage *image = [[NSImage alloc] initWithSize:self.bounds.size];
    [image addRepresentation:rep];
    return image;
}

- (NSData *)toData {
    return [self toDataWithFileType:NSBitmapImageFileTypePNG];
}

- (NSData *)toDataWithFileType:(NSBitmapImageFileType)fileType {
    NSBitmapImageRep *rep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:rep];
    
    NSData *data = [rep representationUsingType:fileType properties: @{}];
    return data;
}
@end
