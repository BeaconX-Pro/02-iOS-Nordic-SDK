//
//  MKTextButtonCell.h
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

/*
    右侧按钮点击事件会抛出MKTextFieldNeedHiddenKeyboard通知
 [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
 */

NS_ASSUME_NONNULL_BEGIN

@interface MKTextButtonCellModel : NSObject

#pragma mark ------------------------- cell顶层配置 ---------------------------------

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark ------------------------- 左侧label配置 ---------------------------------

/// 左侧显示的msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

#pragma mark ------------------------- 右侧按钮和数据源配置 ---------------------------------

/// 按钮是否相应点击事件,默认是YES,如果想禁用按钮，则设置成NO
@property (nonatomic, assign)BOOL buttonEnable;

/// 点击右侧按钮时显示的pickView列表数据源
@property (nonatomic, strong)NSArray *dataList;

/// 当前数据源dataList选中的index,右侧按钮会显示dataList[dataListIndex]
@property (nonatomic, assign)NSInteger dataListIndex;

/// 右侧按钮的背景颜色,默认#2F84D0
@property (nonatomic, strong)UIColor *buttonBackColor;

/// 右侧按钮的title颜色，默认白色
@property (nonatomic, strong)UIColor *buttonTitleColor;

/// 右侧按钮的title字体大小，默认15
@property (nonatomic, strong)UIFont *buttonLabelFont;

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

@protocol MKTextButtonCellDelegate <NSObject>

/// 右侧按钮点击触发的回调事件
/// @param index 当前cell所在的index
/// @param dataListIndex 点击按钮选中的dataList里面的index
/// @param value dataList[dataListIndex]
- (void)mk_loraTextButtonCellSelected:(NSInteger)index
                        dataListIndex:(NSInteger)dataListIndex
                                value:(NSString *)value;

@end

@interface MKTextButtonCell : MKBaseCell

@property (nonatomic, strong)MKTextButtonCellModel *dataModel;

@property (nonatomic, weak)id <MKTextButtonCellDelegate>delegate;

+ (MKTextButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
