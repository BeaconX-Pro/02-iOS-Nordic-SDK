//
//  MKBXPDataParser.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPDataParser.h"
#import "MKBXPDefines.h"
#import "MKBXPAdopter.h"
#import "MKBXPService.h"
#import "MKBXPOperationIDDefines.h"
#import "MKBXPEnumeration.h"
#import "MKBXPBaseBeacon.h"

NSString *const MKBXPDataNum = @"MKBXPDataNum";

@implementation MKBXPDataParser

+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    NSData *readData = characteristic.value;
    if (!MKValidData(readData)) {
        return nil;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:modeIDUUID]]){
        //产品型号信息
        return [self modeIDData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:productionDateUUID]]){
        //生产日期
        return [self productionDate:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:firmwareUUID]]){
        //固件信息
        return [self firmwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:hardwareUUID]]){
        //硬件信息
        return [self hardwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:softwareUUID]]){
        //软件版本
        return [self softwareData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:vendorUUID]]){
        //厂商信息
        return [self vendorData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:capabilitiesUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:activeSlotUUID]]){
        //获取当前活跃的通道
        return [self activeSlot:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisingIntervalUUID]]){
        //获取当前活跃通道的广播间隔
        return [self slotAdvertisingInterval:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:radioTxPowerUUID]]){
        //获取当前活跃通道的发射功率
        return [self radioTxPower:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisedTxPowerUUID]]){
        //获取当前活跃通道的广播功率
        return [self advTxPower:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:lockStateUUID]]){
        return [self lockState:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:unlockUUID]]){
        return [self unlockData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:publicECDHKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:eidIdentityKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advSlotDataUUID]]){
        //获取当前活跃通道的广播信息
        return [self advDataWithOriData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:factoryResetUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:iBeaconNotifyUUID]]){
        return [self customData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:batteryUUID]]){
        //电池服务
        return [self batteryData:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:deviceTypeUUID]]) {
        //读取设备类型
        return [self parseDeviceType:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:slotTypeUUID]]) {
        //读取通道类型
        return [self parseSlotType:readData];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:remainConnectableUUID]]) {
        //可连接状态
        return [self parseConnectStatus:readData];
    }
    return nil;
}

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return nil;
    }
    MKBXPOperationID operationID = MKBXPOperationDefaultID;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:activeSlotUUID]]){
        operationID = MKBXPSetActiveSlotOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisingIntervalUUID]]){
        operationID = MKBXPSetAdvertisingIntervalOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:radioTxPowerUUID]]){
        operationID = MKBXPSetRadioTxPowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advertisedTxPowerUUID]]){
        operationID = MKBXPSetAdvTxPowerOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:lockStateUUID]]){
        //重置密码
        operationID = MKBXPSetLockStateOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:unlockUUID]]){
        //设置unlock状态
        operationID = MKBXPSetUnlockOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:publicECDHKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:eidIdentityKeyUUID]]){
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:advSlotDataUUID]]){
        //设置广播数据
        operationID = MKBXPSetAdvSlotDataOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:factoryResetUUID]]){
        //恢复出厂设置
        operationID = MKBXPSetFactoryResetOperation;
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:remainConnectableUUID]]) {
        //可连接状态
        operationID = MKBXPSetConnectEnableOperation;
    }
    return [self dataParserGetDataSuccess:@{} operationID:operationID];
}

#pragma mark - data parser
+ (NSDictionary *)modeIDData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"modeID":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadModeIDOperation];
}

+ (NSDictionary *)productionDate:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"productionDate":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadProductionDateOperation];
}

+ (NSDictionary *)firmwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"firmware":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadFirmwareOperation];
}

+ (NSDictionary *)hardwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"hardware":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadHardwareOperation];
}

+ (NSDictionary *)softwareData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"software":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadSoftwareOperation];
}

+ (NSDictionary *)vendorData:(NSData *)data{
    NSString *tempString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"vendor":tempString};
    return [self dataParserGetDataSuccess:dic operationID:MKBXPReadVendorOperation];
}

+ (NSDictionary *)batteryData:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 4) {
        return nil;
    }
    NSString *battery = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"battery":battery} operationID:MKBXPReadBatteryOperation];
}

+ (NSDictionary *)lockState:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"lockState":content} operationID:MKBXPReadLockStateOperation];
}

+ (NSDictionary *)unlockData:(NSData *)data{
    if (data.length != 16) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"RAND_DATA_ARRAY":data}
                              operationID:MKBXPReadUnlockOperation];
}

+ (NSDictionary *)activeSlot:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"activeSlot":content} operationID:MKBXPReadActiveSlotOperation];
}

+ (NSDictionary *)slotAdvertisingInterval:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 4) {
        return nil;
    }
    NSString *advInterval = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"advertisingInterval":advInterval}
                              operationID:MKBXPReadAdvertisingIntervalOperation];
}

+ (NSDictionary *)radioTxPower:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    NSString *power = [MKBXPAdopter fetchTxPowerWithContent:content];
    return [self dataParserGetDataSuccess:@{@"radioTxPower":power} operationID:MKBXPReadRadioTxPowerOperation];
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
    return [self dataParserGetDataSuccess:@{@"advTxPower":power} operationID:MKBXPReadAdvTxPowerOperation];
}

+ (NSDictionary *)advDataWithOriData:(NSData *)data{
    MKBXPDataFrameType frameType = [MKBXPBaseBeacon parseDataTypeWithSlotData:data];
    //当前slot广播信息如果是iBeacon，则不能用下面的解析方式解析,需要用专用的iBeacon解析方式
    if (frameType == MKBXPUnknownFrameType) {
        return nil;
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
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPUIDFrameType) {
        MKBXPUIDBeacon *beacon = [[MKBXPUIDBeacon alloc] initWithAdvertiseData:data];
        NSDictionary *returnData = @{
                                     @"frameType":@"00",
                                     @"txPower":[NSString stringWithFormat:@"%ld",(long)[beacon.txPower integerValue]],
                                     @"namespaceId":beacon.namespaceId,
                                     @"instanceId":beacon.instanceId,
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPURLFrameType) {
        MKBXPURLBeacon *beacon = [[MKBXPURLBeacon alloc] initWithAdvertiseData:data];
        NSDictionary *returnData = @{
                                     @"frameType":@"10",
                                     @"advData":data,
                                     @"txPower":[NSString stringWithFormat:@"%ld",(long)[beacon.txPower integerValue]],
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPDeviceInfoFrameType) {
        NSString *nameString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, data.length - 1)] encoding:NSUTF8StringEncoding];
        NSDictionary *returnData = @{
                                     @"frameType":@"40",
                                     @"peripheralName":nameString
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    if (frameType == MKBXPBeaconFrameType) {
        NSString *content = [MKBXPAdopter hexStringFromData:[data subdataWithRange:NSMakeRange(1, data.length - 1)]];
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
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    NSString *type = [MKBXPAdopter hexStringFromData:[data subdataWithRange:NSMakeRange(0, 1)]];
    return [self dataParserGetDataSuccess:@{@"frameType":type} operationID:MKBXPReadAdvSlotDataOperation];
}

+ (NSDictionary *)parseDeviceType:(NSData *)data {
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    return [self dataParserGetDataSuccess:@{@"deviceType":content} operationID:MKBXPReadDeviceTypeOperation];
}

+ (NSDictionary *)parseSlotType:(NSData *)data {
    //读取eddyStone设备通道数据类型
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    NSArray *typeList = @[[content substringWithRange:NSMakeRange(0, 2)],
                          [content substringWithRange:NSMakeRange(2, 2)],
                          [content substringWithRange:NSMakeRange(4, 2)],
                          [content substringWithRange:NSMakeRange(6, 2)],
                          [content substringWithRange:NSMakeRange(8, 2)],
                          [content substringWithRange:NSMakeRange(10, 2)]];
    return [self dataParserGetDataSuccess:@{@"slotTypeList":typeList} operationID:MKBXPReadSlotTypeOperation];
}

+ (NSDictionary *)customData:(NSData *)data{
    NSString *content = [MKBXPAdopter hexStringFromData:data];
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
    MKBXPOperationID operationID = MKBXPOperationDefaultID;
    NSDictionary *returnDic = nil;
    if ([function isEqualToString:@"20"] && content.length == 20) {
        //mac地址
        NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        operationID = MKBXPReadMacAddressOperation;
        returnDic = @{@"macAddress":macAddress};
    }else if ([function isEqualToString:@"21"] && content.length == 14){
        //读取三轴传感器参数
        operationID = MKBXPReadThreeAxisParamsOperation;
        returnDic = @{
                      @"samplingRate":[content substringWithRange:NSMakeRange(8, 2)],
                      @"gravityReference":[content substringWithRange:NSMakeRange(10, 2)],
                      @"sensitivity":[MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(12, 2)],
                      };
    }else if ([function isEqualToString:@"31"] && content.length == 8){
        //设置三轴传感器参数
        operationID = MKBXPSetThreeAxisParamsOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"22"]){
        //读取温湿度存储条件
        NSString *tempFunction = [content substringWithRange:NSMakeRange(8, 2)];
        NSString *temperValue = @"";
        NSString *humidity = @"";
        NSString *time = @"";
        if ([tempFunction isEqualToString:@"00"] && content.length == 14) {
            //温度
            NSInteger value = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            temperValue = [NSString stringWithFormat:@"%.1f",value * 0.1];
        }else if ([tempFunction isEqualToString:@"01"] && content.length == 14) {
            //湿度
            NSInteger value = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            humidity = [NSString stringWithFormat:@"%.f",value * 0.1];
        }else if ([tempFunction isEqualToString:@"02"] && content.length == 18) {
            //温湿度
            NSInteger value = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(10, 4)];
            NSInteger value1 = [MKBXPAdopter getDecimalWithHex:content range:NSMakeRange(14, 4)];
            temperValue = [NSString stringWithFormat:@"%.1f",value * 0.1];
            humidity = [NSString stringWithFormat:@"%.f",value1 * 0.1];
        }else if ([tempFunction isEqualToString:@"03"] && content.length == 12) {
            //时间
            time = [MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 2)];
        }
        returnDic = @{
                      @"functionType":tempFunction,
                      @"temperature":temperValue,
                      @"humidity":humidity,
                      @"storageTime":time,
                      };
        operationID = MKBXPReadHTStorageConditionsOperation;
    }else if ([function isEqualToString:@"23"] && content.length == 12){
        //读取温湿度采样率
        operationID = MKBXPReadHTSamplingRateOperation;
        returnDic = @{
                      @"samplingRate":[MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)],
                      };
    }else if ([function isEqualToString:@"25"] && content.length == 20){
        //读取设备当前时间
        operationID = MKBXPReadDeviceTimeOperation;
        
        returnDic = @{
                      @"deviceTime":[MKBXPAdopter deviceTime:[content substringWithRange:NSMakeRange(8, 12)]],
                      };
    }else if ([function isEqualToString:@"35"] && content.length == 8){
        //设置设备当前时间
        operationID = MKBXPSetDeviceTimeOperation;
        
        returnDic = @{};
    }else if ([function isEqualToString:@"26"] && content.length == 8){
        //关机
        operationID = MKBXPSetPowerOffOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"29"] && content.length >= 10){
        //读取触发条件
        operationID = MKBXPReadTriggerConditionsOperation;
        returnDic = [self parseTriggerConditions:[content substringWithRange:NSMakeRange(8, 2 * len)]];
    }else if ([function isEqualToString:@"39"] && content.length == 8){
        //读取触发条件
        operationID = MKBXPSetTriggerConditionsOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"32"] && content.length == 8){
        //设置温湿度存储条件
        operationID = MKBXPSetHTStorageConditionsOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"33"] && content.length == 8){
        //设置温湿度采样率
        operationID = MKBXPSetHTSamplingRateOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"24"] && content.length == 8){
        //删除已储存的温湿度数据
        operationID = MKBXPDeleteRecordHTDataOperation;
        returnDic = @{};
    }
    return [self dataParserGetDataSuccess:returnDic operationID:operationID];
}

+ (NSDictionary *)parseConnectStatus:(NSData *)data {
    NSString *content = [MKBXPAdopter hexStringFromData:data];
    return [self dataParserGetDataSuccess:@{@"connectEnable":@(![content isEqualToString:@"00"])} operationID:MKBXPReadConnectEnableOperation];
}

#pragma mark - Private method
+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(MKBXPOperationID)operationID{
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
                      };
    }else if ([type isEqualToString:@"01"] && content.length == 10) {
        float temperature = [[MKBXPAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(4, 4)]] integerValue] * 0.1;
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"above":@([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]),
                              @"temperature":[NSString stringWithFormat:@"%.1f",temperature],
                              @"start":@([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"02"] && content.length == 10) {
        float humidity = [[MKBXPAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(4, 4)]] integerValue] * 0.1;
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
                              @"time":[MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"04"] && content.length == 8) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }else if ([type isEqualToString:@"05"] && content.length == 8) {
        resultDic = @{
                      @"type":type,
                      @"conditions":@{
                              @"time":[MKBXPAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)],
                              @"start":@([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"])
                              }
                      };
    }
    return resultDic;
}

@end
