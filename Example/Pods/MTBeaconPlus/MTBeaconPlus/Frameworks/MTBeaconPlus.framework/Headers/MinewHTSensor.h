//
//  MinewHTSensor.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//
#import "MinewFrame.h"

@interface MinewHTSensor : MinewFrame

// temperature, maybe nil in connection stage.
@property (nonatomic, assign, readonly) double temperature;

// humidity, maybe nil in connection stage.
@property (nonatomic, assign, readonly) double humidity;

// battery left
@property (nonatomic, assign, readonly) NSInteger battery;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;

// temperature history, maybe nil in connection stage.
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *temperatures;

// humidity history, maybe nil in connection stage.
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *humiditys;

@end
