//
//  MKBXPDataParser.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPDataParser.h"
#import "MKEddystoneDefines.h"
#import "MKEddystoneAdopter.h"
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
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    NSString *battery = [MKEddystoneAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
    return [self dataParserGetDataSuccess:@{@"battery":battery} operationID:MKBXPReadBatteryOperation];
}

+ (NSDictionary *)lockState:(NSData *)data{
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
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
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 2) {
        return nil;
    }
    return [self dataParserGetDataSuccess:@{@"activeSlot":content} operationID:MKBXPReadActiveSlotOperation];
}

+ (NSDictionary *)slotAdvertisingInterval:(NSData *)data{
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
    if (!MKValidStr(content) || content.length != 4) {
        return nil;
    }
    NSString *advInterval = [MKEddystoneAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
    return [self dataParserGetDataSuccess:@{@"advertisingInterval":advInterval}
                              operationID:MKBXPReadAdvertisingIntervalOperation];
}

+ (NSDictionary *)radioTxPower:(NSData *)data{
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
    NSString *power = [MKEddystoneAdopter fetchTxPowerWithContent:content];
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
    if (frameType == MKBXPUnknownFrameType || frameType == MKBXPBeaconFrameType) {
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
        NSString *nameString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *returnData = @{
                                     @"frameType":@"60",
                                     @"peripheralName":nameString
                                     };
        return [self dataParserGetDataSuccess:returnData operationID:MKBXPReadAdvSlotDataOperation];
    }
    return [self dataParserGetDataSuccess:@{@"frameType":@"70"} operationID:MKBXPReadAdvSlotDataOperation];
}

+ (NSDictionary *)customData:(NSData *)data{
    NSString *content = [MKEddystoneAdopter hexStringFromData:data];
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
    if ([function isEqualToString:@"57"] && content.length == 20) {
        //mac地址
        NSString *tempMac = [[content substringWithRange:NSMakeRange(8, 12)] uppercaseString];
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        operationID = MKBXPReadMacAddressOperation;
        returnDic = @{@"macAddress":macAddress};
    }else if ([function isEqualToString:@"58"]){
        //设置eddyStone设备名称
        operationID = MKBXPSetDeviceNameOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"59"]){
        //获取eddyStone设备名称
        NSString *tempString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, data.length - 4)] encoding:NSUTF8StringEncoding];
        operationID = MKBXPReadDeviceNameOperation;
        returnDic = @{@"deviceName":tempString};
    }else if ([function isEqualToString:@"5e"]){
        //设置iBeacon的主值
        operationID = MKBXPSetMajorOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"5f"]){
        //设置iBeacon的次值
        operationID = MKBXPSetMinorOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"60"]){
        //设置iBeacon的校验距离
        operationID = MKBXPSetPowerOffOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"61"]){
        //读取eddyStone设备通道数据类型
        NSString *errorStatus = [content substringWithRange:NSMakeRange(6, 2)];
        
        if (![errorStatus isEqualToString:@"05"]) {
            return nil;
        }
        operationID = MKBXPReadSlotTypeOperation;
        NSString *subContent = [content substringWithRange:NSMakeRange(8, 10)];
        NSArray *typeList = @[[subContent substringWithRange:NSMakeRange(0, 2)],
                              [subContent substringWithRange:NSMakeRange(2, 2)],
                              [subContent substringWithRange:NSMakeRange(4, 2)],
                              [subContent substringWithRange:NSMakeRange(6, 2)],
                              [subContent substringWithRange:NSMakeRange(8, 2)]];
        returnDic = @{@"slotTypeList":typeList};
    }else if ([function isEqualToString:@"89"]){
        //设置eddyStone的可连接状态
        operationID = MKBXPSetConnectEnableOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"64"]){
        //读取iBeacon设备通道的UUID
        NSString *temp = [content substringWithRange:NSMakeRange(8, 2 * len)];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(0, 8)],
                                 [temp substringWithRange:NSMakeRange(8, 4)],
                                 [temp substringWithRange:NSMakeRange(12, 4)],
                                 [temp substringWithRange:NSMakeRange(16,4)],
                                 [temp substringWithRange:NSMakeRange(20, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        operationID = MKBXPReadiBeaconUUIDOperation;
        returnDic = @{@"uuid":[uuid uppercaseString]};
    }else if ([function isEqualToString:@"65"]){
        //设置iBeacon的UUID
        operationID = MKBXPSetiBeaconUUIDOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"66"] && content.length == 18){
        NSString *major = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(8, 4)] UTF8String],0,16)];
        NSString *minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(12, 4)] UTF8String],0,16)];
        NSInteger advTxPower = 0 - strtoul([[content substringWithRange:NSMakeRange(16, 2)] UTF8String],0,16);
        NSString *txPower = [NSString stringWithFormat:@"%ld",(long)advTxPower];
        returnDic = @{
                      //读取自定义iBeacon信息
                      @"frameType":@"50",
                      @"major":major,
                      @"minor":minor,
                      @"txPower":txPower,
                      };
        operationID = MKBXPReadiBeaconDataOperation;
    }else if ([function isEqualToString:@"67"]){
        //设置iBeacon的主值次值发射功率
        operationID = MKBXPSetiBeaconDataOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"69"]){
        //设置fast mode
        operationID = MKBXPSetFastModeOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"6a"]){
        //读取fast mode
        operationID = MKBXPReadFastModeOperation;
        BOOL enable = [[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"];
        NSString *timeout = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(10, 2)] UTF8String],0,16)];
        NSString *interval = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(12, 4)] UTF8String],0,16)];
        NSInteger rssiValue = [[MKEddystoneAdopter fetchRSSIWithContent:[data subdataWithRange:NSMakeRange(6, 1)]] integerValue];
        NSString *rssi = @"";
        if (rssiValue == 0) {
            rssi = @"0dBm";
        }else{
            rssi = [NSString stringWithFormat:@"%@%ld%@",@"-",(long)rssiValue,@"dBm"];
        }
        NSString *txPower = [MKEddystoneAdopter fetchTxPowerWithContent:[content substringWithRange:NSMakeRange(18, 2)]];
        returnDic = @{
                      @"enable":@(enable),
                      @"timeout":timeout,
                      @"interval":interval,
                      @"rssi":rssi,
                      @"txPower":txPower,
                      };
    }else if ([function isEqualToString:@"6b"]){
        //设置LED Control
        operationID = MKBXPSetLedControlConfigOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"6c"]){
        //设置slow mode
        operationID = MKBXPSetSlowModeOperation;
        returnDic = @{};
    }else if ([function isEqualToString:@"6d"]){
        //读取slow mode
        operationID = MKBXPReadSlowModeOperation;
        NSString *interval = [NSString stringWithFormat:@"%ld",(long)strtoul([[content substringWithRange:NSMakeRange(8, 4)] UTF8String],0,16)];
        NSInteger rssiValue = [[MKEddystoneAdopter fetchRSSIWithContent:[data subdataWithRange:NSMakeRange(6, 1)]] integerValue];
        NSString *rssi = @"";
        if (rssiValue == 0) {
            rssi = @"0dBm";
        }else{
            rssi = [NSString stringWithFormat:@"%ld%@",(long)rssiValue,@"dBm"];
        }
        
        NSString *txPower = [MKEddystoneAdopter fetchTxPowerWithContent:[content substringWithRange:NSMakeRange(14, 2)]];
        returnDic = @{
                      @"interval":interval,
                      @"rssi":rssi,
                      @"txPower":txPower,
                      };
    }else if ([function isEqualToString:@"90"]){
        //获取eddyStone的可连接状态
        NSString *state = [content substringFromIndex:(content.length - 2)];
        BOOL connectEnable = [state isEqualToString:@"01"];
        operationID = MKBXPReadConnectEnableOperation;
        returnDic = @{@"connectEnable":@(connectEnable)};
    }
    return [self dataParserGetDataSuccess:returnDic operationID:operationID];
}

#pragma mark - Private method
+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(MKBXPOperationID)operationID{
    if (!returnData) {
        return nil;
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
