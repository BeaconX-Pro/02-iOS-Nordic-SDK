//
//  MKTextSwitchCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTextSwitchCellModel : NSObject

#pragma mark ------------------------- cell顶层配置 ---------------------------------
/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark ------------------------- 左侧label和icon配置 ---------------------------------

/// 左侧图标
@property (nonatomic, strong)UIImage *leftIcon;

/// 左侧msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

#pragma mark ------------------------- 开关配置 ---------------------------------

/// 开关状态
@property (nonatomic, assign)BOOL isOn;

/// 开关是否能用，默认YES
@property (nonatomic, assign)BOOL switchEnable;

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

@protocol mk_textSwitchCellDelegate <NSObject>

/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index;

@end

@interface MKTextSwitchCell : MKBaseCell

@property (nonatomic, strong)MKTextSwitchCellModel *dataModel;

@property (nonatomic, weak)id <mk_textSwitchCellDelegate>delegate;

+ (MKTextSwitchCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
