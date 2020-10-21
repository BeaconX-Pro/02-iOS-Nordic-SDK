//
//  UIView+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/21.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKAdd)

/** 添加单击事件*/
- (void)addTapAction:(id)target selector:(SEL)selector;

/** 添加长按事件*/
- (void)addLongPressAction:(id)target selector:(SEL)selector;

/**
 中心位置浮层提示
 
 @param message 提示的内容
 */
- (void)showCentralToast:(NSString *)message;

/** 设置圆角*/
- (void)setCornerRadius:(CGFloat)cornerRadius;

@end
