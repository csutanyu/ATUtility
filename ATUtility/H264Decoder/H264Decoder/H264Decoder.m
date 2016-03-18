//
//  H264Decoder.m
//  H264DecodeDemo
//
//  Created by arvin.tan on 15/10/21.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "H264Decoder.h"

#import <CoreVideo/CoreVideo.h>
#import <VideoToolbox/VideoToolbox.h>

#import "H264DecoderDefine.h"

@interface H264Decoder () {
    uint8_t *_sps;
    NSInteger _spsSize;
    uint8_t *_pps;
    NSInteger _ppsSize;
    VTDecompressionSessionRef _decompressSession;
    CMVideoFormatDescriptionRef _videoFormatDescription;
}

@end

static void didDecompress(void *decompressionOutputRefCon, void *sourceFrameRefCon, OSStatus status, VTDecodeInfoFlags infoFlags, CVImageBufferRef pixelBuffer, CMTime presentationTimeStamp, CMTime presentationDuration) {
    CVPixelBufferRef *outputPixelBuffer = (CVPixelBufferRef *)sourceFrameRefCon;
    *outputPixelBuffer = CVPixelBufferRetain(pixelBuffer);
}

@implementation H264Decoder

#pragma mark - Life Cycle

- (instancetype)init {
    DDLogVerbose(@"");
    if (self = [super init]) {
        _sps = NULL;
        _spsSize = 0;
        _pps = NULL;
        _ppsSize = 0;
    }
    return self;
}

- (void)dealloc {
    DDLogVerbose(@"");
    [self freeVideoFormatDescription];
    [self freeDecompressionSession];
    [self freeCMemory];
}

- (void)freeVideoFormatDescription {
    DDLogVerbose(@"");
    if(_videoFormatDescription) {
        CFRelease(_videoFormatDescription);
        _videoFormatDescription = NULL;
    }
}

- (void)freeDecompressionSession {
    DDLogVerbose(@"");
    if(_decompressSession) {
        VTDecompressionSessionInvalidate(_decompressSession);
        CFRelease(_decompressSession);
        _decompressSession = NULL;
    }
}

- (void)freeCMemory {
    DDLogVerbose(@"");
    free(_sps);
    free(_pps);
    _spsSize = _ppsSize = 0;
}


#pragma mark - Private Init

- (void)initSequenceParameterSetWithNALU:(NALU *)theNALU {
    DDLogVerbose(@"");
    if (_videoFormatDescription) {
        return;
    }
    if (_spsSize != theNALU.spsSize || 0 != memcmp(_sps, theNALU.sps, _spsSize)) {
        if (NULL != _sps) {
            free(_sps);
            _sps = NULL;
            _spsSize = 0;
        }
        _spsSize = theNALU.spsSize;
        _sps = malloc(_spsSize);
        memcpy(_sps, theNALU.sps, _spsSize);
    }
}

- (void)initPictureParameterSetWithVideoPacet:(NALU *)theNALU {
    DDLogVerbose(@"");
    if (_videoFormatDescription) {
        return;
    }
    if (_pps != theNALU.pps || 0 != memcmp(_pps, theNALU.pps, _ppsSize)) {
        if (NULL != _sps) {
            free(_pps);
            _ppsSize = 0;
        }
        _ppsSize = theNALU.ppsSize;
        _pps = malloc(_ppsSize);
        memcpy(_pps, theNALU.pps, _ppsSize);
    }
}

- (CMVideoFormatDescriptionRef)createVideoFormatDescription {
    if (NULL == _pps || 0 == _ppsSize || NULL == _sps || 0 == _spsSize) {
        return NULL;
    }
    DDLogVerbose(@"");
    const uint8_t* const parameterSetPointers[2] = { _sps, _pps };
    const size_t parameterSetSizes[2] = { _spsSize, _ppsSize };
    CMVideoFormatDescriptionRef newFormatDescription;
    OSStatus status = CMVideoFormatDescriptionCreateFromH264ParameterSets(kCFAllocatorDefault,
                                                                          2, //param count
                                                                          parameterSetPointers,
                                                                          parameterSetSizes,
                                                                          4, //nal start code size
                                                                          &newFormatDescription);
    if (noErr != status) {
        DDLogVerbose(@"Create decoder description failed with status = %d", (int)status);
        if (newFormatDescription) {
            CFRelease(newFormatDescription);
        }
        return NULL;
    }
    return newFormatDescription;
}

- (void)initVideoFormatDescriptionWithNALU:(NALU *)nalu {
    if (_videoFormatDescription) {
        return;
    }

    if (nalu.naluType == NALUType_SPS) {
        [self initSequenceParameterSetWithNALU:nalu];
    } else if (nalu.naluType == NALUType_PPS) {
        [self initPictureParameterSetWithVideoPacet:nalu];
    }
    _videoFormatDescription = [self createVideoFormatDescription];
}

- (BOOL)initDecoder {
#if 0
    DDLogVerbose(@"");
    CMVideoFormatDescriptionRef newVideoFormatDescription = [self createVideoFormatDescription];
    if (NULL != _decompressSession && VTDecompressionSessionCanAcceptFormatDescription(_decompressSession, newVideoFormatDescription)) {
        DDLogDebug(@"Old DecompressSession can accept new format description");
        if (newVideoFormatDescription) {
            CFRelease(newVideoFormatDescription);
        }
        return YES;
    }
    if (NULL != _videoFormatDescription) {
        DDLogDebug(@"1");
        [self freeVideoFormatDescription];
    }
    _videoFormatDescription = newVideoFormatDescription;
    if (NULL == _decompressSession) {
        DDLogDebug(@"2");
        [self freeDecompressionSession];
    }
    return [self createDecompressionSession];
#else
    [self createDecompressionSession];
    return YES;
#endif
}

- (BOOL)createDecompressionSession {
    DDLogVerbose(@"");
    if (_decompressSession) {
        return YES;
    }
    CFDictionaryRef attrs = NULL;
    const void *keys[] = { kCVPixelBufferPixelFormatTypeKey };
    //      kCVPixelFormatType_420YpCbCr8Planar is YUV420
    //      kCVPixelFormatType_420YpCbCr8BiPlanarFullRange is NV12
    uint32_t v = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    const void *values[] = { CFNumberCreate(NULL, kCFNumberSInt32Type, &v) };
    attrs = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    //    NSDictionary *destinationImageBufferAttributes =
    //    [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],(id)kCVPixelBufferOpenGLESCompatibilityKey, @(YES), (id)kCVPixelBufferOpenGLESTextureCacheCompatibilityKey, nil];
    //    attrs = (__bridge CFDictionaryRef)(destinationImageBufferAttributes);
    VTDecompressionOutputCallbackRecord callBackRecord;
    callBackRecord.decompressionOutputCallback = didDecompress;
    callBackRecord.decompressionOutputRefCon = NULL;
    
    OSStatus status = VTDecompressionSessionCreate(kCFAllocatorDefault,
                                                   _videoFormatDescription,
                                                   NULL, attrs,
                                                   &callBackRecord,
                                                   &_decompressSession);
    CFRelease(attrs);
    if (noErr != status) {
        DDLogError(@"Create decoder session failed with status = %d", (int)status);
        return NO;
    }
    return YES;
}

#pragma mark - Public

-(CVPixelBufferRef)decodeNALUToCVPixelBuffer:(NALU*)theNalu {
    DDLogVerbose(@"");
    if (isVideoCodingLayer(theNalu.naluType)) {
        return [self parseNALUToPixelBuffer:theNalu];
    } else if (theNalu.naluType == NALUType_SPS || theNalu.naluType == NALUType_PPS) {
        [self initVideoFormatDescriptionWithNALU:theNalu];
        return NULL;
    } else { // ignore non-VLC or non-PPS or non-SPS
        DDLogInfo(@"Ignore non-VLC or non-PPS or non-SPS, nalu type value: %ld type: %@", (long)theNalu.naluType, descriptionOfNALU(theNalu.naluType));
        return NULL;
    }
}

- (CMSampleBufferRef)decodeNALUToCMSampleBufferRef:(NALU* )theNalu {
    DDLogVerbose(@"");
    if (isVideoCodingLayer(theNalu.naluType)) {
        return [self parseNALUToSampleBuffer:@[theNalu]];
    } else if (theNalu.naluType == NALUType_SPS || theNalu.naluType == NALUType_PPS) {
        [self initVideoFormatDescriptionWithNALU:theNalu];
        return NULL;
    } else { // ignore non-VLC or non-PPS or non-SPS
        DDLogInfo(@"Ignore non-VLC or non-PPS or non-SPS, nalu type value: %ld type: %@", (long)theNalu.naluType, descriptionOfNALU(theNalu.naluType));
        return NULL;
    }
}

#pragma mark - Decode Implementation

- (CVPixelBufferRef )parseNALUToPixelBuffer:(NALU *)vp {
    DDLogVerbose(@"");
    if (!_decompressSession) {
        [self initDecoder];
    }
    if (!_decompressSession) {
        return NULL;
    }
    
    CMSampleBufferRef sampleBuffer = [self parseNALUToSampleBuffer:@[vp]];
    CVPixelBufferRef outputPixelBuffer = NULL;
    if (sampleBuffer) {
        VTDecodeFrameFlags flags = 0;
        VTDecodeInfoFlags flagOut = 0;
        OSStatus decodeStatus = VTDecompressionSessionDecodeFrame(_decompressSession,
                                                                  sampleBuffer,
                                                                  flags,
                                                                  &outputPixelBuffer,
                                                                  &flagOut);
        
        if(decodeStatus == kVTInvalidSessionErr) {
            DDLogError(@"IOS8VT: Invalid session, reset decoder session");
        } else if(decodeStatus == kVTVideoDecoderBadDataErr) {
            DDLogError(@"IOS8VT: decode failed status=%d(Bad data)", (int)decodeStatus);
        } else if(decodeStatus != noErr) {
            DDLogError(@"IOS8VT: decode failed status=%d", (int)decodeStatus);
        }
        CFRelease(sampleBuffer);
    }
    return outputPixelBuffer;
}

// TODO: Clear up the Samplebuffer create logic with method: - (CVPixelBufferRef )parseNALU:(NALU *)vp
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
- (CMSampleBufferRef)parseNALUToSampleBuffer:(NSArray *)naluArray {
    if (!_videoFormatDescription) {
        return NULL;
    }
    OSStatus osstatus;
    CMBlockBufferRef blockBufferRef = NULL;
    CMSampleBufferRef sampleBufferRef = NULL;
    if (naluArray.count > 1) {
        // create a block buffer
        osstatus = CMBlockBufferCreateEmpty(CFAllocatorGetDefault(), (uint32_t)naluArray.count, 0, &blockBufferRef);
        if (osstatus != kCMBlockBufferNoErr) {
            NSError* error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osstatus userInfo:nil];
            DDLogError(@"Error creating block buffer = %@", [error description]);
            goto exit;
        }
        for (NALU* nalu in naluArray) {
            osstatus = CMBlockBufferAppendMemoryBlock(blockBufferRef, (void*)nalu.buffer, nalu.size, kCFAllocatorNull,
                                                      NULL, 0, nalu.size, 0);
            if (osstatus != kCMBlockBufferNoErr)
            {
                NSError* error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osstatus userInfo:nil];
                DDLogError(@"Error appending block buffer = %@", [error description]);
                goto exit;
            }
        }
    } else if (naluArray.count == 1) {
        NALU *vp = naluArray.firstObject;
        osstatus  = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault,
                                                       (void*)vp.buffer, vp.size,
                                                       kCFAllocatorNull,
                                                       NULL, 0, vp.size,
                                                       0, &blockBufferRef);
        if (osstatus != kCMBlockBufferNoErr) {
            DDLogError(@"IOS8VT create CMBlockBufferRef failed with status=%d", (int)osstatus);
            goto exit;
        }
    } else {
        goto exit;
    }
    
    // create the sample buffer
    const size_t sampleSizeArray[] = { CMBlockBufferGetDataLength(blockBufferRef) };
    osstatus = CMSampleBufferCreate(kCFAllocatorDefault, blockBufferRef, TRUE, NULL, NULL,
                                    _videoFormatDescription, 1, 0, NULL, 0, sampleSizeArray, &sampleBufferRef);
    if (osstatus != noErr)
    {
        NSError* error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osstatus userInfo:nil];
        DDLogError(@"Error creating the sample buffer = %@", [error description]);
        goto exit;
    }
exit:
    if (blockBufferRef) {
        CFRelease(blockBufferRef);
    }
    return sampleBufferRef;
}

#pragma clang diagnostic pop

@end
