//
//  NSView+ToImage.h
//  TestMacOSApp
//
//  Created by arvin tan on 2018/7/4.
//  Copyright © 2018 arvin tan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (ToImage)
- (NSImage *)toImage;
- (NSData *)toData; // PNG
- (NSData *)toDataWithFileType:(NSBitmapImageFileType)fileType;
@end
