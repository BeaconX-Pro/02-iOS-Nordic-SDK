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
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(MKBXPOperationID)operationID
                           resetNum:(BOOL)resetNum
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, MKBXPOperationID operationID, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
