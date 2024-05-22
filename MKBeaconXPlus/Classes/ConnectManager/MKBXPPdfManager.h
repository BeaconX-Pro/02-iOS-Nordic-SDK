//
//  MKBXPPdfManager.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2024/5/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPPdfManager : NSObject

+ (instancetype)shared;


/// 将image绘制到指定位置
/// @param image image
/// @param rect rect
- (void)drawImage:(UIImage *)image rect:(CGRect)rect;

/**
 *  @brief 空心矩形
 *
 *  @param rect 空心矩形的frame
 */
- (void)drawEmptySquareWithCGRect:(CGRect)rect;
/**
 *  @brief 无边框有背景颜色的矩形
 *
 *  @param rect 矩形的frame
 */
- (void)drawSquareWithCGRect:(CGRect)rect;

/// 绘制列表头
/// @param printStr 绘制的文字
/// @param rect 文字frame
- (void)printTableHeaderStr:(NSString *)printStr CGRect:(CGRect)rect;

/// 绘制Tips
/// @param printStr 绘制的文字
/// @param rect 文字frame
- (void)printTipsStr:(NSString *)printStr CGRect:(CGRect)rect;

/// 绘制Message
/// @param printStr 绘制的文字
/// @param rect 文字frame
- (void)printMessageStr:(NSString *)printStr CGRect:(CGRect)rect;

/**
 *  @brief 两点坐标相连画线,高度1像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

/**
 *  @brief 两点坐标相连画线,高度2像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawBoldLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
/**
 *  @brief 两点坐标相连画虚线,高度1像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawDashLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;

/**
 *  @brief 两点坐标相连画虚线,高度2像素
 *
 *  @param from 起始坐标
 *  @param to 结束坐标
 */
- (void)drawDashBoldLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;


/// 绘制温度曲线
/// @param rect 要绘制的rect
/// @param minY 当前Y轴最小值(温度)
/// @param maxY 当前Y轴最大值(温度)
/// @param pointList 要绘制的数据
/*
 pointList格式
 @[
     @{@"time":@"05/13/2024 12:51:18",@"temperature":@"75.9"},
     @{@"time":@"05/13/2024 12:52:18",@"temperature":@"78.9"},
     // ...
     @{@"time":@"05/13/2024 14:06:08",@"temperature":@"63.9"}
 ];
 */
- (void)drawBezierPath:(CGRect)rect
                  minY:(CGFloat)minY
                  maxY:(CGFloat)maxY
             pointList:(NSArray <NSDictionary *>*)pointList;

/// 绘制矩形右上角带圆弧
/// @param rect 矩形rect
- (void)drawRoundedRectWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
