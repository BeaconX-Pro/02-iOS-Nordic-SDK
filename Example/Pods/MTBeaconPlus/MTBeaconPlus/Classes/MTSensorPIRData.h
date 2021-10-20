//
//  MTSensorPIRData.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2018/12/27.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTSensorPIRData : MTSensorData

@property (nonatomic, assign, readonly) BOOL isRepeat;

@property (nonatomic, assign, readonly) NSInteger delaytime;

@property (nonatomic, strong) NSArray *timeAry;

- (void)update:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
