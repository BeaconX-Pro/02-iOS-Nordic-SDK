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

#import "MKAlertController.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXDeviceInfoController.h"

#import "MKBXPSlotController.h"
#import "MKBXPSettingController.h"

#import "MKBXPDatabaseManager.h"

#import "MKBXPCentralManager.h"

#import "MKBXPConnectManager.h"

#import "MKBXPDeviceInfoModel.h"

@interface MKBXPTabBarController ()

@property (nonatomic, assign)BOOL disconnectType;

@end

@implementation MKBXPTabBarController

- (void)dealloc {
    NSLog(@"MKBXPTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[MKBXPConnectManager shared] clearParams];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKBXPCentralManager shared] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MKBLEBaseLogManager deleteLogWithFileName:@"T&HDatas"];
    [MKBLEBaseLogManager deleteLogWithFileName:@"LightSensorDatas"];
    //本地记录的温湿度数据
    [MKBXPDatabaseManager deleteDatasWithSucBlock:nil failedBlock:nil];
    [self loadSubPages];
    [self addNotifications];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxp_needResetScanDelegate:)]) {
            [self.delegate mk_bxp_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxp_needResetScanDelegate:)]) {
            [self.delegate mk_bxp_needResetScanDelegate:YES];
        }
    }];
}

- (void)centralManagerStateChanged {
    if (self.disconnectType) {
        return;
    }
    if ([MKBXPCentralManager shared].centralStatus != mk_bxp_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
    if (self.disconnectType) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

- (void)deviceLockStateChanged {
    if (self.disconnectType) {
        return;
    }
    if ([MKBXPCentralManager shared].lockState != mk_bxp_lockStateOpen
        && [MKBXPCentralManager shared].lockState != mk_bxp_lockStateUnlockAutoMaticRelockDisabled
        && [MKBXPCentralManager shared].connectState == mk_bxp_centralConnectStatusConnected) {
        [self showAlertWithMsg:@"The device is locked!" title:@"Dismiss"];
    }
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //00一分钟之内没有输入密码,01修改密码成功，02:设备恢复出厂设置
    self.disconnectType = YES;
    if ([type isEqualToString:@"01"]) {
        [self showAlertWithMsg:@"Modify password success! Please reconnect the Device." title:@""];
        return;
    }
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Reset success!Beacon is disconnected." title:@""];
        return;
    }
}

- (void)devicePowerOff {
    if (self.disconnectType) {
        return;
    }
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
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_bxp_deviceDisconnectTypeNotification"
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

- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self gotoScanPage];
    }];
    [alertController addAction:moreAction];
    
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_needDismissAlert" object:nil];
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

    MKBXDeviceInfoController *devicePage = [[MKBXDeviceInfoController alloc] init];
    devicePage.tabBarItem.title = @"DEVICE";
    devicePage.tabBarItem.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_deviceTabBarItemUnselected.png");
    devicePage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXPlus", @"MKBXPTabBarController", @"bxp_deviceTabBarItemSelected.png");
    devicePage.dataModel = [[MKBXPDeviceInfoModel alloc] init];
    @weakify(self);
    devicePage.leftButtonActionBlock = ^{
        @strongify(self);
        [self gotoScanPage];
    };
    MKBaseNavigationController *deviceNav = [[MKBaseNavigationController alloc] initWithRootViewController:devicePage];
    
    self.viewControllers = @[slotNav,settingNav,deviceNav];
}

@end
