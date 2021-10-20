//
//  MinewTLM.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewTLM : MinewFrame

// battery voltage
@property (nonatomic, assign, readonly) NSInteger batteryVol;

// temperature
@property (nonatomic, assign, readonly) double temperature;

// count of advertising
@property (nonatomic, assign, readonly) NSInteger advCount;

// count of second after poweron
@property (nonatomic, assign, readonly) NSInteger secCount;

@end
