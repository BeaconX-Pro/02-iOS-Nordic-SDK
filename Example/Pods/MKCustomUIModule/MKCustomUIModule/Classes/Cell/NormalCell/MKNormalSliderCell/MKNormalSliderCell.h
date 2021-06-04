//
//  MKNormalSliderCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKNormalSliderCellModel : NSObject

#pragma mark ------------------------- cell顶层配置 ---------------------------------

/// 当前index，slider内容发生改变的时候，会连同slder值和该index一起回调，可以用来标示当前是哪个cell的回调事件
@property (nonatomic, assign)NSInteger index;

/// 顶部msg必须用富文本字符串显示
@property (nonatomic, copy)NSAttributedString *msg;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark ------------------------- 右侧单位label配置 ---------------------------------

/// 滑竿滑动的时候显示的单位,默认dBm
@property (nonatomic, copy)NSString *unit;

/// 单位标签字体颜色，默认默认#353535
@property (nonatomic, strong)UIColor *unitColor;

/// 单位标签字体大小,默认11
@property (nonatomic, strong)UIFont *unitFont;

#pragma mark ------------------------- 滑竿配置 ---------------------------------

/// 是否启用滑竿，默认YES
@property (nonatomic, assign)BOOL sliderEnable;

/// 滑竿最小值，默认-127
@property (nonatomic, assign)NSInteger sliderMinValue;

/// 滑竿最大值，默认0
@property (nonatomic, assign)NSInteger sliderMaxValue;

/// 滑竿值，默认0
@property (nonatomic, assign)NSInteger sliderValue;

#pragma mark - ------------------------- 底部label配置 ---------------------------------

/// 是否动态改变底部note
@property (nonatomic, assign)BOOL changed;

/// 底部note标签内容.(changed = NO)
@property (nonatomic, copy)NSString *noteMsg;

/// 底部note标签内容是leftNoteMsg + 滑竿值+单位+rightNoteMsg.(changed = YES)
@property (nonatomic, copy)NSString *leftNoteMsg;

/// 底部note标签内容是leftNoteMsg + 滑竿值+单位+rightNoteMsg.(changed = YES)
@property (nonatomic, copy)NSString *rightNoteMsg;

/// note标签字体颜色,默认#353535
@property (nonatomic, strong)UIColor *noteMsgColor;

/// note标签字体大小,默认12
@property (nonatomic, strong)UIFont *noteMsgFont;

/// 获取当前cell的高度
/// @param width 当前cell宽度
- (CGFloat)cellHeightWithContentWidth:(CGFloat)width;

@end

@protocol MKNormalSliderCellDelegate <NSObject>

/// slider值发生改变的回调事件
/// @param value 当前slider的值
/// @param index 当前cell所在的index
- (void)mk_normalSliderValueChanged:(NSInteger)value index:(NSInteger)index;

@end

@interface MKNormalSliderCell : MKBaseCell

@property (nonatomic, strong)MKNormalSliderCellModel *dataModel;

@property (nonatomic, weak)id <MKNormalSliderCellDelegate>delegate;

+ (MKNormalSliderCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
