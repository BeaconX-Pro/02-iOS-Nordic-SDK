//
//  MinewTempSensor.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2019/2/14.
//  Copyright © 2019 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewTempSensor : MinewFrame

// mac address
@property (nonatomic, strong) NSString *mac;

// battery
@property (nonatomic, assign) NSInteger battery;

// temperature
@property (nonatomic, assign, readonly) double temperature;

// temperature history, maybe nil in connection stage.
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *temperatures;

@end

NS_ASSUME_NONNULL_END
