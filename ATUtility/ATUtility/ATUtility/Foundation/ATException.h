//
//  ATException.h
//  ATUtility
//
//  Created by arvin.tan on 4/15/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#ifndef ATException_h
#define ATException_h

// Ref: http://tewha.net/2013/02/presenting-blockassert/

#define BlockAssert(condition, desc, ...)   \
do {    \
    __PRAGMA_PUSH_NO_EXTRA_ARG_WARNINGS \
    if (!(condition)) { \
        [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd \
                                                            object:strongSelf file:[NSString stringWithUTF8String:__FILE__] \
                                                        lineNumber:__LINE__ description:(desc), ##__VA_ARGS__]; \
    }   \
    __PRAGMA_POP_NO_EXTRA_ARG_WARNINGS  \
} while(0)


#endif /* ATException_h */
