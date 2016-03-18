//
//  NALU.h
//  MyH264DecodeDemo
//
//  Created by arvin.tan on 15/10/21.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>

// Ref:
// https://tools.ietf.org/html/rfc6184
//
// http://baike.baidu.com/view/56322.htm
//
// http://stackoverflow.com/questions/29525000/how-to-use-videotoolbox-to-decompress-h-264-video-stream
typedef NS_ENUM(NSInteger, NALUType) {
    NALUType_Unspecified     = 0,    // Unspecified (non-VCL)
    NALUType_NonIDR          = 1,    // Coded slice of a non-IDR picture (VCL). P frame
    NALUType_A               = 2,    // Coded slice of a non-IDR picture (VCL)
    NALUType_B               = 3,    // Coded slice data partition B (VCL)
    NALUType_C               = 4,    // Coded slice data partition C (VCL)
    NALUType_IDR             = 5,    // Coded slice of an IDR picture (VCL)
    NALUType_SEI             = 6,    // Supplemental enhancement information (SEI) (non-VCL)
    NALUType_SPS             = 7,    // Sequence parameter set (non-VCL). SPS parameter
    NALUType_PPS             = 8,    // Picture parameter set (non-VCL). PPS parameter
    NALUType_AUD             = 9,    // Access unit delimiter (non-VCL)
    NALUType_EOSEQ           = 10,   // End of sequence (non-VCL)
    NALUType_EOSSTREAM       = 11,   // End of stream (non-VCL)"
    NALUType_FD              = 12,   // Filler data (non-VCL)"
    NALUType_SPSE            = 13,   // Sequence parameter set extension (non-VCL)"
    NALUType_PNU             = 14,   // Prefix NAL unit (non-VCL)"
    NALUType_SSPS            = 15,   // Subset sequence parameter set (non-VCL)
    NALUType_Reserved1       = 16,   // Reserved (non-VCL)
    NALUType_Reserved2       = 17,   // Reserved (non-VCL)
    NALUType_Reserved3       = 18,   // Reserved (non-VCL)
    NALUType_CSOAACPWP       = 19,   // Coded slice of an auxiliary coded picture without partitioning (non-VCL)
    NALUType_CSE             = 20,   // Coded slice extension (non-VCL)
    NALUType_CSEFDVC         = 21,   // Coded slice extension for depth view components (non-VCL)
    NALUType_Reserved4       = 22,   // Reserved (non-VCL)
    NALUType_Reserved5       = 23,   // Reserved (non-VCL)
    NALUType_STAP_A          = 24,   // STAP-A Single-time aggregation packet (non-VCL)
    NALUType_STAP_B          = 25,   // STAP-B Single-time aggregation packet (non-VCL)
    NALUType_MTAP16          = 26,   // MTAP16 Multi-time aggregation packet (non-VCL)
    NALUType_MTAP24          = 27,   // MTAP24 Multi-time aggregation packet (non-VCL)
    NALUType_FU_A            = 28,   // FU-A Fragmentation unit (non-VCL)
    NALUType_FU_B            = 29,   // FU-B Fragmentation unit (non-VCL)
    NALUType_Unspecified2    = 30,   // NALUType_Unspecified
    NALUType_Unspecified3    = 31    // NALUType_Unspecified
};

FOUNDATION_EXPORT bool isVideoCodingLayer(NALUType type);
FOUNDATION_EXPORT NSString *descriptionOfNALU(NALUType type);
FOUNDATION_EXPORT const uint8_t NALUStartCode[4];

@interface NALU : NSObject

@property (nonatomic, readonly) uint8_t* buffer;
@property (nonatomic, readonly) NSInteger size;

@property (nonatomic, readonly) NALUType naluType;
@property (nonatomic, readonly) BOOL isVideoCodingLayer;
@property (nonatomic, readonly) uint8_t *sps;
@property (nonatomic, readonly) NSInteger spsSize;
@property (nonatomic, readonly) uint8_t *pps;
@property (nonatomic, readonly) NSInteger ppsSize;

- (instancetype)initWithBuffer:(uint8_t *)buffer size:(NSInteger)size;
- (instancetype)initWithData:(NSData *)data range:(NSRange)range;
- (instancetype)initWithBufferNoCopy:(uint8_t *)buffer size:(NSInteger)size;

@end
