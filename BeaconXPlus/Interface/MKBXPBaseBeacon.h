//
//  MKBXPBaseBeacon.h
//  BeaconXPlus
//
//  Created by aa on 2019/4/18.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MKBXPEnumeration.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPBaseBeacon : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKBXPDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;
/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

@property (nonatomic, copy)NSString *deviceName;

+ (NSArray <MKBXPBaseBeacon *>*)parseAdvData:(NSDictionary *)advData;

+ (MKBXPDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData;

@end

@interface MKBXPUIDBeacon : MKBXPBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
@property (nonatomic, copy) NSString *namespaceId;
@property (nonatomic, copy) NSString *instanceId;

- (MKBXPUIDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPURLBeacon : MKBXPBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
//URL Content
@property (nonatomic, copy) NSString *shortUrl;

- (MKBXPURLBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPTLMBeacon : MKBXPBaseBeacon

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *mvPerbit;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *advertiseCount;
@property (nonatomic, strong) NSNumber *deciSecondsSinceBoot;

- (MKBXPTLMBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPDeviceInfoBeacon : MKBXPBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *rssi0M;
//Broadcast interval,单位100ms
@property (nonatomic, copy) NSString *interval;
//电池电量
@property (nonatomic, copy) NSString *battery;

@property (nonatomic, copy) NSString *lockState;

@property (nonatomic, assign) BOOL connectEnable;

@property (nonatomic, copy) NSString *macAddress;

@property (nonatomic, copy) NSString *softVersion;

- (MKBXPDeviceInfoBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPiBeacon : MKBXPBaseBeacon

//RSSI@1m
@property (nonatomic, copy)NSNumber *rssi1M;
@property (nonatomic, copy)NSNumber *txPower;
//广播间隔
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

- (MKBXPiBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPThreeASensorBeacon : MKBXPBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *rssi0M;
@property (nonatomic, strong)NSNumber *txPower;
//Broadcast interval,单位100ms
@property (nonatomic, copy) NSString *interval;
/**
 采样率,@"00":1Hz,@"01":10Hz,@"02":25Hz,@"03":50Hz,@"04":100Hz,
 @"05":200Hz,@"06":400Hz,@"07":1344Hz,@"08":1620Hz,@"09":5376Hz
 */
@property (nonatomic, copy) NSString *samplingRate;
/**
 重力加速度参考值,@"00":±2g,@"01"":±4g,@"02":±8g,@"03":±16g
 */
@property (nonatomic, copy) NSString *accelerationOfGravity;
//灵敏度
@property (nonatomic, copy) NSString *sensitivity;

@property (nonatomic, copy) NSString *xData;

@property (nonatomic, copy) NSString *yData;

@property (nonatomic, copy) NSString *zData;

- (MKBXPThreeASensorBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXPTHSensorBeacon : MKBXPBaseBeacon

@property (nonatomic, strong)NSNumber *txPower;
//RSSI@0m
@property (nonatomic, strong) NSNumber *rssi0M;
//Broadcast interval,单位100ms
@property (nonatomic, copy) NSString *interval;
//温度
@property (nonatomic, copy) NSString *temperature;
//湿度
@property (nonatomic, copy) NSString *humidity;

- (MKBXPTHSensorBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
