//
//  MKBXPBaseBeacon.m
//  BeaconXPlus
//
//  Created by aa on 2019/4/18.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPBaseBeacon.h"
#import "MKBXPDefines.h"
#import "MKBXPAdopter.h"

@implementation MKBXPBaseBeacon

+ (NSArray <MKBXPBaseBeacon *>*)parseAdvData:(NSDictionary *)advData {
    if (!MKValidDict(advData)) {
        return nil;
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    NSMutableArray *beaconList = [NSMutableArray array];
    NSArray *keys = [advDic allKeys];
    for (id key in keys) {
        if ([key isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
            NSData *feaaData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            if (MKValidData(feaaData)) {
                MKBXPDataFrameType frameType = [self fetchFEAAFrameType:feaaData];
                MKBXPBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"FEAB"]]) {
            NSData *feabData = advDic[[CBUUID UUIDWithString:@"FEAB"]];
            if (MKValidData(feabData)) {
                MKBXPDataFrameType frameType = [self fetchFEABFrameType:feabData];
                MKBXPBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feabData];
                if ([beacon isKindOfClass:[MKBXPTHSensorBeacon class]]) {
                    MKBXPTHSensorBeacon *tempBeacon = (MKBXPTHSensorBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }else if ([beacon isKindOfClass:[MKBXPiBeacon class]]) {
                    MKBXPiBeacon *tempBeacon = (MKBXPiBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }else if ([beacon isKindOfClass:[MKBXPThreeASensorBeacon class]]) {
                    MKBXPThreeASensorBeacon *tempBeacon = (MKBXPThreeASensorBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }else if ([beacon isKindOfClass:[MKBXPDeviceInfoBeacon class]]) {
                    MKBXPDeviceInfoBeacon *tempBeacon = (MKBXPDeviceInfoBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }
    }
    return beaconList;
}

+ (MKBXPBaseBeacon *)fetchBaseBeaconWithFrameType:(MKBXPDataFrameType)frameType advData:(NSData *)advData {
    MKBXPBaseBeacon *beacon = nil;
    switch (frameType) {
        case MKBXPUIDFrameType:
            beacon = [[MKBXPUIDBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPURLFrameType:
            beacon = [[MKBXPURLBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPTLMFrameType:
            beacon = [[MKBXPTLMBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPDeviceInfoFrameType:
            beacon = [[MKBXPDeviceInfoBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPBeaconFrameType:
            beacon = [[MKBXPiBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPThreeASensorFrameType:
            beacon = [[MKBXPThreeASensorBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXPTHSensorFrameType:
            beacon = [[MKBXPTHSensorBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        default:
            return nil;
    }
    beacon.frameType = frameType;
    return beacon;
}

+ (MKBXPDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData {
    if (slotData.length == 0) {
        return MKBXPUnknownFrameType;
    }
    const unsigned char *cData = [slotData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXPUIDFrameType;
        case 0x10:
            return MKBXPURLFrameType;
        case 0x20:
            return MKBXPTLMFrameType;
        case 0x40:
            return MKBXPDeviceInfoFrameType;
        case 0x50:
            return MKBXPBeaconFrameType;
        case 0x60:
            return MKBXPThreeASensorFrameType;
        case 0x70:
            return MKBXPTHSensorFrameType;
        case 0xff:
            return MKBXPNODATAFrameType;
        default:
            return MKBXPUnknownFrameType;
    }
}

+ (MKBXPDataFrameType)fetchFEAAFrameType:(NSData *)stoneData {
    if (!MKValidData(stoneData)) {
        return MKBXPUnknownFrameType;
    }
    //Eddystone信息帧
    if (stoneData.length == 0) {
        return MKBXPUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXPUIDFrameType;
        case 0x10:
            return MKBXPURLFrameType;
        case 0x20:
            return MKBXPTLMFrameType;
        default:
            return MKBXPUnknownFrameType;
    }
}

+ (MKBXPDataFrameType)fetchFEABFrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXPUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x40:
            return MKBXPDeviceInfoFrameType;
        case 0x50:
            return MKBXPBeaconFrameType;
        case 0x60:
            return MKBXPThreeASensorFrameType;
        case 0x70:
            return MKBXPTHSensorFrameType;
        default:
            return MKBXPUnknownFrameType;
    }
}

+ (MKBXPDataFrameType)fetchFrameTypeWithAdvData:(NSDictionary *)advDic {
    NSData *stoneData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
    if (MKValidData(stoneData)) {
        //Eddystone信息帧
        if (stoneData.length == 0) {
            return MKBXPUnknownFrameType;
        }
        const unsigned char *cData = [stoneData bytes];
        switch (*cData) {
            case 0x00:
                return MKBXPUIDFrameType;
            case 0x10:
                return MKBXPURLFrameType;
            case 0x20:
                return MKBXPTLMFrameType;
            default:
                return MKBXPUnknownFrameType;
        }
    }
    NSData *customData = advDic[[CBUUID UUIDWithString:@"FEAB"]];
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXPUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x40:
            return MKBXPDeviceInfoFrameType;
        case 0x50:
            return MKBXPBeaconFrameType;
        case 0x60:
            return MKBXPThreeASensorFrameType;
        case 0x70:
            return MKBXPTHSensorFrameType;
        default:
            return MKBXPUnknownFrameType;
    }
}

@end

@implementation MKBXPUIDBeacon

- (MKBXPUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length < 18) {
            return nil;
        }
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXPURLBeacon

- (MKBXPURLBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 3), @"Invalid advertiseData:%@", advData);
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *urlScheme = [MKBXPAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advData.length - 3; i++) {
            url = [url stringByAppendingString:[MKBXPAdopter getEncodedString:*(data + i + 3)]];
        }
        self.shortUrl = url;
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXPTLMBeacon

- (MKBXPTLMBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 14), @"Invalid advertiseData:%@", advData);
        
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        /* [TDOO] Set TML Beacon Properties */
        self.version = [NSNumber numberWithInt:*(data+1)];
        self.mvPerbit = [NSNumber numberWithInt:((*(data+2) << 8) + *(data+3))];
        unsigned char temperatureInt = *(data+4);
        if (temperatureInt & 0x80) {
            self.temperature = [NSNumber numberWithFloat:(float)(- 0x100 + temperatureInt) + *(data+5) / 256.0];
        }
        else {
            self.temperature = [NSNumber numberWithFloat:(float)temperatureInt + *(data+5) / 256.0];
        }
        float advertiseCount = (*(data+6) * 16777216) + (*(data+7) * 65536) + (*(data+8) * 256) + *(data+9);
        self.advertiseCount = [NSNumber numberWithLong:advertiseCount];
        float deciSecondsSinceBoot = (((int)(*(data+10) * 16777216) + (int)(*(data+11) * 65536) + (int)(*(data+12) * 256) + *(data+13)) / 10.0);
        self.deciSecondsSinceBoot = [NSNumber numberWithFloat:deciSecondsSinceBoot];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXPDeviceInfoBeacon

- (MKBXPDeviceInfoBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 13), @"Invalid advertiseData:%@", advData);
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi0M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi0M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *tempContent = [MKBXPAdopter hexStringFromData:advData];
        tempContent = [tempContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        tempContent = [tempContent stringByReplacingOccurrencesOfString:@"<" withString:@""];
        tempContent = [tempContent stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        self.interval = [MKBXPAdopter getDecimalStringWithHex:tempContent range:NSMakeRange(4, 2)];
        self.battery = [MKBXPAdopter getDecimalStringWithHex:tempContent range:NSMakeRange(6, 4)];
        self.lockState = [tempContent substringWithRange:NSMakeRange(10, 2)];
        if (![[tempContent substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"00"]) {
            self.connectEnable = YES;
        }
        NSString *tempMac = [[tempContent substringWithRange:NSMakeRange(14, 12)] uppercaseString];
        self.macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[tempMac substringWithRange:NSMakeRange(0, 2)],[tempMac substringWithRange:NSMakeRange(2, 2)],[tempMac substringWithRange:NSMakeRange(4, 2)],[tempMac substringWithRange:NSMakeRange(6, 2)],[tempMac substringWithRange:NSMakeRange(8, 2)],[tempMac substringWithRange:NSMakeRange(10, 2)]];
        self.softVersion = [NSString stringWithFormat:@"%@.%@",[MKBXPAdopter getDecimalStringWithHex:tempContent range:NSMakeRange(26, 2)],[MKBXPAdopter getDecimalStringWithHex:tempContent range:NSMakeRange(28, 2)]];
        free(data);
    }
    return self;
}

@end


@implementation MKBXPiBeacon

- (MKBXPiBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 7), @"Invalid advertiseData:%@", advData);

        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi1M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi1M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBXPAdopter hexStringFromData:advData];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"<" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBXPAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(2, 8)],
                                 [temp substringWithRange:NSMakeRange(10, 4)],
                                 [temp substringWithRange:NSMakeRange(14, 4)],
                                 [temp substringWithRange:NSMakeRange(18,4)],
                                 [temp substringWithRange:NSMakeRange(22, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        self.uuid = [uuid uppercaseString];
        self.major = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(34, 4)] UTF8String],0,16)];
        self.minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(38, 4)] UTF8String],0,16)];
        free(data);
    }
    return self;
}

@end

@implementation MKBXPThreeASensorBeacon

- (MKBXPThreeASensorBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi0M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi0M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBXPAdopter hexStringFromData:advData];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"<" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBXPAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        self.samplingRate = [temp substringWithRange:NSMakeRange(2, 2)];
        self.accelerationOfGravity = [temp substringWithRange:NSMakeRange(4, 2)];
        self.sensitivity = [MKBXPAdopter getDecimalStringWithHex:temp range:NSMakeRange(6, 2)];
        self.xData = [temp substringWithRange:NSMakeRange(8, 4)];
        self.yData = [temp substringWithRange:NSMakeRange(12, 4)];
        self.zData = [temp substringWithRange:NSMakeRange(16, 4)];
        free(data);
    }
    return self;
}

@end


@implementation MKBXPTHSensorBeacon

- (MKBXPTHSensorBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi0M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi0M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBXPAdopter hexStringFromData:advData];
        content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"<" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBXPAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        NSInteger tempTemp = [[MKBXPAdopter signedHexTurnString:[temp substringWithRange:NSMakeRange(2, 4)]] intValue];
        NSInteger tempHui = [MKBXPAdopter getDecimalWithHex:temp range:NSMakeRange(6, 4)];
        self.temperature = [NSString stringWithFormat:@"%.1f",(tempTemp * 0.1)];
        self.humidity = [NSString stringWithFormat:@"%.1f",(tempHui * 0.1)];
        free(data);
    }
    return self;
}

@end
