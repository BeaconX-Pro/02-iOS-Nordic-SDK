//
//  MTSensorMagnetometerData.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTSensorMagnetometerData : MTSensorData

@property (nonatomic, assign, readonly) NSInteger timestamp;

// axis on x, Unit is 10mG
@property (nonatomic, assign, readonly) double xAxis;

// axis on y, Unit is 10mG
@property (nonatomic, assign, readonly) double yAxis;

// axis on z, Unit is 10mG
@property (nonatomic, assign, readonly) double zAxis;

@property (nonatomic, assign, readonly) NSInteger index;

@property (nonatomic, assign) EndStatus endStatus;

- (void)updateStamp:(NSInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
