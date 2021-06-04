//
//  MKLoRaSettingCHCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaSettingCHCellModel : NSObject

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark ------------------------- 左侧label配置 ---------------------------------

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

#pragma mark -------------------------- 左侧按钮配置 ---------------------------------

/// 最小值按钮是否可点击,默认是YES
@property (nonatomic, assign)BOOL chLowButtonEnable;

/// 最小值列表
@property (nonatomic, strong)NSArray *chLowValueList;

/// 当前最小值所在列表的index
@property (nonatomic, assign)NSInteger chLowIndex;

/// 左侧按钮的背景颜色,默认#2F84D0
@property (nonatomic, strong)UIColor *chLowBackColor;

/// 左侧按钮的title颜色，默认白色
@property (nonatomic, strong)UIColor *chLowTitleColor;

/// 左侧按钮的title字体大小，默认15
@property (nonatomic, strong)UIFont *chLowLabelFont;

#pragma mark -------------------------- 右侧label配置 ---------------------------------

/// 最大值按钮是否可点击,默认是YES
@property (nonatomic, assign)BOOL chHighButtonEnable;

/// 最大值列表
@property (nonatomic, strong)NSArray *chHighValueList;

/// 当前最大值所在列表的index
@property (nonatomic, assign)NSInteger chHighIndex;

/// 右侧按钮的背景颜色,默认#2F84D0
@property (nonatomic, strong)UIColor *chHighBackColor;

/// 右侧按钮的title颜色，默认白色
@property (nonatomic, strong)UIColor *chHighTitleColor;

/// 右侧按钮的title字体大小，默认15
@property (nonatomic, strong)UIFont *chHighLabelFont;

#pragma mark ------------------------- 底部label配置 ---------------------------------

/// 底部note标签内容
@property (nonatomic, copy)NSString *noteMsg;

/// note标签字体颜色,默认#353535
@property (nonatomic, strong)UIColor *noteMsgColor;

/// note标签字体大小,默认12
@property (nonatomic, strong)UIFont *noteMsgFont;

/// 获取当前cell的高度
/// @param width 当前cell宽度
- (CGFloat)cellHeightWithContentWidth:(CGFloat)width;

@end

@protocol MKLoRaSettingCHCellDelegate <NSObject>

/// 选择了右侧高位的列表
/// @param value 当前选中的值
/// @param chHighIndex 当前值在高位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chHighValueChanged:(NSString *)value
                              chHighIndex:(NSInteger)chHighIndex
                                cellIndex:(NSInteger)index;

/// 选择了左侧高\低位的列表
/// @param value 当前选中的值
/// @param chLowIndex 当前值在低位列表里面的index
/// @param index 当前cell所在的index
- (void)mk_loraSetting_chLowValueChanged:(NSString *)value
                              chLowIndex:(NSInteger)chLowIndex
                               cellIndex:(NSInteger)index;

@end

@interface MKLoRaSettingCHCell : MKBaseCell

@property (nonatomic, strong)MKLoRaSettingCHCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaSettingCHCellDelegate>delegate;

+ (MKLoRaSettingCHCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
