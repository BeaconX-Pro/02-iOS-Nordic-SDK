//
//  MKBXPTaskAdopter.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBXPOperationID.h"
#import "MKBXPAdopter.h"
#import "MKBXPService.h"
#import "MKBXPBaseBeacon.h"

@implementation MKBXPTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    if (!MKValidData(readData)) {
        return @{};
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_modeIDUUID]]){
        //产品型号信息
        return [self modeIDData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_productionDateUUID]]){
        //生产日期
        return [self productionDate:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_firmwareUUID]]){
        //固件信息
        return [self firmwareData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_hardwareUUID]]){
        //硬件信息
        return [self hardwareData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_softwareUUID]]){
        //软件版本
        return [self softwareData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_vendorUUID]]){
        //厂商信息
        return [self vendorData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_capabilitiesUUID]]){
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_activeSlotUUID]]){
        //获取当前活跃的通道
        return [self activeSlot:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisingIntervalUUID]]){
        //获取当前活跃通道的广播间隔
        return [self slotAdvertisingInterval:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_radioTxPowerUUID]]){
        //获取当前活跃通道的发射功率
        return [self radioTxPower:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisedTxPowerUUID]]){
        //获取当前活跃通道的广播功率
        return [self advTxPower:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lockStateUUID]]){
        return [self lockState:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_unlockUUID]]){
        return [self unlockData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_publicECDHKeyUUID]]){
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_eidIdentityKeyUUID]]){
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advSlotDataUUID]]){
        //获取当前活跃通道的广播信息
        return [self advDataWithOriData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_factoryResetUUID]]){
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_notifyUUID]]){
        return [self customData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_batteryUUID]]){
        //电池服务
        return [self batteryData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_deviceTypeUUID]]) {
        //读取设备类型
        return [self parseDeviceType:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_slotTypeUUID]]) {
        //读取通道类型
        return [self parseSlotType:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lightStatusUUID]]) {
        //读取光感状态
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        return [self dataParserGetDataSuccess:@{@"status":content} operationID:mk_bxp_taskReadLightSensorStatusOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_remainConnectableUUID]]) {
        //可连接状态
        return [self parseConnectStatus:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    if (!characteristic) {
        return nil;
    }
    mk_bxp_taskOperationID operationID = mk_bxp_defaultTaskOperationID;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_activeSlotUUID]]){
        operationID = mk_bxp_taskConfigActiveSlotOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisingIntervalUUID]]){
        operationID = mk_bxp_taskConfigAdvertisingIntervalOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_radioTxPowerUUID]]){
        operationID = mk_bxp_taskConfigRadioTxPowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advertisedTxPowerUUID]]){
        operationID = mk_bxp_taskConfigAdvTxPowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_lockStateUUID]]){
        //重置密码
        operationID = mk_bxp_taskConfigLockStateOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_unlockUUID]]){
        //设置unlock状态
        operationID = mk_bxp_taskConfigUnlockOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_publicECDHKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_eidIdentityKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_advSlotDataUUID]]){
        //设置广播数据
        operationID = mk_bxp_taskConfigAdvSlotDataOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_factoryResetUUID]]){
        //恢复出厂设置
        operationID = mk_bxp_taskConfigFactoryResetOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bxp_remainConnectableUUID]]) {
        //可连接状态
        operationID = mk_bxp_taskConfigConnectEnableOperation;
    }
    return [self dataParserGetDataSuccess:@{@"success":@(YES)} operationID:operationID];
}

#pragma mark - private method

+ (NSDictionary *)modeIDData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"modeID":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadModeIDOperation];
}

+ (NSDictionary *)productionDate:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"productionDate":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadProductionDateOperation];
}

+ (NSDictionary *)firmwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"firmware":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadFirmwareOperation];
}

+ (NSDictionary *)hardwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"hardware":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadHardwareOperation];
}

+ (NSDictionary *)softwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"software":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadSoftwareOperation];
}

+ (NSDictionary *)vendorData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"vendor":tempString};
    return [self dataParserGetDataSuccess:dic operationID:mk_bxp_taskReadVendorOperation];
}

+ (NSDictionary *)batteryData:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 4) {
        return nil;
    }
    NSString *battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"battery":battery} operationID:mk_bxp_taskReadBatteryOperation];
}

+ (NSDictionary *)lockState:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"lockState":content} operationID:mk_bxp_taskReadLockStateOperation];
}

+ (NSDictionary *)unlockData:(NSData *)data{
    if (data.length != 16) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"RAND_DATA_ARRAY":data}
                              operationID:mk_bxp_taskReadUnlockOperation];
}

+ (NSDictionary *)activeSlot:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"activeSlot":content} operationID:mk_bxp_taskReadActiveSlotOperation];
}

+ (NSDictionary *)slotAdvertisingInterval:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 4) {
        return nil;
    }
    NSString *advInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"advertisingInterval":advInterval}
                              operationID:mk_bxp_taskReadAdvertisingIntervalOperation];
}

+ (NSDictionary *)radioTxPower:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    NSString *power = [MKBXPAdopter fetchTxPowerWithContent:content];
    return [self dataParserGetDataSuccess:@{@"radioTxPower":power} operationID:mk_bxp_taskReadRadioTxPowerOperation];
}

+ (NSDictionary *)advTxPower:(NSData *)contentData{
    const unsigned char *cData = [contentData bytes];
    unsigned char *data;
    data = malloc(sizeof(unsigned char) * contentData.length);
    if (!data) {
        return nil;
    }
    for (int i = 0; i < contentData.length; i++) {
        data[i] = *cData++;
    }
    unsigned char txPowerChar = *(data);
    NSNumber *txNumber = @(0);
    if (txPowerChar & 0x80) {
        txNumber = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
    }
    else {
        txNumber = [NSNumber numberWithInt:txPowerChar];
    }
    NSString *power = [NSString stringWithFormat:@"%ld",(long)[txNumber integerValue]];
    return [self dataParserGetDataSuccess:@{@"advTxPower":power} operationID:mk_bxp_taskReadAdvTxPowerOperation];
}

+ (NSDictionary *)advDataWithOriData:(NSData *)data{
    MKBXPDataFrameType frameType = [MKBXPBaseBeacon parseDataTypeWithSlotData:data];
    //当前slot广播信息如果是iBeacon，则不能用下面的解析方式解析,需要用专用的iBeacon解析方式
    if (frameType == MKBXPUnknownFrameType) {
        return @{};
    }
    if (frameType == MKBXPTLMFrameType) {
        MKBXPTLMBeacon *beacon = [[MKBXPTLMBeacon alloc] initWithAdvertiseData:data];
        NSDictionary *returnData = @{
                                     @"frameType":@"20",
                                     @"version":[NSString stringWithFormat:@"%ld",(long)[beacon.version integerValue]],
                                     @"mvPerbit":[NSString stringWithFormat:@"%ld",(long)[beacon.mvPerbit integerValue]],
                                     @"temperature":[NSString stringWithFormat:@"%ld",(long)[beacon.temperature integerValue]],
                                     @"advertiseCount":[NSString stringWithFormat:@"%ld",(long)[beacon.advertiseCount integerValue]],
                                     @"deciSecondsSinceBoot":[NSString stringWithFormat:@"%ld",(long)[beacon.deciSecondsSinceBoot integerValue]],
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:mk_bxp_taskReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPUIDFrameType) {
        MKBXPUIDBeacon *beacon = [[MKBXPUIDBeacon alloc] initWithAdvertiseData:data];
        NSDictionary *returnData = @{
                                     @"frameType":@"00",
                                     @"rssi@0M":[NSString stringWithFormat:@"%ld",(long)[beacon.txPower integerValue]],
                                     @"namespaceId":beacon.namespaceId,
                                     @"instanceId":beacon.instanceId,
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:mk_bxp_taskReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPURLFrameType) {
        MKBXPURLBeacon *beacon = [[MKBXPURLBeacon alloc] initWithAdvertiseData:data];
        NSDictionary *returnData = @{
                                     @"frameType":@"10",
                                     @"advData":data,
                                     @"rssi@0M":[NSString stringWithFormat:@"%ld",(long)[beacon.txPower integerValue]],
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:mk_bxp_taskReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPDeviceInfoFrameType) {
        NSString *nameString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, data.length - 1)] encoding:NSUTF8StringEncoding];
        NSDictionary *returnData = @{
                                     @"frameType":@"40",
                                     @"peripheralName":nameString
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:mk_bxp_taskReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPBeaconFrameType) {
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:[data subdataWithRange:NSMakeRange(1, data.length - 1)]];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[content substringWithRange:NSMakeRange(0, 8)],
                                 [content substringWithRange:NSMakeRange(8, 4)],
                                 [content substringWithRange:NSMakeRange(12, 4)],
                                 [content substringWithRange:NSMakeRange(16,4)],
                                 [content substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        uuid = [uuid uppercaseString];
        NSString *major = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(32, 4)] UTF8String],0,16)];
        NSString *minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(36, 4)] UTF8String],0,16)];
        NSDictionary *returnData = @{
                                     @"frameType":@"50",
                                     @"major":major,
                                     @"minor":minor,
                                     @"uuid":uuid,
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:mk_bxp_taskReadAdvSlotDataOperation];
    }
    NSString *type = [MKBLEBaseSDKAdopter hexStringFromData:[data subdataWithRange:NSMakeRange(0, 1)]];
    return [self dataParserGetDataSuccess:@{@"frameType":type} operationID:mk_bxp_taskReadAdvSlotDataOperation];
}

+ (NSDictionary *)parseDeviceType:(NSData *)data {
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    return [self dataParserGetDataSuccess:@{@"deviceType":content} operationID:mk_bxp_taskReadDeviceTypeOperation];
}

+ (NSDictionary *)parseSlotType:(NSData *)data {
    //读取eddyStone设备通道数据类型
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    NSArray *typeList = @[[content substringWithRange:NSMakeRange(0, 2)],
                          [content substringWithRange:NSMakeRange(2, 2)],
                          [content substringWithRange:NSMakeRange(4, 2)],
                          [content substringWithRange:NSMakeRange(6, 2)],
                          [content substringWithRange:NSMakeRange(8, 2)],
                          [content substringWithRange:NSMakeRange(10, 2)]];
    return [self dataParserGetDataSuccess:@{@"slotTypeList":typeList} operationID:mk_bxp_taskReadSlotTypeOperation];
}

+ (NSDictionary *)customData:(NSData *)data{
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length < 8) {
        return nil;
    }
    //配置信息，eb开头
    NSString *ackHeader = [content substringToIndex:2];
    if (![ackHeader isEqualToString:@"eb"]) {
        return nil;
    }
    NSInteger len = strtoul([[content substringWithRange:NSMakeRange(6, 2)] UTF8String],0,16);
    if (content.length != 2 * len + 8) {
        return nil;
    }
    NSString *function = [content substringWithRange:NSMakeRange(2, 2)];
    mk_bxp_taskOperationID operationID = mk_bxp_defaultTaskOperationID;
    NSDictionary *returnDic = nil;
    if ([function isEqualToString:@"20"] && content.length == 20) {
        //mac地址
        NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        operationID = mk_bxp_taskReadMacAddressOperation;
        returnDic = @{@"macAddress":macAddress};
    }else if ([function isEqualToString:@"21"] && content.length == 14){
        //读取三轴传感器参数
        operationID = mk_bxp_taskReadThreeAxisParamsOperation;
        returnDic = @{
                      @"samplingRate":[content substringWithRange:NSMakeRange(8, 2)],
                      @"gravityReference":[content substringWithRange:NSMakeRange(10, 2)],
                      @"sensitivity":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 2)],
                      };
    }else if ([function isEqualToString:@"31"] && content.length == 8){
        //设置三轴传感器参数
        operationID = mk_bxp_taskConfigThreeAxisParamsOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"22"]){
        //读取温湿度存储条件
        NSString *tempFunction = [content substringWithRange:NSMakeRange(8, 2)];
        NSString *temperValue = @"";
        NSString *humidity = @"";
        NSString *time = @"";
        if ([tempFunction isEqualToString:@"00"] && content.length == 14) {
            //温度
            NSInteger value = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            temperValue = [NSString stringWithFormat:@"%.1f",value * 0.1];
        }else if ([tempFunction isEqualToString:@"01"] && content.length == 14) {
            //湿度
            NSInteger value = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            humidity = [NSString stringWithFormat:@"%.1f",value * 0.1];
        }else if ([tempFunction isEqualToString:@"02"] && content.length == 18) {
            //温湿度
            NSInteger value = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            NSInteger value1 = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(14, 4)];
            temperValue = [NSString stringWithFormat:@"%.1f",value * 0.1];
            humidity = [NSString stringWithFormat:@"%.1f",value1 * 0.1];
        }else if ([tempFunction isEqualToString:@"03"] && content.length == 12) {
            //时间
            time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
        }
        returnDic = @{
                      @"functionType":tempFunction,
                      @"temperature":temperValue,
                      @"humidity":humidity,
                      @"storageTime":time,
                      };
        operationID = mk_bxp_taskReadHTStorageConditionsOperation;
    }else if ([function isEqualToString:@"23"] && content.length == 12){
        //读取温湿度采样率
        operationID = mk_bxp_taskReadHTSamplingRateOperation;
        returnDic = @{
                      @"samplingRate":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)],
                      };
    }else if ([function isEqualToString:@"25"] && content.length == 20){
        //读取设备当前时间
        operationID = mk_bxp_taskReadDeviceTimeOperation;
        
        returnDic = @{
                      @"deviceTime":[MKBXPAdopter deviceTime:[content substringWithRange:NSMakeRange(8, 12)]],
                      };
    }else if ([function isEqualToString:@"35"] && content.length == 8){
        //设置设备当前时间
        operationID = mk_bxp_taskConfigDeviceTimeOperation;
        
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"26"] && content.length == 8){
        //关机
        operationID = mk_bxp_taskConfigPowerOffOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"28"] && content.length == 10){
        //读取按键关机状态
        operationID = mk_bxp_taskReadButtonPowerStatusOperation;
        returnDic = @{
            @"isOn":@([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]),
        };
    }else if ([function isEqualToString:@"38"] && content.length == 8){
        //设置按键关机状态
        operationID = mk_bxp_taskConfigButtonPowerStatusOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"29"] && content.length >= 10){
        //读取触发条件
        operationID = mk_bxp_taskReadTriggerConditionsOperation;
        returnDic = [self parseTriggerConditions:[content substringWithRange:NSMakeRange(8, 2 * len)]];
    }else if ([function isEqualToString:@"39"] && content.length == 8){
        //设置触发条件
        operationID = mk_bxp_taskConfigTriggerConditionsOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"32"] && content.length == 8){
        //设置温湿度存储条件
        operationID = mk_bxp_taskConfigHTStorageConditionsOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"33"] && content.length == 8){
        //设置温湿度采样率
        operationID = mk_bxp_taskConfigHTSamplingRateOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"24"] && content.length == 8){
        //删除已储存的温湿度数据
        operationID = mk_bxp_taskDeleteRecordHTDataOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"46"] && content.length == 8){
        //删除已储存的光感数据
        operationID = mk_bxp_taskDeleteRecordLightSensorDataOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"47"] && content.length == 10) {
        //读取LED触发提醒
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bxp_taskReadLEDTriggerStatusOperation;
    }else if ([function isEqualToString:@"57"] && content.length == 8) {
        //设置LED触发提醒
        operationID = mk_bxp_taskConfigLEDTriggerStatusOperation;
        returnDic = @{@"success":@(YES)};
    }else if ([function isEqualToString:@"48"] && content.length == 10) {
        //读取设备是否可以按键开关机
        BOOL isOn = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        returnDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_bxp_taskReadResetBeaconByButtonStatusOperation;
    }else if ([function isEqualToString:@"58"] && content.length == 8) {
        //设置设备是否可以按键开关机
        operationID = mk_bxp_taskConfigResetBeaconByButtonStatusOperation;
        returnDic = @{@"success":@(YES)};
    }
    return [self dataParserGetDataSuccess:returnDic operationID:operationID];
}

+ (NSDictionary *)parseConnectStatus:(NSData *)data {
    NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:data];
    return [self dataParserGetDataSuccess:@{@"connectEnable":@(![content isEqualToString:@"00"])} operationID:mk_bxp_taskReadConnectEnableOperation];
}

#pragma mark - Private method
+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_bxp_taskOperationID)operationID{
    if (!returnData) {
        return nil;
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

+ (NSDictionary *)parseTriggerConditions:(NSString *)content {
    NSString *type = [content substringWithRange:NSMakeRange(0, 2)];
    NSDictionary *resultDic = @{};
    if ([type isEqualToString:@"00"] && content.length == 2) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{},
                      };
    }else if ([type isEqualToString:@"01"] && content.length == 10) {
        float temperature = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(4, 4)]] integerValue] * 0.1;
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"above":@([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]),
                              @"temperature":[NSString stringWithFormat:@"%.1f",temperature],
                              @"start":@([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"02"] && content.length == 10) {
        float humidity = [[MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(4, 4)]] integerValue] * 0.1;
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"above":@([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]),
                              @"humidity":[NSString stringWithFormat:@"%.1f",humidity],
                              @"start":@([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"03"] && content.length == 8) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"04"] && content.length == 8) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"05"] && content.length == 8) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"06"] && content.length == 10) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"])
                              }
                      };
    }
    return resultDic;
}

@end
