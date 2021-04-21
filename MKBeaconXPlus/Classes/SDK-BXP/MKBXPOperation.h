//
//  MKBXPOperation.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBaseBleModule/MKBLEBaseDataProtocol.h>

#import "MKBXPOperationID.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPOperation : NSOperation<MKBLEBaseOperationProtocol>

/**
 初始化通信线程
 
 @param operationID 当前线程的任务ID
 @param resetNum 是否需要根据外设返回的数据总条数来修改任务需要接受的数据总条数，YES需要，NO不需要
 @param commandBlock 发送命令回调
 @param completeBlock 数据通信完成回调
 @return operation
 */
- (instancetype)initOperationWithID:(mk_bxp_taskOperationID)operationID
                       commandBlock:(void (^)(void))commandBlock
                      completeBlock:(void (^)(NSError *error, id returnData))completeBlock;

@end

NS_ASSUME_NONNULL_END
