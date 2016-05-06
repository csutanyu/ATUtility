//
//  NSData+ATUtility.h
//  ATUtility
//
//  Created by tanyu on 7/5/15.
//  Copyright (c) 2015 arvin.tan. All rights reserved.
//
//  http://stackoverflow.com/questions/7818386/aes-encryption-for-an-nsstring

#import <Foundation/Foundation.h>

@interface NSData (ATUtility)

#pragma mark - Crypto

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(NSUInteger)lineLength;

#pragma mark - Prefix and Suffix

- (BOOL)hasPrefixBytes:(const void *)prefix length:(NSUInteger)length;
- (BOOL)hasSuffixBytes:(const void *)suffix length:(NSUInteger)length;

#pragma mark - Save

- (NSString *)writeToFileNamed:(NSString *)name extension:(NSString *)extension;
- (NSString *)writeToFileDirectory:(NSString *)directory name:(NSString *)name extension:(NSString *)extension;

@end
