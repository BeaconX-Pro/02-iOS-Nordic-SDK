//
//  MKBXPSlotConfigTriggerCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXPSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPSlotConfigTriggerCellDelegate <NSObject>

- (void)bxp_triggerSwitchStatusChanged:(BOOL)isOn;

@end

@interface MKBXPSlotConfigTriggerCellModel : NSObject

/// 是否打开触发条件
@property (nonatomic, assign)BOOL isOn;

/// 00:无触发,01:温度触发,02:湿度触发.03:双击触发.04:三击触发.05:移动触发.06:静止触发
@property (nonatomic, copy)NSString *type;

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
 
 */
@property (nonatomic, strong)NSDictionary *conditions;

@end

@interface MKBXPSlotConfigTriggerCell : MKBaseCell<MKBXPSlotConfigCellProtocol>

@property (nonatomic, weak)id <MKBXPSlotConfigTriggerCellDelegate>delegate;

@property (nonatomic, strong)MKBXPSlotConfigTriggerCellModel *dataModel;

+ (MKBXPSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
