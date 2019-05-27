//
//  MKDataManager.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKCentralManagerStateChangedNotification;
extern NSString *const MKPeripheralConnectStateChangedNotification;
extern NSString *const MKPeripheralLockStateChangedNotification;

@class MKSlotDataTypeModel;
@interface MKDataManager : NSObject

@property (nonatomic, copy)NSString *password;

+ (MKDataManager *)shared;

/**
 获取指定通道的详细数据,先切换到指定通道，再根据指定通道的数据类型加载不同数据。对于标准的EddStone广播帧(UID、TLM、URL)，根据相关的特征去获取当前活跃通道的广播内容，对于iBeacon和设备信息帧，需要用自定义协议来获取相关信息
 
 @param slotModel slotModel
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)readSlotDetailData:(MKSlotDataTypeModel *)slotModel
              successBlock:(void (^)(id returnData))successBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/**
 设置slot详情信息
 
 @param slotNo 通道号
 @param slotFrameType 通道数据类型
 @param detailData 详情数据
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)setSlotDetailData:(bxpActiveSlotNo)slotNo
            slotFrameType:(slotFrameType)slotFrameType
               detailData:(NSDictionary *)detailData
             successBlock:(void (^)(void))successBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

- (slotRadioTxPower)getRadioTxPower:(NSString *)txPower;

@end

NS_ASSUME_NONNULL_END
