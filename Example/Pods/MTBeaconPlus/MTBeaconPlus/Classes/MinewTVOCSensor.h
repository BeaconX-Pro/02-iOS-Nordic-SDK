//
//  MinewTVOCSensor.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2019/2/14.
//  Copyright © 2019 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewTVOCSensor : MinewFrame

// mac address
@property (nonatomic, strong) NSString *mac;

// battery
@property (nonatomic, assign) NSInteger battery;

//TVOC value
@property (nonatomic, assign) NSInteger value;

@end

NS_ASSUME_NONNULL_END
