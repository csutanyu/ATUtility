//
//  CALayer+ToImage.h
//  TestMacOSApp
//
//  Created by arvin tan on 2018/7/4.
//  Copyright © 2018 arvin tan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AppKit/AppKit.h>

@interface CALayer (ToImage)
- (NSImage *)toImage;
- (NSData *)toData; // PNG
- (NSData *)toDataWithFileType:(NSBitmapImageFileType)fileType;
@end
