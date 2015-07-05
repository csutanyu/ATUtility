//
//  NSString+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 7/3/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import "NSString+ATUtility.h"

#import <CommonCrypto/CommonDigest.h>

#import "NSDate+ATUtility.h"
#import "NSData+ATUtility.h"


@implementation NSString (ATUtility)

+ (NSString *)descriptionOfNSStringEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    if (kCFStringEncodingInvalidId != cfEncoding) {
        return (__bridge_transfer NSString *)CFStringConvertEncodingToIANACharSetName(cfEncoding);
    } else {
        return @"utf-8";
    }
}

- (NSDate *)dateWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = dateStyle;
    dateFormatter.timeStyle = timeStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter dateFromString:self];
}

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding {
    if (![self canBeConvertedToEncoding:encoding]) {
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:encoding];
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)AES256EncryptWithKey:(NSString *)key {
    NSData *plainData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [plainData AES256EncryptWithKey:key];

    NSString *encryptedString = [encryptedData base64Encoding];

    return encryptedString;
}

- (NSString *)AES256DecryptWithKey:(NSString *)key {
    NSData *encryptedData = [NSData dataWithBase64EncodedString:self];
    NSData *plainData = [encryptedData AES256DecryptWithKey:key];
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return plainString;
}

- (NSString *)MD5 {
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (uint32_t)strlen(ptr), md5Buffer);

    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }

    return output;
}

- (NSString *)urlencode {
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
