//
//  MKMixedChoiceCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark ------------------------- cellModel里面子视图配置 ---------------------------------

@interface MKMixedChoiceCellButtonModel : NSObject

/// 当前按钮所在index
@property (nonatomic, assign)NSInteger buttonIndex;

/// 当前按钮选中状态
@property (nonatomic, assign)BOOL selected;

/// 当前按钮是否可用，默认YES
@property (nonatomic, assign)BOOL enabled;

/// 选中之后左侧的按钮图标
@property (nonatomic, strong)UIImage *selectedIcon;

/// 未选中左侧的按钮图标
@property (nonatomic, strong)UIImage *normalIcon;

/// 按钮标题
@property (nonatomic, copy)NSString *buttonMsg;

/// 按钮标题颜色,默认#353535
@property (nonatomic, strong)UIColor *buttonMsgColor;

/// 按钮标题字体大小,默认11
@property (nonatomic, strong)UIFont *buttonMsgFont;

@end

#pragma mark ------------------------- cellModel配置 ---------------------------------

@interface MKMixedChoiceCellModel : NSObject

#pragma mark - ------------------------- cell顶层配置 ---------------------------------

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/// 左侧的icon，如果不写则左侧不显示
@property (nonatomic, strong)UIImage *leftIcon;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark - ------------------------ cell左侧msg配置 --------------------------------

/// 左侧显示的msg
@property (nonatomic, copy)NSString *msg;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

#pragma mark ------------------------- 子视图配置 ---------------------------------

/// 要展示的列表内容
@property (nonatomic, strong)NSArray <MKMixedChoiceCellButtonModel *>*dataList;

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

@protocol MKMixedChoiceCellDelegate <NSObject>

/// 按钮的点击事件
/// @param selected YES:选中，NO:取消选中
/// @param cellIndex 当前cell所在index
/// @param buttonIndex 点击事件button所在的index
- (void)mk_mixedChoiceSubButtonEventMethod:(BOOL)selected
                                 cellIndex:(NSInteger)cellIndex
                               buttonIndex:(NSInteger)buttonIndex;

@end

@interface MKMixedChoiceCell : MKBaseCell

@property (nonatomic, strong)MKMixedChoiceCellModel *dataModel;

@property (nonatomic, weak)id <MKMixedChoiceCellDelegate>delegate;

+ (MKMixedChoiceCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
