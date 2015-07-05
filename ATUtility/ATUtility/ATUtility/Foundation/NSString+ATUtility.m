//
//  NSString+ATUtility.m
//  ATUtility
//
//  Created by arvin.tan on 7/3/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//

#import "NSString+ATUtility.h"
#import "NSDate+ATUtility.h"

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

@end
