//
//  MKBXPSlotConfigModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXPEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigModel : NSObject

/// 通道index
@property (nonatomic, assign)NSInteger slotIndex;

/// 数据通道类型
@property (nonatomic, assign)mk_bxp_slotFrameType slotType;

/*
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:3dBm
 8:4dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@property (nonatomic, assign)NSInteger rssi0M;

@property (nonatomic, copy)NSString *advInterval;

/*
    当前通道广播的数据内容
 TLM:@{
 @"frameType":@"20",
 @"version":@"1",
 @"mvPerbit":@"3000",
 @"temperature":@"5",
 @"advertiseCount":@"100000",
 @"deciSecondsSinceBoot":@"121212",
 }
 UID:@{
 @"frameType":@"00",
 @"rssi@0M":@"0",
 @"namespaceId":@"XXX",
 @"instanceId":@"XXX",
 }
 URL:@{
 @"frameType":@"10",
 @"advData":data,
 @"rssi@0M":@"0",
 }
 DeviceInfo:@{
 @"frameType":@"40",
 @"peripheralName":nameString
 }
 Beacon:@{
 @"frameType":@"50",
 @"major":major,
 @"minor":minor,
 @"uuid":uuid,
 }
 三轴(60)、温湿度(70)、NO DATA"(ff)@{
 @"frameType":@"xxx"
 }
 */
@property (nonatomic, strong)NSDictionary *advSlotData;

/*
 触发条件，根据type类型展示不同的值
 //无触发条件
 type=00,conditions = @{},
 
 //温度触发
 type=01,conditions = @{
 @"above":@(YES),       //YES:高于temperature值，NO:低于temperature值
 @"temperature":@"15.0",    //当前触发温度值
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //湿度触发
 type=02,conditions = @{
 @"above":@(YES),       //YES:高于humidity值，NO:低于humidity值
 @"humidity":@"1.0",    //当前触发湿度值
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //双击触发
 type=03,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //三击触发
 type=04,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //移动触发
 type=05,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 */
@property (nonatomic, strong)NSDictionary *triggerConditions;

/// 触发条件是否打开
@property (nonatomic, assign)BOOL triggerIsOn;

/// 读取当前通道的广播参数
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)readWithSucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置当前通道参数
/// @param params params
/// @param sucBlock 成功回调
/// @param failedBlock 失败回调
- (void)configSlotParams:(NSDictionary *)params
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
