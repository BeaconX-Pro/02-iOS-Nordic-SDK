//
//  MKProgressView.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKProgressView : UIView

/**
 背景颜色,圆环所在视图背景除外
 */
@property (nonatomic, strong)UIColor *backColor;

/**
 圆环所在背景视图颜色
 */
@property (nonatomic, strong)UIColor *alertColor;

/**
 中间进度圆环直径，50.f~270.f
 */
@property (nonatomic, assign)CGFloat progressViewHeight;

/**
 中间圆环宽度，默认5.f,范围0.f~20.f
 */
@property (nonatomic, assign)CGFloat circleWidth;

/**
 init

 @param title title
 @param message 底部message
 @return self
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;

- (void)dismiss;

/**
 设置当前进度

 @param progress 0.0~1.0，如果传入的大于1，则按照1*0.01处理
 @param animated animated
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
