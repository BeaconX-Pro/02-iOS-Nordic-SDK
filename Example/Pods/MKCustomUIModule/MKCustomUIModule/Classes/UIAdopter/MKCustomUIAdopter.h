//
//  MKCustomUIAdopter.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/21.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "MKTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKCustomUIAdopter : NSObject

/// 自定义按钮，圆角为7、背景颜色#2F84D0、标题大小为15.f、字体颜色为白色。
/// @param title 按钮title
/// @param target target
/// @param action action
+ (UIButton *)customButtonWithTitle:(NSString *)title
                             target:(nonnull id)target
                             action:(nonnull SEL)action;

/// 自定义圆角为7的按钮,标题大小为15.f
/// @param title 按钮title
/// @param titleColor 按钮title颜色
/// @param backgroundColor 按钮背景颜色
/// @param target target
/// @param action action
+ (UIButton *)customButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                    backgroundColor:(UIColor *)backgroundColor
                             target:(nonnull id)target
                             action:(nonnull SEL)action;

/// 生成一个自定义的内容居左、字体大小15.f、字体颜色#333333的label
+ (UILabel *)customTextLabel;

/// 自定义label
/// @param text text
/// @param textColor 标签字体颜色
/// @param font 字体大小
/// @param textAlignment 字体位置
+ (UILabel *)customLabelWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font
                   textAlignment:(NSTextAlignment)textAlignment;

/// 生成一个MKTextField，字体大小15，颜色#353535，文本居左，带边框。
/// @param msg textField的显示内容
/// @param placeHolder textField的占位符
/// @param textType 输入框类型
+ (MKTextField *)customNormalTextFieldWithText:(NSString *)text
                                   placeHolder:(NSString *)placeHolder
                                      textType:(mk_textFieldType)textType;

/// 获取富文本
/// @param strings 富文本内容
/// @param fonts 富文本内容字体大小
/// @param colors 富文本字体颜色
+ (NSMutableAttributedString *)attributedString:(NSArray <NSString *>*)strings
                                          fonts:(NSArray <UIFont *>*)fonts
                                         colors:(NSArray <UIColor *>*)colors;

/// 求富文本字符串所在控件的高度
/// @param string 富文本
/// @param viewWidth 当前富文本所在控件的最大宽度
+ (CGFloat)strHeightForAttributeStr:(NSAttributedString *)string viewWidth:(CGFloat)viewWidth;

/// 求富文本字符串所在控件的宽度
/// @param string 富文本
/// @param viewHeight 当前富文本所在控件的最大高度
+ (CGFloat)strWidthForAttributeStr:(NSAttributedString *)string viewHeight:(CGFloat)viewHeight;

/// 旋转动画
/// @param duration 旋转一周时长
+ (CABasicAnimation *)refreshAnimation:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
