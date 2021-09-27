//
//  MKBXPScanInfoCellModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXScanInfoCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@interface MKBXPScanInfoCellModel : NSObject<MKBXScanInfoCellProtocol>

/// 强业务相关，设备信息帧的广播数组，TLM、UID、URL、iBeacon、温湿度、三轴这些广播帧会被添加到对应的设备信息帧的广播数组里面来
@property (nonatomic, strong)NSMutableArray *advertiseList;

/**
 peripheral 标识符，用来筛选当前设备列表是否已经存在某一个设备
 */
@property (nonatomic, copy)NSString *identifier;

/**
 上一次扫描到的时间
 */
@property (nonatomic, copy)NSString *lastScanDate;


#pragma mark - **************************MKBXScanInfoCellProtocol*********************

@property (nonatomic, strong)CBPeripheral *peripheral;

/// 设备广播名称
@property (nonatomic, copy)NSString *deviceName;

/// 设备可连接状态
@property (nonatomic, assign)BOOL connectable;

/**
 信号值强度,会动态变化，TLM、iBeacon、UID、URL、info都会改变这个值
 */
@property (nonatomic, copy)NSString *rssi;

/// 用于记录本次扫到该设备距离上次扫到该设备的时间差，单位ms.
@property (nonatomic, copy)NSString *displayTime;

/// Whether the device has light sensor.
@property (nonatomic, assign)BOOL lightSensor;

/// lightSensor must be YES.
@property (nonatomic, assign)BOOL lightSensorStatus;

/*
 当扫描到TLM、UID、URL、iBeacon、温湿度、三轴的时候需要一个空的设备信息model用来展示设备广播内容，这个时候生成的该model没有如下的属性。
 当扫描到了设备信息帧的时候，才会有下面的这些属性
 对于2021年之后生产的设备和TLA系列设备，在温湿度、三轴广播帧里面加入了mac地址、电池电压、传感器版本，也会有如下的(rangingData、battery、macAddress)属性
 */

//dBm,当lightSensor=YES，则显示lightSensorStatus，当lightSensor=NO才会显示rangingData
@property (nonatomic, copy)NSString *rangingData;
@property (nonatomic, copy)NSString *txPower;
@property (nonatomic, copy) NSString *macAddress;
//Battery Voltage
@property (nonatomic, copy) NSString *battery;


#pragma mark - ***********************下面三个不属于MKBXScanInfoCellProtocol**********************

@property (nonatomic, copy) NSString *lockState;

//Broadcast interval,Unit:100ms
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy) NSString *softVersion;

@end

NS_ASSUME_NONNULL_END
