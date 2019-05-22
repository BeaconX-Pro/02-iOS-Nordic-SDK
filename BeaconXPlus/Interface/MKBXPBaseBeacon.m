//
//  MKBXPBaseBeacon.m
//  BeaconXPlus
//
//  Created by aa on 2019/4/18.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPBaseBeacon.h"
#import "MKEddystoneDefines.h"
#import "MKEddystoneAdopter.h"

@implementation MKBXPBaseBeacon

+ (MKBXPBaseBeacon *)parseAdvData:(NSDictionary *)advData {
    if (!MKValidDict(advData)) {
        return nil;
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    MKBXPDataFrameType frameType = [self fetchFrameTypeWithAdvData:advDic];
    MKBXPBaseBeacon *beacon = nil;
    switch (frameType) {
        case MKBXPUIDFrameType:
            beacon = [[MKBXPUIDBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:@"FEAA"]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            break;
        case MKBXPURLFrameType:
            beacon = [[MKBXPURLBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:@"FEAA"]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            break;
        case MKBXPTLMFrameType:
            beacon = [[MKBXPTLMBeacon alloc] initWithAdvertiseData:advDic[[CBUUID UUIDWithString:@"FEAA"]]];
            beacon.advertiseData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            break;
        default:
            break;
    }
    return nil;
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
    if (!ValidData(customData) || customData.length == 0) {
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
        case 0x80:
            return MKBXPCustomFrameType;
        default:
            return MKBXPUnknownFrameType;
    }
}

@end

@implementation MKBXPUIDBeacon

- (MKBXPUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length <= 18) {
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
        NSString *urlScheme = [MKEddystoneAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advData.length - 3; i++) {
            url = [url stringByAppendingString:[MKEddystoneAdopter getEncodedString:*(data + i + 3)]];
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
        NSAssert1(!(advData.length < 19), @"Invalid advertiseData:%@", advData);
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
        NSString *tempContent = [MKEddystoneAdopter hexStringFromData:[advData subdataWithRange:NSMakeRange(2, advData.length - 2)]];
        self.interval = @(*(data+2));
        self.battery = [NSString stringWithFormat:@"%ld",(long)((*(data+3) << 8) + *(data+4))];
        self.lockState = MKBXPLockStateUnknow;
        if (*(data + 5) == 0x01) {
            self.lockState = MKBXPLockStateOpen;
        }else if (*(data + 5) == 0x02) {
            self.lockState = MKBXPLockStateUnlockAutoMaticRelockDisabled;
        }else {
            self.lockState = MKBXPLockStateLock;
        }
        if (*(data + 6) != 0x00) {
            self.connectEnable = YES;
        }
        
    }
    return self;
}

@end
