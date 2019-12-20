//
//  UIView+MKCategoryModule.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/21.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKCategoryModule)

/** 添加单击事件*/
- (void)addTapAction:(id)target selector:(SEL)selector;

/** 添加长按事件*/
- (void)addLongPressAction:(id)target selector:(SEL)selector;

/**
 中心位置浮层提示
 
 @param message 提示的内容
 */
- (void)showCentralToast:(NSString *)message;

/** 返回所在控制器*/
- (UIViewController *)viewController;

/** 设置圆角*/
- (void)setCornerRadius:(CGFloat)cornerRadius;

/** 基于位图返回UIImage*/
- (UIImage *)screenShotImage;

#pragma mark - 使用.x.y等设置frame
#pragma mark -
/**
 *  注意此处：利用编译器生成了getter 和 setter方法，.m中会复写
 *          不会真实使用以下这些属性
 */
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

//center
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

//left top right bottom
@property (nonatomic, readonly) CGFloat left;
@property (nonatomic, readonly) CGFloat top;
@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

- (void)setViewLeft:(CGFloat)x;
- (void)setViewTop:(CGFloat)y;
- (void)setViewWidth:(CGFloat)width;
- (void)setViewHeight:(CGFloat)height;

@end
