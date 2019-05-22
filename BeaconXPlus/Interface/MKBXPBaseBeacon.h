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

+ (MKBXPBaseBeacon *)parseAdvData:(NSDictionary *)advData;

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

@property (nonatomic, assign) MKBXPLockState lockState;

@property (nonatomic, assign) BOOL connectEnable;

@property (nonatomic, copy) NSString *macAddress;

@property (nonatomic, copy) NSString *softVersion;

@property (nonatomic, copy) NSString *deviceName;

- (MKBXPDeviceInfoBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
