//
//  BaseVideoPreprocessor.h
//  H264DecoderForiOS
//
//  Created by arvin.tan on 2/25/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NALU;
@protocol BaseVideoPreprocessorDelegate;

@interface BaseVideoPreprocessor : NSObject

@property (weak, nonatomic) id<BaseVideoPreprocessorDelegate> delegate;

@end


@protocol BaseVideoPreprocessorDelegate <NSObject>

- (void)videoPreprocessor:(BaseVideoPreprocessor*)videoPreprocessor didReceiveNALU:(NALU *)nalu;

@end