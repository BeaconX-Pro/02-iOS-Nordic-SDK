//
//  MinewMagnetometerSensor.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewMagnetometerSensor : MinewFrame

// battery
@property (nonatomic, assign, readonly) NSInteger battery;

// axis on x, Unit is 10mG
@property (nonatomic, assign, readonly) double XAxis;

// axis on y, Unit is 10mG
@property (nonatomic, assign, readonly) double YAxis;

// axis on z, Unit is 10mG
@property (nonatomic, assign, readonly) double ZAxis;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;

@end

NS_ASSUME_NONNULL_END
