//
//  MKBaseViewController.h
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSUInteger, MKNaviType){
    /**
     *  显示自带的NavigationBar
     */
    MKNaviTypeShow,
    /**
     *  隐藏自带的NavigationBar
     */
    MKNaviTypeHide
};

@interface MKBaseViewController : UIViewController

/**
 *  标题label
 */
@property(nonatomic,strong, readonly) UILabel  *titleLabel;
/**
 *  左按钮
 */
@property(nonatomic,strong, readonly) UIButton *leftButton;
/**
 *  右按钮
 */
@property(nonatomic,strong, readonly) UIButton *rightButton;
/**
 *  controlle是否是 经过 presentViewController:animated:completion: 推出来，默认为NO
 */
@property (nonatomic,assign) BOOL isPrensent;
/**
 标题栏
 */
@property (nonatomic, copy)NSString *defaultTitle;

/**
 自定义导航栏颜色
 */
@property (nonatomic, strong)UIColor *custom_naviBarColor;

/**
 初始化方法
 
 @param type GYNaviType
 
 */
- (instancetype)initWithNavigationType:(MKNaviType)type;

/**
 *  设置导航栏背景颜色
 *
 *  @param image 图片
 */
-(void)setNavigationBarImage:(UIImage*)image;

/**
 *  左按钮方法
 */
-(void)leftButtonMethod;

/**
 *  右按钮方法
 */
-(void)rightButtonMethod;

/**
 *  判断当前显示的是否是本控制器
 *
 *  @param viewController 控制器类
 *
 *  @return YES NO
 */
+(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController;

- (void)popToViewControllerWithClassName:(NSString *)className;

@end
