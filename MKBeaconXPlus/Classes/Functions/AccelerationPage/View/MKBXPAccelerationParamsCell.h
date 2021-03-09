//
//  MKBXPAccelerationParamsCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPAccelerationParamsCellModel : NSObject

/// 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
@property (nonatomic, assign)NSInteger samplingRate;

/// 0:±2g,1:±4g,2:±8g,3:±16g
@property (nonatomic, assign)NSInteger scale;

@property (nonatomic, assign)NSInteger sensitivityValue;

@end

@protocol MKBXPAccelerationParamsCellDelegate <NSObject>

/// 用户改变了scale.
/// @param scale 0:±2g,1:±4g,2:±8g,3:±16g
- (void)bxp_accelerationParamsScaleChanged:(NSInteger)scale;

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxp_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate;

/// 用户改变了sensitivityValue
/// @param sensitivityValue sensitivityValue
- (void)bxp_accelerationParamsSensitivityValueChanged:(NSInteger)sensitivityValue;

@end

@interface MKBXPAccelerationParamsCell : MKBaseCell

@property (nonatomic, weak)id <MKBXPAccelerationParamsCellDelegate>delegate;

@property (nonatomic, strong)MKBXPAccelerationParamsCellModel *dataModel;

+ (MKBXPAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
