//
//  MinewDeviceInfo.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 8/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//
#import "MinewFrame.h"

@interface MinewDeviceInfo : MinewFrame

// device name
@property (nonatomic, strong, readonly) NSString *name;

// device mac address
@property (nonatomic, strong, readonly) NSString *mac;

// device battery
@property (nonatomic, assign, readonly) NSInteger battery;


@end
