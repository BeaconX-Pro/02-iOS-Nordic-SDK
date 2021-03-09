//
//  MKCustomUIAdopter.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/21.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCustomUIAdopter : NSObject

/// 自定义按钮，圆角为7的按钮
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
