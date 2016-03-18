#import "VideoView.h"

@implementation VideoView

+ (id)layerClass {
    return [AVSampleBufferDisplayLayer class];
}

- (void)setupVideoLayer {
    self.videoLayer = (AVSampleBufferDisplayLayer *)self.layer;
    self.videoLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.videoLayer.backgroundColor = [UIColor blackColor].CGColor;
    CMTimebaseRef controlTimebase;
    CMTimebaseCreateWithMasterClock( CFAllocatorGetDefault(), CMClockGetHostTimeClock(), &controlTimebase);
    
    self.videoLayer.controlTimebase = controlTimebase;
    CMTimebaseSetTime(self.videoLayer.controlTimebase, CMTimeMake(5, 1));
    CMTimebaseSetRate(self.videoLayer.controlTimebase, 1.0);
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupVideoLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupVideoLayer];
    }
    return self;
}


@end
