//
//  UITextField+ATUtitlity.h
//  ATUtility
//
//  Created by arvin.tan on 5/6/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ATUtitlity)

- (void)truncatedToMaxBytes:(NSInteger)bytesLen encode:(NSStringEncoding)encode;

@end
