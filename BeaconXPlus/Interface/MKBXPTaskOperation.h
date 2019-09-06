//
//  MKBXPTaskOperation.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MKBXPOperationIDDefines.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKBXPAdditionalInformation;
extern NSString *const MKBXPDataInformation;
extern NSString *const MKBXPDataStatusLev;

@interface MKBXPTaskOperation : NSOperation<CBPeripheralDelegate>

/**
 Initialize the communication thread
 
 @param operationID The task ID of the current thread
  @param resetNum Whether to modify the total number of data that the task needs to accept according to the total number of data returned by the peripheral, YES needs, NO does not need
  @param commandBlock Send command callback
  @param completeBlock data communication completion callback
 @return operation
 */
- (instancetype)initOperationWithID:(MKBXPOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, MKBXPOperationID operationID, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
