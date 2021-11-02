//
//  MKBaseNavigationController.m
//  MKFitpoloDevice
//
//  Created by aa on 2018/12/22.
//  Copyright © 2018 MK. All rights reserved.
//

#import "MKBaseNavigationController.h"

@interface MKBaseNavigationController ()

@end

@implementation MKBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance * appearance = [[UINavigationBarAppearance alloc] init];
        // 背景色
        appearance.backgroundColor = [UIColor whiteColor];
        // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
        appearance.shadowColor = [UIColor clearColor];
        // 带scroll滑动的页面
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        // 常规页面
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

@end
