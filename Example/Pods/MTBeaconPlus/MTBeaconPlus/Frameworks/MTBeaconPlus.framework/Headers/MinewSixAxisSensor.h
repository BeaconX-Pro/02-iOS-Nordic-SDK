//
//  MinewSixAxisSensor.h
//  MTBeaconPlus
//
//  Created by minew on 2020/10/23.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <MTBeaconPlus/MTBeaconPlus.h>

NS_ASSUME_NONNULL_BEGIN

@interface MinewSixAxisSensor : MinewFrame


// acc axis on x, Unit is gee
@property (nonatomic, assign, readonly) double accXAxis;

// acc axis on y, Unit is gee
@property (nonatomic, assign, readonly) double accYAxis;

// acc axis on z, Unit is gee
@property (nonatomic, assign, readonly) double accZAxis;

// deg axis on x, if you want to transform rad/s, please divide by 57.3.
@property (nonatomic, assign, readonly) double degXAxis;

// deg axis on y, if you want to transform rad/s, please divide by 57.3.
@property (nonatomic, assign, readonly) double degYAxis;

// deg axis on z, if you want to transform rad/s, please divide by 57.3.
@property (nonatomic, assign, readonly) double degZAxis;

// mac address
@property (nonatomic, strong, readonly) NSString *mac;

@end

NS_ASSUME_NONNULL_END
