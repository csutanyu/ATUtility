//
//  EACoordinator.h
//
//
//  Created by arvin.tan on 8/6/15.
//

#import <Foundation/Foundation.h>

#define EnableNSLogger 1

@protocol EACoordinatorDelegate;

@interface EACoordinator : NSObject

@property (nonatomic, weak) id<EACoordinatorDelegate> delegate;

/*!
	@property   sendTimeinterval
	@abstract   The minimum send time interval between two send package.
	@discussion Some accessory may require this. But in most situation, you need not set this.
    @default 0
 */

@property (nonatomic) CFAbsoluteTime sendTimeinterval;

/*!
    @function   isConnected
    Check if connected with the accessory with the specific protocol
 */
- (BOOL)isConnected;

+ (void)setAccessoryProtocol:(NSString *)accessoryProtocol;
+ (instancetype)shared;

- (void)sendData:(NSData *)data withTag:(NSInteger)tag;

@end

@protocol EACoordinatorDelegate <NSObject>

- (void)coordinator:(EACoordinator *)coordinator didConnectToAccessoryProtocol:(NSString *)accessoryProtocol;
- (void)coordinator:(EACoordinator *)coordinator didDisconnectToAccessoryProtocol:(NSString *)accessoryProtocol;
- (void)coordinator:(EACoordinator *)coordinator didReceiveData:(NSData *)data;
- (void)coordinator:(EACoordinator *)coordinator didSendData:(NSData *)data withTag:(NSInteger)tag;

@end
