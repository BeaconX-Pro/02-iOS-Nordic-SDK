//
//  MTSlotFrameHandler.h
//  MTBeaconPlus
//
//  Created by minew on 2020/4/20.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class MTLineBeaconData, MTConnectionHandler;

@protocol ConnectionDelegate;

typedef void(^MTCompletionBlock)(BOOL success);  // , WriteLineBeaconStatus

@interface MTSlotHandler : NSObject

@property (nonatomic,weak) id<ConnectionDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *slotFrameDataDic;


/**
 set hwid and vendorKey in lineBeacon
 @param completionHandler callback set hwid and vendorKey successfully or not.
*/
- (void)lineBeaconSetHWID:(NSString *)hwid VendorKey:(NSString *)vendorKey completion:(MTCompletionBlock)completionHandler;


/**
 set lotkey in lineBeacon
 @param completionHandler callback set lotkey successfully or not.
*/
- (void)lineBeaconSetLotkey:(NSString *)lotkey completion:(MTCompletionBlock)completionHandler;



@end

NS_ASSUME_NONNULL_END
