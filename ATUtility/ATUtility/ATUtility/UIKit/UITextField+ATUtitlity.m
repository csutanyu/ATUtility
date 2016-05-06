//
//  UITextField+ATUtitlity.m
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "UITextField+ATUtitlity.h"

@implementation UITextField (ATUtitlity)

- (void)truncatedToMaxBytes:(NSInteger)bytesLen encode:(NSStringEncoding)encode {
    NSString *toBeString = self.text;
    NSInteger len = [toBeString dataUsingEncoding:encode].length;
    NSLog(@"--- %ld", (long)len);
    while (len > bytesLen) {
        toBeString = [toBeString substringWithRange:NSMakeRange(0, toBeString.length -1)];
        len = [toBeString dataUsingEncoding:encode].length;
        NSLog(@"--- %ld", (long)len);
    }
    
    if (![self.text isEqualToString:toBeString]) {
        self.text = toBeString;
    }
}

@end
