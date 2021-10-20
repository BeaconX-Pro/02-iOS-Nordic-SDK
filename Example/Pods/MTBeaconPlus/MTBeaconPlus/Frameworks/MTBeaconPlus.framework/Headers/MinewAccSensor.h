//
//  MinewAccSensor.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//
#import "MinewFrame.h"

@interface MinewAccSensor : MinewFrame

// battery
@property (nonatomic, assign, readonly) NSInteger battery;

// axis on x
@property (nonatomic, assign, readonly) double XAxis;

// axis on y
@property (nonatomic, assign, readonly) double YAxis;

// axis on z
@property (nonatomic, assign, readonly) double ZAxis;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;


@end

