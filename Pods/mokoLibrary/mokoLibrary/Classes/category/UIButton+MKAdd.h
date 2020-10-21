//
//  UIButton+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MKAdd)

#pragma mark - Runtime解决UIButton重复点击问题
/**
 *  点击事件的事件间隔
 */
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;

#pragma mark - 设置倒计时时间（通用）
/**
 *  设置倒计时时间
 *
 *  @param seconds 设置的时间
 */
- (void)startCountdown:(NSUInteger)seconds;

@end
