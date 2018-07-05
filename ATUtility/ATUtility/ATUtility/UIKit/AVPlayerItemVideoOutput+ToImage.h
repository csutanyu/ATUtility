//
//  AVPlayerItemVideoOutput+ToImage.h
//  QLVPlatform
//
//  Created by arvin tan on 2018/7/5.
//  Copyright © 2018 arvin.tan. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CIImage.h>
#import <CoreMedia/CoreMedia.h>
#import <AppKit/AppKit.h>

@interface AVPlayerItemVideoOutput (ToImage)
- (CIImage *)ciImageForTime:(CMTime)time;
- (CGImageRef)cgImageForTime:(CMTime)time;
@end
