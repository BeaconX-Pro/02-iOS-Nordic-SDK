//
//  MinewPIRSensor.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2018/12/21.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewPIRSensor : MinewFrame

//mac address
@property (nonatomic, strong) NSString *mac;

//battery
@property (nonatomic, assign) NSInteger battery;

//PIR value
@property (nonatomic, assign) NSInteger value;

@end
