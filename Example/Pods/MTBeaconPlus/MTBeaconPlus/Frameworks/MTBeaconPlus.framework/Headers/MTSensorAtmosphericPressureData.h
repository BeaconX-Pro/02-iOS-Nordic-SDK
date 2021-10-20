//
//  MTSensorAtmosphericPressureData.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>


NS_ASSUME_NONNULL_BEGIN

@interface MTSensorAtmosphericPressureData : MTSensorData

@property (nonatomic, assign, readonly) NSInteger timestamp;

// pressure Data  /hPa
@property (nonatomic, assign, readonly) double pressure;

@property (nonatomic, assign, readonly) NSInteger index;

@property (nonatomic, assign) EndStatus endStatus;

- (void)updateStamp:(NSInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
