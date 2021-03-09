//
//  MKBXPAccelerationModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPAccelerationModel : NSObject

/// 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
@property (nonatomic, assign)NSInteger samplingRate;

/// 0:±2g,1:±4g,2:±8g,3:±16g
@property (nonatomic, assign)NSInteger scale;

@property (nonatomic, assign)NSInteger sensitivityValue;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
