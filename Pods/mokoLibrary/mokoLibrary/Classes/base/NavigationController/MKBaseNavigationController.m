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
