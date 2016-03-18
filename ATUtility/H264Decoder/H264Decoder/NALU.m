//
//  NALU.m
//  MyH264DecodeDemo
//
//  Created by arvin.tan on 15/10/21.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "NALU.h"

#import "H264DecoderDefine.h"

uint8_t const NALUStartCode[4] = {0x00, 0x00, 0x00, 0x01};

@interface NALU ()

@property (strong, nonatomic, readonly) NSData *conetentData;
@property (nonatomic) BOOL needRelease;
@end

@implementation NALU

- (instancetype)initWithBuffer:(uint8_t *)buffer size:(NSInteger)size {
    DDLogVerbose(@"");
    if (self = [super init]) {
        _buffer = malloc(size);
        memcpy(_buffer, buffer, size);
        _size = size;
        _needRelease = YES;
        [self initThePacket];
    }
    return self;
}

- (instancetype)initWithBufferNoCopy:(uint8_t *)buffer size:(NSInteger)size {
    DDLogVerbose(@"");
    if (self = [super init]) {
        _buffer = buffer;
        _size = size;
        _needRelease = NO;
        [self initThePacket];
    }
    return self;
}


- (instancetype)initWithData:(NSData *)data range:(NSRange)range {
    DDLogVerbose(@"");
    return [self initWithBuffer:(uint8_t *)(data.bytes + range.location) size:range.length];
}

-(void)dealloc {
    DDLogVerbose(@"");
    if (self.needRelease && _buffer) {
        free(_buffer);
    }
}


- (void)initThePacket {
    uint32_t nalSize = (uint32_t)(self.size - 4);
    uint8_t *pNalSize = (uint8_t*)(&nalSize);
    _buffer[0] = *(pNalSize + 3);
    _buffer[1] = *(pNalSize + 2);
    _buffer[2] = *(pNalSize + 1);
    _buffer[3] = *(pNalSize);
    
    _naluType = (NALUType)_buffer[4] & 0x1F;
    DDLogVerbose(@"Nal type is: %@", descriptionOfNALU(_naluType));
    switch (_naluType) {
        case NALUType_SPS: {
            _naluType = NALUType_SPS;
            _spsSize = _size - 4;
            _sps = _buffer + 4;;
            break;
        }
        case NALUType_PPS: {
            _naluType = NALUType_PPS;
            _ppsSize = _size - 4;
            _pps = _buffer + 4;
            break;
        }
        default: {
            // do nothing
            break;
        }
    }
}

- (BOOL)isVideoCodingLayer {
    DDLogVerbose(@"");
    return _naluType >= 1 && _naluType <= 5;
}

@end

inline bool isVideoCodingLayer(NALUType type) { return type >= 1 && type <= 5; }

NSString * descriptionOfNALU(NALUType type) {
    static NSDictionary *naluTypesDictionary;
    if (!naluTypesDictionary) {
        naluTypesDictionary = @{
                                @(0): @"Unspecified (non-VCL)",
                                @(1): @"Coded slice of a non-IDR picture (VCL)",    // P frame
                                @(2): @"Coded slice data partition A (VCL)",
                                @(3): @"Coded slice data partition B (VCL)",
                                @(4): @"Coded slice data partition C (VCL)",
                                @(5): @"Coded slice of an IDR picture (VCL)",      // I frame
                                @(6): @"Supplemental enhancement information (SEI) (non-VCL)",
                                @(7): @"Sequence parameter set (non-VCL)",         // SPS parameter
                                @(8): @"Picture parameter set (non-VCL)",          // PPS parameter
                                @(9): @"Access unit delimiter (non-VCL)",
                                @(10): @"End of sequence (non-VCL)",
                                @(11): @"End of stream (non-VCL)",
                                @(12): @"Filler data (non-VCL)",
                                @(13): @"Sequence parameter set extension (non-VCL)",
                                @(14): @"Prefix NAL unit (non-VCL)",
                                @(15): @"Subset sequence parameter set (non-VCL)",
                                @(16): @"Reserved (non-VCL)",
                                @(17): @"Reserved (non-VCL)",
                                @(18): @"Reserved (non-VCL)",
                                @(19): @"Coded slice of an auxiliary coded picture without partitioning (non-VCL)",
                                @(20): @"Coded slice extension (non-VCL)",
                                @(21): @"Coded slice extension for depth view components (non-VCL)",
                                @(22): @"Reserved (non-VCL)",
                                @(23): @"Reserved (non-VCL)",
                                @(24): @"STAP-A Single-time aggregation packet (non-VCL)",
                                @(25): @"STAP-B Single-time aggregation packet (non-VCL)",
                                @(26): @"MTAP16 Multi-time aggregation packet (non-VCL)",
                                @(27): @"MTAP24 Multi-time aggregation packet (non-VCL)",
                                @(28): @"FU-A Fragmentation unit (non-VCL)",
                                @(29): @"FU-B Fragmentation unit (non-VCL)",
                                @(30): @"Unspecified (non-VCL)",
                                @(31): @"Unspecified (non-VCL)",
                                };
    }
    return naluTypesDictionary[@(type)];
}
