//
//  MinewiBeacon.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewiBeacon : MinewFrame

// battery
@property (nonatomic, assign, readonly) NSInteger battery;

// major
@property (nonatomic, assign) NSInteger major;

// minor
@property (nonatomic, assign) NSInteger minor;

// uuid
@property (nonatomic, strong) NSString *uuid;

// RSSI @1m
@property (nonatomic, assign) NSInteger txPower;

@end
