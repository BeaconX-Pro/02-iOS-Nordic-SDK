//
//  MTSensorHandler.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2018/12/24.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MTSensorData, MTConnectionHandler;

@protocol ConnectionDelegate;

typedef void(^MTSensorOperatBlock)( MTSensorData *sd);

typedef void(^MTSensorCountOperatBlock)( NSInteger count);

typedef void(^MTSensorResetOperatBlock)( BOOL isSuccess);

@interface MTSensorHandler : NSObject

@property (nonatomic, copy) MTSensorOperatBlock operatSensor;
@property (nonatomic, copy) MTSensorCountOperatBlock operatSensorCount;
@property (nonatomic, copy) MTSensorResetOperatBlock operatSensorReset;

@property (nonatomic, strong) NSMutableDictionary *sensorDataDic;

@property (nonatomic,weak) id<ConnectionDelegate> delegate;

/**
 read HTSensor data from device
 
 @param completionHandler call back sensordata when data synced.
 */
- (void)readSensorHistory:(MTSensorOperatBlock)completionHandler;
/**
 set PIRSensor data to device
 
 @param completionHandler call back sensordata when data saved.
 */

- (void)pirSet:(BOOL)isRepeat andDelayTime:(uint16_t)time completion:(MTSensorOperatBlock)completionHandler;

/**
 Read history of six axis sensor from device
 @param completionHandler call back history of six axis sensor when data synced
 */
- (void)readSixAxisSensorHistory:(MTSensorOperatBlock)completionHandler;

/**
 Read history of magnetometer sensor from device
 @param completionHandler call back history of magnetometer sensor when data synced
 */
- (void)readMagnetometerSensorHistory:(MTSensorOperatBlock)completionHandler;

/**
 Read history of atmospheric pressure sensor from device
 @param completionHandler call back history of atmospheric pressure sensor when data synced
 */
- (void)readAtmosphericPressureSensorHistory:(MTSensorOperatBlock)completionHandler;

/**
 Read history of single temp sensor from device
 @param completionHandler call back history of single temp sensor when data synced
 */
- (void)readTempSensorHistory:(MTSensorOperatBlock)completionHandler;


@end

NS_ASSUME_NONNULL_END
