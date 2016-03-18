//
//  H264Decoder.h
//  H264DecodeDemo
//
//  Created by arvin.tan on 15/10/21.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NALU.h"

/**
 * @brief 接收NALU(network abstract layer unit)并进行解码
 */
@interface H264Decoder : NSObject

/**
 * CVPixelBufferRef 可以通过open gl渲染
 */
- (CVPixelBufferRef)decodeNALUToCVPixelBuffer:(NALU* )theNalu;

/**
 * CMSampleBufferRef 可以enqueue到AVSampleBufferDisplayLayer进行渲染
 * @sample code:
 
 if (sBuf) {
 AVSampleBufferDisplayLayer *videoLayer = self.videoView.videoLayer;
 if ([videoLayer status] == AVQueuedSampleBufferRenderingStatusFailed) {
 DDLogError(@"Error _videoLayer is = %@", [_videoLayer.error description]);
 [videoLayer flush];
 } else {
 //     add the attachment which says that sample should be displayed immediately
 CFArrayRef attachments = CMSampleBufferGetSampleAttachmentsArray(sBuf, YES);
 CFMutableDictionaryRef dict = (CFMutableDictionaryRef)CFArrayGetValueAtIndex(attachments, 0);
 CFDictionarySetValue(dict, kCMSampleAttachmentKey_DisplayImmediately, kCFBooleanTrue);
 [videoLayer enqueueSampleBuffer:sBuf];
 
 }
 CFRelease(sBuf);
 }

 */
- (CMSampleBufferRef)decodeNALUToCMSampleBufferRef:(NALU *)theNalu;

@end
