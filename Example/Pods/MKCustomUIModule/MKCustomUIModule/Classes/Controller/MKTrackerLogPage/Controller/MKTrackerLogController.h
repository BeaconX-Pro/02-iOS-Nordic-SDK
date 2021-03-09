//
//  MKTrackerLogController.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKTrackerLogPageProtocol <NSObject>

/// 导航栏标题，默认@"Log"
@property (nonatomic, copy)NSString *title;

/// 导航栏title颜色,默认白色
@property (nonatomic, strong)UIColor *titleColor;

/// 顶部导航栏背景颜色，默认蓝色
@property (nonatomic, strong)UIColor *titleBarColor;

/// 最上面那个icon
@property (nonatomic, strong)UIImage *emailIcon;

/// icon和button中间那个label的msg
@property (nonatomic, copy)NSString *msg;

/// icon和button中间那个label字体颜色,默认#353535
@property (nonatomic, strong)UIColor *msgColor;

/// icon和button中间那个label字体大小，默认15
@property (nonatomic, strong)UIFont *msgFont;

/// 发送按钮的背景颜色
@property (nonatomic, strong)UIColor *buttonBackColor;

/// 发送按钮的title颜色，默认#2F84D0
@property (nonatomic, strong)UIColor *buttonTitleColor;

/// 发送按钮的title字体大小，默认15
@property (nonatomic, strong)UIFont *buttonLabelFont;

/// 按钮标题，默认Email
@property (nonatomic, copy)NSString *buttonTitle;

@end

@interface MKTrackerLogController : MKBaseViewController

/// 初始化
/// @param protocol UI初始化
/// @param localFileName 要发送的本地文件名字
- (instancetype)initWithProtocol:(id <MKTrackerLogPageProtocol>)protocol localFileName:(NSString *)localFileName;

@end

NS_ASSUME_NONNULL_END
