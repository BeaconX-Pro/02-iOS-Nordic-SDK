//
//  MKMainTabBarController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKMainTabBarController.h"
#import "MKSlotController.h"
#import "MKSettingController.h"
#import "MKDeviceInfoController.h"

NSString *const peripheralIdenty = @"peripheralIdenty";
NSString *const passwordIdenty = @"passwordIdenty";

@interface MKMainTabBarController ()

@property (nonatomic, strong)UINavigationController *optionsVC;

@property (nonatomic, strong)UINavigationController *settingVC;

@property (nonatomic, strong)UINavigationController *deviceInfoVC;

@property (nonatomic, assign)BOOL modifyPassword;

@property (nonatomic, assign)BOOL isShow;

@end

@implementation MKMainTabBarController

#pragma mark - life circle

- (void)dealloc{
    NSLog(@"MKMainTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MKDataManager shared].password = @"";
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (![[self.navigationController viewControllers] containsObject:self]){
        self.isShow = NO;
        [[MKBXPCentralManager shared] disconnect];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShow = YES;
    [self statusMonitoring];
    // Do any additional setup after loading the view.
}

#pragma mark - Notification event
- (void)centralManagerStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKBXPCentralManager shared].managerState != MKBXPCentralManagerStateEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!"];
    }
}

- (void)peripheralLockStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKBXPCentralManager shared].lockState != MKBXPLockStateOpen
        && [MKBXPCentralManager shared].lockState != MKBXPLockStateUnlockAutoMaticRelockDisabled
        && [MKBXPCentralManager shared].connectState == MKBXPConnectStatusConnected) {
        [self performSelector:@selector(showLockStateAlert)
                   withObject:nil
                   afterDelay:0.1f];
    }
}

- (void)peripheralConnectStateChanged{
    if (!self.isShow) {
        return;
    }
    if ([MKBXPCentralManager shared].connectState == MKBXPConnectStatusDisconnect
        && [MKBXPCentralManager shared].managerState == MKBXPCentralManagerStateEnable) {
        [self disconnectAlert];
    }
}

- (void)gotoRootViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)devicePowerOff{
    self.isShow = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 修改密码成功之后，锁定状态发生改变，弹窗提示修改密码成功
 */
- (void)modifyPasswordSuccess{
    self.modifyPassword = YES;
}

#pragma mark - Private method

- (void)statusMonitoring{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRootViewController) name:@"MKPopToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modifyPasswordSuccess)
                                                 name:@"MKEddStoneModifyPasswordSuccessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:MKCentralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralLockStateChanged)
                                                 name:MKPeripheralLockStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnectStateChanged)
                                                 name:MKPeripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(devicePowerOff)
                                                 name:@"MKEddystonePowerOffNotification"
                                               object:nil];
    [self loadChildVCS];
}

- (void)showLockStateAlert{
    NSString *msg = (self.modifyPassword ? @"Password modified successfully! Reconnecting the device" : @"The device is locked!");
    [self showAlertWithMsg:msg];
}

/**
 当前手机蓝牙不可用、锁定状态改为不可用的时候，提示弹窗
 
 @param msg 弹窗显示的内容
 */
- (void)showAlertWithMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf gotoRootViewController];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

/**
 eddStone设备的连接状态发生改变提示弹窗
 */
- (void)disconnectAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                             message:@"The device is disconnected"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *exitAction = [UIAlertAction actionWithTitle:@"Exit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoRootViewController];
    }];
    [alertController addAction:exitAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)reconnectDevice{
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [[MKBXPCentralManager shared] connectPeripheral:self.params[peripheralIdenty] password:self.params[passwordIdenty] progressBlock:^(float progress) {
        
    } sucBlock:^(CBPeripheral *peripheral) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Connect Success"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadChildVCS{
    self.viewControllers = @[self.optionsVC,self.settingVC,self.deviceInfoVC];
}

#pragma mark - setter & getter
- (UINavigationController *)optionsVC{
    if (!_optionsVC) {
        MKSlotController *vc = [[MKSlotController alloc] init];
        vc.tabBarItem.title = @"SLOT";
        vc.tabBarItem.image = LOADIMAGE(@"slotTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"slotTabBarItemSelected", @"png");
        _optionsVC = [[UINavigationController alloc] initWithRootViewController:vc];
        
    }
    return _optionsVC;
}

- (UINavigationController *)settingVC{
    if (!_settingVC) {
        MKSettingController *vc = [[MKSettingController alloc] init];
        vc.tabBarItem.title = @"SETTING";
        vc.tabBarItem.image = LOADIMAGE(@"settingTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"settingTabBarItemSelected", @"png");
        _settingVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return _settingVC;
}

- (UINavigationController *)deviceInfoVC{
    if (!_deviceInfoVC) {
        MKDeviceInfoController *vc = [[MKDeviceInfoController alloc] init];
        vc.tabBarItem.title = @"DEVICE";
        vc.tabBarItem.image = LOADIMAGE(@"deviceTabBarItemUnselected", @"png");
        vc.tabBarItem.selectedImage = LOADIMAGE(@"deviceTabBarItemSelected", @"png");
        _deviceInfoVC = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return _deviceInfoVC;
}

@end
