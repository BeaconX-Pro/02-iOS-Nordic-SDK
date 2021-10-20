//
//  MinewAtmosphericPressureSensor.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewAtmosphericPressureSensor : MinewFrame

// battery
@property (nonatomic, assign, readonly) NSInteger battery;

// pressure Data, Unit is hPa
@property (nonatomic, assign, readonly) double pressure;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;

@end

NS_ASSUME_NONNULL_END
