//
//  MinewLineBeacon.h
//  MTBeaconPlus
//
//  Created by minew on 2020/1/14.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewLineBeacon : MinewFrame



//HWID
@property (nonatomic, strong) NSString *hwId;

//authenticationCode
@property (nonatomic, strong) NSString *authenticationCode;

// Masked timestamp 取 Timestamp 后两个byte
@property (nonatomic, strong) NSString *timestamp;

// RSSI @1m
@property (nonatomic, assign) NSInteger txPower;

@end

NS_ASSUME_NONNULL_END
