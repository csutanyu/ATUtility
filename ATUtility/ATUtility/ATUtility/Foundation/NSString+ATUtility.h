//
//  NSString+ATUtility.h
//  ATUtility
//
//  Created by arvin.tan on 7/3/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ATUtility)

+ (NSString *)descriptionOfNSStringEncoding:(NSStringEncoding)encoding;

- (NSDate *)dateWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;


- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;
- (NSString *)MD5;

- (NSString *)urlencode;

@end
