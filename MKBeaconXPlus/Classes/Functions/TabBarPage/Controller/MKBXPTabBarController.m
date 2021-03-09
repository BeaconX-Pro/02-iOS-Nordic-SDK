//
//  MKBXPTabBarController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKBXPSlotController.h"
#import "MKBXPSettingController.h"
#import "MKBXPDeviceInfoController.h"

#import "MKBXPCentralManager.h"

@interface MKBXPTabBarController ()

@property (nonatomic, assign)BOOL modifyPassword;

@property (nonatomic, assign)BOOL isShow;

@end

@implementation MKBXPTabBarController

- (void)dealloc {
    NSLog(@"MKBXPTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        self.isShow = NO;
        [[MKBXPCentralManager shared] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = YES;
    [self loadSubPages];
    [self addNotifications];
}

#pragma mark - notes
- (void)gotoScanPage {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_bxp_needResetScanDelegate:)]) {
            [sself.delegate mk_bxp_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    WS(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
        __strong typeof(self) sself = weakSelf;
        if ([sself.delegate respondsToSelector:@selector(mk_bxp_needResetScanDelegate:)]) {
            [sself.delegate mk_bxp_needResetScanDelegate:YES];
        }
    }];
}

- (void)centralManagerStateChanged {
    if (!self.isShow) {
        return;
    }
    if ([MKBXPCentralManager shared].centralStatus != mk_bxp_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (!self.isShow) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

- (void)deviceLockStateChanged {
    if (!self.isShow) {
        return;
    }
    if ([MKBXPCentralManager shared].lockState != mk_bxp_lockStateOpen
        && [MKBXPCentralManager shared].lockState != mk_bxp_lockStateUnlockAutoMaticRelockDisabled
        && [MKBXPCentralManager shared].connectState == mk_bxp_centralConnectStatusConnected) {
        [self performSelector:@selector(showLockStateAlert)
                   withObject:nil
                   afterDelay:0.1f];
    }
}

/**
 修改密码成功之后，锁定状态发生改变，弹窗提示修改密码成功
 */
- (void)modifyPasswordSuccess {
    self.modifyPassword = YES;
}

- (void)devicePowerOff {
    self.isShow = NO;
    [self showAlertWithMsg:@"The device is turned off" title:@"Dismiss"];
}

#pragma mark - private method

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_bxp_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_bxp_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyPasswordSuccess)
                                                 name:@"mk_bxp_modifyPasswordSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_bxp_peripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_bxp_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceLockStateChanged)
                                                 name:mk_bxp_peripheralLockStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(devicePowerOff)
                                                 name:@"mk_bxp_powerOffNotification"
                                               object:nil];
}

- (void)showLockStateAlert{
    NSString *msg = (self.modifyPassword ? @"Password changed successfully!Please reconnect the Device." : @"The device is locked!");
    [self showAlertWithMsg:msg title:@"Dismiss"];
}

- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_settingPageNeedDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    [self performSelector:@selector(presentAlert:) withObject:alertController afterDelay:1.2f];
}

- (void)presentAlert:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -

- (void)loadSubPages {
    MKBXPSlotController *slotPage = [[MKBXPSlotController alloc] init];
    slotPage.tabBarItem.title = @"SLOT";
    slotPage.tabBarItem.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_slotTabBarItemUnselected.png");
    slotPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_slotTabBarItemSelected.png");
    MKBaseNavigationController *slotNav = [[MKBaseNavigationController alloc] initWithRootViewController:slotPage];

    MKBXPSettingController *settingPage = [[MKBXPSettingController alloc] init];
    settingPage.tabBarItem.title = @"SETTING";
    settingPage.tabBarItem.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_settingTabBarItemUnselected.png");
    settingPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_settingTabBarItemSelected.png");
    MKBaseNavigationController *settingNav = [[MKBaseNavigationController alloc] initWithRootViewController:settingPage];

    MKBXPDeviceInfoController *devicePage = [[MKBXPDeviceInfoController alloc] init];
    devicePage.tabBarItem.title = @"DEVICE";
    devicePage.tabBarItem.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_deviceTabBarItemUnselected.png");
    devicePage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_deviceTabBarItemSelected.png");
    MKBaseNavigationController *deviceNav = [[MKBaseNavigationController alloc] initWithRootViewController:devicePage];
    
    self.viewControllers = @[slotNav,settingNav,deviceNav];
}

@end
