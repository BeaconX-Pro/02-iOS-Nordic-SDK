//
//  MKFilterDataCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/28.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>
#import <MKCustomUIModule/MKTextField.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_filterDataCellType) {
    mk_filterDataCellType_normal,
    mk_filterDataCellType_double,
};

@interface MKFilterDataCellModel : NSObject

#pragma mark ------------------------- cell最顶层配置 ---------------------------------

/// 当前cell所在的index
@property (nonatomic, assign)NSInteger index;

/*
    cell类型.
 对于有两个输入框的cell而言，From [textField1] To [textField2]
 一个输入框,[textField]
 */

/// 当前cell的类型，mk_filterDataCellType_normal默认是有一个输入框，mk_filterDataCellType_double有两个输入框，且显示From和To标签
@property (nonatomic, assign)mk_filterDataCellType cellType;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

/**************************************************顶部信息设置*********************************************************/

/// 顶部msg
@property (nonatomic, copy)NSString *msg;

#pragma mark ------------------------- 顶部开关配置 ---------------------------------

/// 开关状态
@property (nonatomic, assign)BOOL isOn;

/// 开关是否能用，默认YES
@property (nonatomic, assign)BOOL switchEnable;

#pragma mark ------------------------- 第二行的那个按钮配置 ---------------------------------

/// 选中按钮状态
@property (nonatomic, assign)BOOL selected;

/// 选中按钮是否可用，默认YES
@property (nonatomic, assign)BOOL enabled;

#pragma mark ------------------------- mk_filterDataCellType_normal的时候，textField的设置 ---------------------------------

/// mk_filterDataCellType_normal情况下textField的占位符
@property (nonatomic, copy)NSString *textFieldPlaceholder;

/// mk_filterDataCellType_normal情况下textField的输入类型
@property (nonatomic, assign)mk_textFieldType textFieldType;

/// mk_filterDataCellType_normal情况下textField的值
@property (nonatomic, copy)NSString *textFieldValue;

/// mk_filterDataCellType_normal情况下textField最大输入长度
@property (nonatomic, assign)NSInteger maxLength;

#pragma mark ------------------------- mk_filterDataCellType_double的时候，两个textField的设置 ---------------------------------

/// mk_filterDataCellType_double左侧输入框值
@property (nonatomic, copy)NSString *leftTextFieldValue;

/// mk_filterDataCellType_double右侧输入框值
@property (nonatomic, copy)NSString *rightTextFieldValue;

@end

@protocol MKFilterDataCellDelegate <NSObject>

@optional

/// 顶部开关状态发生改变
/// @param isOn 开关状态
/// @param index 当前cell所在index
- (void)mk_fliterSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index;

/// 按钮状态发生改变
/// @param selected 按钮选中状态
/// @param index 当前cell所在index
- (void)mk_listButtonStateChanged:(BOOL)selected index:(NSInteger)index;

/// mk_filterDataCellType==mk_filterDataCellType_normal的情况下输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_filterTextFieldValueChanged:(NSString *)value index:(NSInteger)index;

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下左侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_leftFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index;

/// mk_filterDataCellType==mk_filterDataCellType_double的情况下右侧输入框内容发生改变
/// @param value 当前textField的值
/// @param index 当前cell所在index
- (void)mk_rightFilterTextFieldValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKFilterDataCell : MKBaseCell

@property (nonatomic, strong)MKFilterDataCellModel *dataModel;

@property (nonatomic, weak)id <MKFilterDataCellDelegate>delegate;

+ (MKFilterDataCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
