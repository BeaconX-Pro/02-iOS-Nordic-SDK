//
//  MinewForceSensor.h
//  MTBeaconPlus
//
//  Created by SACRELEE on 10/30/18.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewForceSensor: MinewFrame

//mac address
@property (nonatomic, strong) NSString *mac;

//battery
@property (nonatomic, assign) NSInteger battery;

//Force gramvalue
@property (nonatomic, assign) NSInteger gramValue;


@end
