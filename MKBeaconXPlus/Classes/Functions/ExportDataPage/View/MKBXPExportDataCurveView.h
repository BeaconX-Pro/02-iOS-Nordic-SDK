//
//  MKBXPExportDataCurveView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPExportDataCurveView : UIView

/// 绘制温湿度曲线图
/// @param temperatureList 温度数据列表
/// @param temperatureMax 温度列表里面的最大值
/// @param temperatureMin 温度列表里面的最小值
/// @param humidityList 湿度数据列表
/// @param humidityMax 湿度列表里面的最大值
/// @param humidityMin 湿度列表里面的最小值
/// @param completeBlock 绘制曲线图完成回调
- (void)updateTemperatureDatas:(NSArray <NSString *>*)temperatureList
                temperatureMax:(CGFloat)temperatureMax
                temperatureMin:(CGFloat)temperatureMin
                  humidityList:(NSArray <NSString *>*)humidityList
                   humidityMax:(CGFloat)humidityMax
                   humidityMin:(CGFloat)humidityMin
                 completeBlock:(void (^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
