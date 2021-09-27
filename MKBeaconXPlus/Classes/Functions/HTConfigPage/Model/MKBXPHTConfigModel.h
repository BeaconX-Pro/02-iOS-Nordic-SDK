//
//  MKBXPHTConfigModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXPInterface+MKBXPConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPHTStorageConditionsModel : NSObject<MKBXPHTStorageConditionsProtocol>

@property (nonatomic, assign)mk_bxp_HTStorageConditions condition;

/**
 mk_bxp_HTStorageConditions != mk_bxp_HTStorageConditionsTime,0~1000，Represent 0 ° C ~ 100 ° C
 */
@property (nonatomic, assign)NSInteger temperature;

/**
 mk_bxp_HTStorageConditions != mk_bxp_HTStorageConditionsTime,0~1000, Represent 0%~100%
 */
@property (nonatomic, assign)NSInteger humidity;

/**

 mk_bxp_HTStorageConditions == mk_bxp_HTStorageConditionsTime, In case, the range value is 1~255
 */
@property (nonatomic, assign)NSInteger time;

@end

@interface MKBXPHTConfigModel : NSObject

@property (nonatomic, copy)NSString *samplingInterval;

@property (nonatomic, copy)NSString *date;

@property (nonatomic, copy)NSString *time;

/// 当前存储的触发条件
/*
 0:温度，1:湿度，2:温湿度，3:时间
 */
@property (nonatomic, assign)NSInteger triggerType;

/// triggerType=0或者triggerType=2才有值
@property (nonatomic, copy)NSString *temperature;

/// triggerType=1或者triggerType=2才有值
@property (nonatomic, copy)NSString *humidity;

/// triggerType=3才有值
@property (nonatomic, copy)NSString *storageTime;

/// 读取数据
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置参数
/// @param interval Sampling Interval
/// @param conditionsModel conditionsModel
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)configDataWithSamplingInterval:(NSInteger)interval
                     triggerConditions:(MKBXPHTStorageConditionsModel *)conditionsModel
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
