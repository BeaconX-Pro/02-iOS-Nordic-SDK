//
//  MinewLightSensor.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewLightSensor : MinewFrame

// battery
@property (nonatomic, assign, readonly) NSInteger battery;

// current light intensity
@property (nonatomic, assign, readonly) NSInteger luxValue;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;


@end
