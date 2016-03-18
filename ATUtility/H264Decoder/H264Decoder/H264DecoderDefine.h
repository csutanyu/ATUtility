//
//  H264DecoderDefine.h
//  H264DecoderForiOS
//
//  Created by arvin.tan on 2/25/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#ifndef H264DecoderDefine_h
#define H264DecoderDefine_h

#if 0 // Download NSLoger

#define DDLogError(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogWarn(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogInfo(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogDebug(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);
#define DDLogVerbose(fmt, ...) LogMessageF( __FILE__,__LINE__,__FUNCTION__, NULL, LOGGER_DEFAULT_OPTIONS, fmt, ##__VA_ARGS__);

#else

#define DDLogError(...)
#define DDLogWarn(...)
#define DDLogInfo(...)
#define DDLogDebug(...)
#define DDLogVerbose(...)

#endif

#endif /* H264DecoderDefine_h */
