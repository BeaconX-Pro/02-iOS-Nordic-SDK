//
//  MKButtonMsgCell.h
//  Pods
//
//  Created by aa on 2022/11/30.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKButtonMsgCellModel : NSObject

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

/// 右侧按钮的title
@property (nonatomic, copy)NSString *buttonTitle;

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

@protocol MKButtonMsgCellDelegate <NSObject>

/// 右侧按钮点击事件
/// @param index 当前cell所在index
- (void)mk_buttonMsgCellButtonPressed:(NSInteger)index;

@end

@interface MKButtonMsgCell : MKBaseCell

@property (nonatomic, strong)MKButtonMsgCellModel *dataModel;

@property (nonatomic, weak)id <MKButtonMsgCellDelegate>delegate;

+ (MKButtonMsgCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
