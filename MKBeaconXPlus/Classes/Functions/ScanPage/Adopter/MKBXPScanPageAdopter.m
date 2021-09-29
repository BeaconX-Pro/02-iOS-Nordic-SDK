//
//  MKBXPScanPageAdopter.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPScanPageAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import <objc/runtime.h>

#import "MKMacroDefines.h"

#import "MKBXScanBeaconCell.h"
#import "MKBXScanHTCell.h"
#import "MKBXScanThreeASensorCell.h"
#import "MKBXScanTLMCell.h"
#import "MKBXScanUIDCell.h"
#import "MKBXScanURLCell.h"

#import "MKBXScanPageAdopter.h"

#import "MKBXPScanInfoCellModel.h"

#import "MKBXPBaseBeacon.h"

#pragma mark - *********************此处分类为了对数据列表里面的设备信息帧数据和设备信息帧数据里面的广播帧数据进行替换和排序使用**********************

static const char *advertiseKey = "advertiseKey";
static const char *indexKey = "indexKey";
static const char *frameTypeKey = "frameTypeKey";

@interface NSObject (MKBXScanAdd)

/// 如果是TLM、温湿度、三轴传感器中的一种，并且设备信息广播帧数组里面已经包含了该种广播帧，根据原始广播数据来判断二者是否一致，如果一致则舍弃，不一致则用新的广播帧替换广播帧数组里的该广播帧
@property (nonatomic, strong)NSData *advertiseData;

/// 用来标示数据model在设备列表或者设备信息广播帧数组里的index
@property (nonatomic, assign)NSInteger index;

/*
 用来对同一个设备的广播帧进行排序，顺序为
 MKBXPUIDFrameType,
 MKBXPURLFrameType,
 MKBXPTLMFrameType,
 MKBXPBeaconFrameType,
 MKBXPThreeASensorFrameType,
 MKBXPTHSensorFrameType,
 注意，MKBXPDeviceInfoFrameType为每个section的第一个row数据，不在此进行排列了
 */
@property (nonatomic, assign)NSInteger frameIndex;

@end

@implementation NSObject (MKBXScanAdd)

- (void)setAdvertiseData:(NSData *)advertiseData {
    objc_setAssociatedObject(self, &advertiseKey, advertiseData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)advertiseData {
    return objc_getAssociatedObject(self, &advertiseKey);
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

- (void)setFrameIndex:(NSInteger)frameIndex {
    objc_setAssociatedObject(self, &frameTypeKey, @(frameIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)frameIndex {
    return [objc_getAssociatedObject(self, &frameTypeKey) integerValue];
}

@end




#pragma mark - *****************************MKBXPScanPageAdopter**********************


@implementation MKBXPScanPageAdopter

+ (NSObject *)parseBeaconDatas:(MKBXPBaseBeacon *)beacon {
    if ([beacon isKindOfClass:MKBXPiBeacon.class]) {
        //iBeacon
        MKBXPiBeacon *tempModel = (MKBXPiBeacon *)beacon;
        MKBXScanBeaconCellModel *cellModel = [[MKBXScanBeaconCellModel alloc] init];
        cellModel.rssi = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi integerValue]];
        cellModel.rssi1M = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi1M integerValue]];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.interval = tempModel.interval;
        cellModel.major = tempModel.major;
        cellModel.minor = tempModel.minor;
        cellModel.uuid = tempModel.uuid;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXPTHSensorBeacon.class]) {
        //温湿度
        MKBXPTHSensorBeacon *tempModel = (MKBXPTHSensorBeacon *)beacon;
        MKBXScanHTCellModel *cellModel = [[MKBXScanHTCellModel alloc] init];
        cellModel.rssi0M = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi0M integerValue]];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.interval = tempModel.interval;
        cellModel.temperature = tempModel.temperature;
        cellModel.humidity = tempModel.humidity;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXPThreeASensorBeacon.class]) {
        //三轴加速度
        MKBXPThreeASensorBeacon *tempModel = (MKBXPThreeASensorBeacon *)beacon;
        MKBXScanThreeASensorCellModel *cellModel = [[MKBXScanThreeASensorCellModel alloc] init];
        cellModel.rssi0M = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi0M integerValue]];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.interval = tempModel.interval;
        cellModel.samplingRate = tempModel.samplingRate;
        cellModel.accelerationOfGravity = tempModel.accelerationOfGravity;
        cellModel.sensitivity = tempModel.sensitivity;
        cellModel.xData = tempModel.xData;
        cellModel.yData = tempModel.yData;
        cellModel.zData = tempModel.zData;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXPTLMBeacon.class]) {
        //TLM
        MKBXPTLMBeacon *tempModel = (MKBXPTLMBeacon *)beacon;
        MKBXScanTLMCellModel *cellModel = [[MKBXScanTLMCellModel alloc] init];
        cellModel.version = [NSString stringWithFormat:@"%@",tempModel.version];
        cellModel.mvPerbit = [NSString stringWithFormat:@"%@",tempModel.mvPerbit];
        cellModel.temperature = [NSString stringWithFormat:@"%@",tempModel.temperature];
        cellModel.advertiseCount = [NSString stringWithFormat:@"%@",tempModel.advertiseCount];
        cellModel.deciSecondsSinceBoot = [NSString stringWithFormat:@"%@",tempModel.deciSecondsSinceBoot];
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXPUIDBeacon.class]) {
        //UID
        MKBXPUIDBeacon *tempModel = (MKBXPUIDBeacon *)beacon;
        MKBXScanUIDCellModel *cellModel = [[MKBXScanUIDCellModel alloc] init];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.namespaceId = tempModel.namespaceId;
        cellModel.instanceId = tempModel.instanceId;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXPURLBeacon.class]) {
        //URL
        MKBXPURLBeacon *tempModel = (MKBXPURLBeacon *)beacon;
        MKBXScanURLCellModel *cellModel = [[MKBXScanURLCellModel alloc] init];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.shortUrl = tempModel.shortUrl;
        return cellModel;
    }
    return nil;
}

+ (MKBXPScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXPBaseBeacon *)beacon {
    if (!beacon || ![beacon isKindOfClass:MKBXPBaseBeacon.class]) {
        return [[MKBXPScanInfoCellModel alloc] init];
    }
    MKBXPScanInfoCellModel *deviceModel = [[MKBXPScanInfoCellModel alloc] init];
    deviceModel.identifier = beacon.peripheral.identifier.UUIDString;
    deviceModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    deviceModel.deviceName = (ValidStr(beacon.deviceName) ? beacon.deviceName : @"");
    deviceModel.displayTime = @"N/A";
    deviceModel.lastScanDate = kSystemTimeStamp;
    deviceModel.connectable = beacon.connectEnable;
    deviceModel.peripheral = beacon.peripheral;
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //如果是设备信息帧
        MKBXPDeviceInfoBeacon *tempInfoModel = (MKBXPDeviceInfoBeacon *)beacon;
        deviceModel.rangingData = [NSString stringWithFormat:@"%ld",(long)[tempInfoModel.rangingData integerValue]];
        deviceModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempInfoModel.txPower integerValue]];
        deviceModel.interval = tempInfoModel.interval;
        deviceModel.battery = tempInfoModel.battery;
        deviceModel.lockState = tempInfoModel.lockState;
        deviceModel.macAddress = tempInfoModel.macAddress;
        deviceModel.softVersion = tempInfoModel.softVersion;
        deviceModel.lightSensor = tempInfoModel.lightSensor;
        deviceModel.lightSensorStatus = tempInfoModel.lightSensorStatus;
        return deviceModel;
    }
    //如果是URL、TLM、UID、iBeacon、温湿度、三轴中的一种，直接加入到deviceModel中的数据帧数组里面
    NSObject *obj = [self parseBeaconDatas:beacon];
    if (!obj) {
        return deviceModel;
    }
    NSInteger frameType = [MKBXScanPageAdopter fetchFrameIndex:obj];
    obj.advertiseData = beacon.advertiseData;
    obj.index = 0;
    obj.frameIndex = frameType;
    [deviceModel.advertiseList addObject:obj];
    
    if (beacon.frameType == MKBXPThreeASensorFrameType) {
        //如果是三轴的数据，新版本(生产日期是2021年之后的)固件和TLA固件包含电压、传感器类型、Mac地址，则需要创建一个新的设备信息帧附加到当前model
        MKBXPThreeASensorBeacon *tempBeacon = (MKBXPThreeASensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            deviceModel.macAddress = tempBeacon.macAddress;
            deviceModel.battery = tempBeacon.battery;
            deviceModel.rangingData = tempBeacon.rssi0M;
        }
    }else if (beacon.frameType == MKBXPTHSensorFrameType) {
        //如果是温湿度传感器的数据，新版本(生产日期是2021年之后的)固件和TLA固件包含电压、传感器类型、Mac地址，则需要创建一个新的设备信息帧附加到当前model
        MKBXPTHSensorBeacon *tempBeacon = (MKBXPTHSensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            deviceModel.macAddress = tempBeacon.macAddress;
            deviceModel.battery = tempBeacon.battery;
            deviceModel.rangingData = tempBeacon.rssi0M;
        }
    }
    
    return deviceModel;
}

+ (void)updateInfoCellModel:(MKBXPScanInfoCellModel *)exsitModel beaconData:(MKBXPBaseBeacon *)beacon {
    exsitModel.connectable = beacon.connectEnable;
    exsitModel.peripheral = beacon.peripheral;
    exsitModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    if (ValidStr(beacon.deviceName)) {
        exsitModel.deviceName = beacon.deviceName;
    }
    if (ValidStr(exsitModel.lastScanDate)) {
        exsitModel.displayTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)([kSystemTimeStamp integerValue] - [exsitModel.lastScanDate integerValue]) * 1000,@"ms"];
        exsitModel.lastScanDate = kSystemTimeStamp;
    }
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //设备信息帧
        MKBXPDeviceInfoBeacon *tempInfoModel = (MKBXPDeviceInfoBeacon *)beacon;
        exsitModel.rangingData = [NSString stringWithFormat:@"%ld",(long)[tempInfoModel.rangingData integerValue]];
        exsitModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempInfoModel.txPower integerValue]];
        exsitModel.interval = tempInfoModel.interval;
        exsitModel.battery = tempInfoModel.battery;
        exsitModel.lockState = tempInfoModel.lockState;
        exsitModel.macAddress = tempInfoModel.macAddress;
        exsitModel.softVersion = tempInfoModel.softVersion;
        exsitModel.lightSensor = tempInfoModel.lightSensor;
        exsitModel.lightSensorStatus = tempInfoModel.lightSensorStatus;
        return;
    }
    if (beacon.frameType == MKBXPThreeASensorFrameType && !ValidStr(exsitModel.macAddress)) {
        //如果是三轴的数据并且当前model没有包含设备信息帧，新版本三轴数据包含电压、传感器类型、Mac地址,则需要创建一个新的设备信息帧附加到当前model
        MKBXPThreeASensorBeacon *tempBeacon = (MKBXPThreeASensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            exsitModel.macAddress = tempBeacon.macAddress;
            exsitModel.battery = tempBeacon.battery;
            exsitModel.rangingData = tempBeacon.rssi0M;
        }
    }else if (beacon.frameType == MKBXPTHSensorFrameType && !ValidStr(exsitModel.macAddress)) {
        //如果是温湿度的数据并且当前model没有包含设备信息帧，新版本三轴数据包含电压、传感器类型、Mac地址,则需要创建一个新的设备信息帧附加到当前model
        MKBXPTHSensorBeacon *tempBeacon = (MKBXPTHSensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            exsitModel.macAddress = tempBeacon.macAddress;
            exsitModel.battery = tempBeacon.battery;
            exsitModel.rangingData = tempBeacon.rssi0M;
        }
    }
    //如果是URL、TLM、UID、iBeacon、温湿度、三轴传感器中的一种，
    //如果eddStone帧数组里面已经包含该类型数据，则判断是否是TLM、温湿度、三轴传感器，如果是TLM、温湿度、三轴传感器直接替换数组中的数据，如果不是，则判断广播内容是否一样，如果一样，则不处理，如果不一样，直接加入到帧数组
    NSObject *tempModel = [MKBXPScanPageAdopter parseBeaconDatas:beacon];
    if (!tempModel) {
        return;
    }
    NSInteger frameType = [MKBXScanPageAdopter fetchFrameIndex:tempModel];
    tempModel.advertiseData = beacon.advertiseData;
    tempModel.frameIndex = frameType;
    for (NSObject *model in exsitModel.advertiseList) {
        if ([model.advertiseData isEqualToData:tempModel.advertiseData]) {
            //如果广播内容一样，直接舍弃数据
            return;
        }
        if ([NSStringFromClass(tempModel.class) isEqualToString:NSStringFromClass(model.class)] &&
            ([model isKindOfClass:MKBXScanTLMCellModel.class] || [model isKindOfClass:MKBXScanHTCellModel.class] || [model isKindOfClass:MKBXScanThreeASensorCellModel.class])) {
            //TLM、温湿度、三轴需要替换
            tempModel.index = model.index;
            [exsitModel.advertiseList replaceObjectAtIndex:model.index withObject:tempModel];
            return;
        }
    }
    //如果eddStone帧数组里面不包含该数据，直接添加
    [exsitModel.advertiseList addObject:tempModel];
    tempModel.index = exsitModel.advertiseList.count - 1;
    NSArray *tempArray = [NSArray arrayWithArray:exsitModel.advertiseList];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSObject *p1, NSObject *p2){
        if (p1.frameIndex > p2.frameIndex) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [exsitModel.advertiseList removeAllObjects];
    for (NSInteger i = 0; i < sortedArray.count; i ++) {
        NSObject *tempModel = sortedArray[i];
        tempModel.index = i;
        [exsitModel.advertiseList addObject:tempModel];
    }
}

@end
