//
//  MKBXSlotConfigTriggerCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXSlotConfigTriggerCellDelegate <NSObject>

- (void)mk_bx_triggerSwitchStatusChanged:(BOOL)isOn;

@end

@interface MKBXSlotConfigTriggerCellModel : NSObject

/// 是否打开触发条件
@property (nonatomic, assign)BOOL isOn;

/// 00:无触发,01:温度触发,02:湿度触发.03:双击触发.04:三击触发.05:移动触发.06:光感触发.07:单击触发
@property (nonatomic, copy)NSString *type;

/// 当前设备的传感器类型.
/*
 00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器,04:带光感,05:同时带有LIS3DH3轴加速度计和光感
 默认为00
 */
@property (nonatomic, copy)NSString *deviceType;

/*
 触发条件，根据type类型展示不同的值
 //无触发条件
 type=00,conditions = @{},
 
 //温度触发
 type=01,conditions = @{
 @"above":@(YES),       //YES:高于temperature值，NO:低于temperature值
 @"temperature":@"15.0",    //当前触发温度值
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //湿度触发
 type=02,conditions = @{
 @"above":@(YES),       //YES:高于humidity值，NO:低于humidity值
 @"humidity":@"1.0",    //当前触发湿度值
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //双击触发
 type=03,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //三击触发
 type=04,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //移动触发
 type=05,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //光感触发
 type=06,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 
 //单击触发
 type=07,conditions = @{
 @"time":@"3",          //持续时长
 @"start":@(YES),       //YES:开始广播，NO:停止广播
 }
 */
@property (nonatomic, strong)NSDictionary *conditions;

@end

@interface MKBXSlotConfigTriggerCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, weak)id <MKBXSlotConfigTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKBXSlotConfigTriggerCellModel *dataModel;

+ (MKBXSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
