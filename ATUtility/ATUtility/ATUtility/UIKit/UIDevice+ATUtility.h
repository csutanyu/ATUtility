//
//  UIDevice+ATUtility.h
//  ATUtility
//
//  Created by arvin.tan on 15/11/20.
//  Copyright © 2015年 arvin.tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ATUtility)

// Sometimes this version work fine but sometimes it will return nil
+ (NSString *)IPAddress;

+ (NSString *)wifiIPAddress;

+ (NSString*)hardwareString;
+ (NSString*)hardwareDescription;

+ (NSString *)currentModel;
+ (BOOL)runningOnSimulator;

- (NSString *)UUIDString;
- (NSDictionary *)networkInfo;
- (NSString *)SSID;

@end
