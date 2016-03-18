//
//  ViewController.m
//  H264DecoderForiOS
//
//  Created by arvin.tan on 2/25/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "ViewController.h"
#import "VideoView.h"
#import "H264Decoder.h"
#import <VideoToolbox/VideoToolbox.h>
#import "LocalESStreamVideoProcessor.h"
#import "H264DecoderDefine.h"


@interface ViewController () <BaseVideoPreprocessorDelegate> {
    H264Decoder *_h264Decoder;
    BaseVideoPreprocessor *_videoPreprocessor;
}

@property (weak, nonatomic) IBOutlet VideoView *videoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TestVideoESStream" ofType:@"dat"];
    _videoPreprocessor = [[LocalESStreamVideoProcessor alloc] initWithFilePath:filePath];
    _videoPreprocessor.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedPlayButton:(id)sender {
    [(LocalESStreamVideoProcessor *)_videoPreprocessor startProcess];
}

#pragma mark - BaseVideoPreprocessorDelegate

- (void)videoPreprocessor:(BaseVideoPreprocessor*)videoReceiver didReceiveNALU:(NALU *)nalu { @autoreleasepool {
    if (!_h264Decoder) {
        _h264Decoder = [H264Decoder new];
    }
    CMSampleBufferRef sBuf = [_h264Decoder decodeNALUToCMSampleBufferRef:nalu];
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
 }}

@end
