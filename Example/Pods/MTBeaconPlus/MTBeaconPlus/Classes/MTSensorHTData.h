//
//  MTSensorHTData.h
//  MTBeaconPlus
//
//  Created by Minewtech on 2018/12/27.
//  Copyright © 2018 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTSensorHTData : MTSensorData

@property (nonatomic, assign, readonly) NSInteger timestamp;

@property (nonatomic, assign, readonly) double temperature;

@property (nonatomic, assign, readonly) double humidity;

@property (nonatomic, assign, readonly) NSInteger index;

@property (nonatomic, assign) EndStatus endStatus;

- (void)updateStamp:(NSInteger)timestamp;

@end

NS_ASSUME_NONNULL_END
