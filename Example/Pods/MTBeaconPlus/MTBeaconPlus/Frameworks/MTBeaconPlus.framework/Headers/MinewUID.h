//
//  MinewUID.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewUID : MinewFrame

// RSSI@0m
@property (nonatomic, assign) NSInteger txPower;

// namespaceid of device
@property (nonatomic, strong) NSString *namespaceId;

// instanceid of device
@property (nonatomic, strong) NSString *instanceId;

@end
