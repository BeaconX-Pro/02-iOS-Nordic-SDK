//
//  MTOTAManager.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 9/5/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTConnectionHandler;

// ota status,
typedef NS_ENUM(NSInteger, OTAState) {
    OTAStateUndefined = -3,
    OTAStateEnablingDfuMode = -2,
    OTAStateWaitingReconnect = -1,
    OTAStateReConnecting = 1,
    OTAStateStarting = 2,
    OTAStateUploading = 4,
    OTAStateValidating = 5,
    OTAStateDisconnecting = 6,
    OTAStateCompleted = 7,
    OTAStateAborted = 8,
};

// ota status change block
typedef void(^OTAStateBlock)(OTAState);

// ota progress change block
typedef void(^OTAProgressBlock)(float);

// ota error block
typedef void(^OTAErrorBlock)(NSError *);


@interface MTOTAManager : NSObject


/**
  ota device by using this method, input a connectionHandler instance and firmware file path, then start ota, get statusChange in stateHandler, get firmware file upload progress in progressHandler, get error in errorHandler

 @param connection connectionHandler instance from a MTperipheral
 @param path firmware file path
 @param stateHandler listen status change, only "Completed" means ota successfully.
 @param progressHandler listen file uploading progress
 @param errorHandler listen errors in ota stage
 */
+ (void)startOTA:(MTConnectionHandler *)connection filePath:(NSString *)path stateHandler:(OTAStateBlock)stateHandler progressHandler:(OTAProgressBlock)progressHandler errorHandler:(OTAErrorBlock)errorHandler;

@end
