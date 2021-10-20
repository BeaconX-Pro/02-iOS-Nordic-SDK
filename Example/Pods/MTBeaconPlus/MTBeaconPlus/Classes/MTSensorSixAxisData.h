//
//  MTSensorSixAxisData.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

typedef NS_ENUM(NSInteger, SixAxisType) {
    SixAxisTypeAcc,
    SixAxisTypeDeg,
};

NS_ASSUME_NONNULL_BEGIN

@interface MTSensorSixAxisData : MTSensorData

@property (nonatomic, assign, readonly) NSInteger timestamp;

@property (nonatomic, assign, readonly) SixAxisType sixAxisType;

// acc axis on x, Unit is g
@property (nonatomic, assign, readonly) double accXAxis;

// acc axis on y, Unit is g
@property (nonatomic, assign, readonly) double accYAxis;

// acc axis on z, Unit is g
@property (nonatomic, assign, readonly) double accZAxis;

// deg axis on x, Unit is dps
@property (nonatomic, assign, readonly) double degXAxis;

// deg axis on y, Unit is dps
@property (nonatomic, assign, readonly) double degYAxis;

// deg axis on z, Unit is dps
@property (nonatomic, assign, readonly) double degZAxis;

@property (nonatomic, assign, readonly) NSInteger index;

@property (nonatomic, assign) EndStatus endStatus;

- (void)updateStamp:(NSInteger)timestamp;


@end

NS_ASSUME_NONNULL_END
