//
//  MKSettingController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSettingController.h"
#import "MKBaseTableView.h"
#import "MKIconInfoCell.h"
#import "MKSwitchStatusCell.h"

#import "MKMainCellModel.h"

#import "MKUpdateController.h"

static NSString *const MKSettingControllerCellIdenty = @"MKSettingControllerCellIdenty";

@interface MKSettingController ()<UITableViewDelegate, UITableViewDataSource, MKSwitchStatusCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *topDataList;

@property (nonatomic, strong)NSMutableArray *centerDataList;

@property (nonatomic, strong)NSMutableArray *bottomDataList;

/**
 修改名字的输入框
 */
@property (nonatomic, strong)UITextField *nameTextField;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

@property (nonatomic, assign)BOOL showPassword;

@end

@implementation MKSettingController

- (void)dealloc{
    NSLog(@"MKSettingController销毁");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getConnectable];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    //02状态下隐藏修改密码
    self.showPassword = !([MKBXPCentralManager shared].lockState == MKBXPLockStateUnlockAutoMaticRelockDisabled);
    [self loadDatas];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification"
                                                        object:nil];
}

#pragma mark - Private method

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01f)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.showPassword) {
            if (indexPath.row == 0) {
                //password
                [self setPassword];
                return;
            }
            if (indexPath.row == 1) {
                //reset
                [self factoryReset];
                return;
            }
            if (indexPath.row == 2) {
                //dfu
                self.hidesBottomBarWhenPushed = YES;
                MKUpdateController *vc = [[MKUpdateController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                return;
            }
            return;
        }
        if (indexPath.row == 0) {
            //dfu
            self.hidesBottomBarWhenPushed = YES;
            MKUpdateController *vc = [[MKUpdateController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            return;
        }
        return;
    }
    if (indexPath.section == 1) {
        MKMainCellModel *model = self.centerDataList[indexPath.row];
        UIViewController *vc = (UIViewController *)[[model.destVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.topDataList.count;
    }
    if (section == 1) {
        return self.centerDataList.count;
    }
    return self.bottomDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MKIconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:MKSettingControllerCellIdenty];
        if (!cell) {
            cell = [[MKIconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKSettingControllerCellIdenty];
        }
        cell.dataModel = self.topDataList[indexPath.row];
        
        return cell;
    }
    if (indexPath.section == 1) {
        MKIconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:MKSettingControllerCellIdenty];
        if (!cell) {
            cell = [[MKIconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKSettingControllerCellIdenty];
        }
        cell.dataModel = self.centerDataList[indexPath.row];
        
        return cell;
    }
    MKSwitchStatusCell *cell = [MKSwitchStatusCell initCellWithTableView:tableView];
    cell.indexPath = indexPath;
    MKMainCellModel *model = self.bottomDataList[indexPath.row];
    cell.dataModel = model;
    cell.isOn = model.isOn;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - MKSwitchStatusCellDelegate
- (void)needChangedCellSwitchStatus:(BOOL)isOn row:(NSInteger)row{
    if (row == 0) {
        //connectable
        [self setConnectEnable:isOn];
        return;
    }
    if (row == 1) {
        //power off
        [self powerOff];
        return;
    }
    if (row == 2) {
        //Directed-Connectable
        [self directedConnectable:isOn];
        return;
    }
}

#pragma mark - Private method

- (void)getConnectable{
    WS(weakSelf);
    [[MKHudManager share] showHUDWithTitle:@"Reading..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface readBXPConnectEnableStatusWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        MKMainCellModel *model = weakSelf.bottomDataList[0];
        model.isOn = [returnData[@"result"][@"connectEnable"] boolValue];
        [weakSelf.tableView reloadData];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置密码
- (void)setPassword{
    WS(weakSelf);
    NSString *msg = @"Note:The password should not exceed 16 characters in length.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Modify Password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordTextField = nil;
        weakSelf.passwordTextField = textField;
        [weakSelf.passwordTextField setPlaceholder:@"New password"];
        [weakSelf.passwordTextField addTarget:self
                                       action:@selector(passwordTextFieldValueChanged:)
                             forControlEvents:UIControlEventEditingChanged];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.confirmTextField = nil;
        weakSelf.confirmTextField = textField;
        [weakSelf.confirmTextField setPlaceholder:@"Confirm new password"];
        [weakSelf.confirmTextField addTarget:self
                                      action:@selector(passwordTextFieldValueChanged:)
                            forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setPasswordToDevice];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)passwordTextFieldValueChanged:(UITextField *)textField{
    NSString *tempInputString = textField.text;
    if (!ValidStr(tempInputString)) {
        textField.text = @"";
        return;
    }
    textField.text = (tempInputString.length > 16 ? [tempInputString substringToIndex:16] : tempInputString);
}

- (void)setPasswordToDevice{
    NSString *password = self.passwordTextField.text;
    NSString *confirmpassword = self.confirmTextField.text;
    if (!ValidStr(password) || !ValidStr(confirmpassword) || password.length > 16 || confirmpassword.length > 16) {
        [self.view showCentralToast:@"Length error."];
        return;
    }
    if (![password isEqualToString:confirmpassword]) {
        [self.view showCentralToast:@"Password do not match! Please try again."];
        return;
    }
    WS(weakSelf);
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface setBXPNewPassword:password originalPassword:[MKDataManager shared].password sucBlock:^(id returnData) {
        //修改密码成功之后，eddStone的锁定状态发生改变，需要区分锁定状态是由于修改密码引起的
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MKEddStoneModifyPasswordSuccessNotification"
                                                            object:nil];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"Are you sure to reset the device?";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    WS(weakSelf);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf sendResetCommandToDevice];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKBXPInterface BXPFactoryDataResetWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Reset successfully!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 设置可连接状态
- (void)setConnectEnable:(BOOL)connect{
    NSString *msg = (connect ? @"Are you sure to make device connectable?" : @"Are you sure to make device disconnectable?");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKMainCellModel *model = weakSelf.bottomDataList[0];
        model.isOn = !connect;
        [weakSelf.tableView reloadData];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setConnectStatusToDevice:connect];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKBXPInterface setBXPConnectStatus:connect sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKMainCellModel *model = weakSelf.bottomDataList[0];
        model.isOn = !connect;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 开关机
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the BeaconX? Please make sure the device has a button to turn on!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKMainCellModel *model = weakSelf.bottomDataList[1];
        model.isOn = YES;
        [weakSelf.tableView reloadData];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandPowerOff];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKBXPInterface setBXPPowerOffWithSucBlockWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MKEddystonePowerOffNotification" object:nil];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKMainCellModel *model = weakSelf.bottomDataList[1];
        model.isOn = YES;
        [weakSelf.tableView reloadData];
    }];
}

- (void)directedConnectable:(BOOL)isOn{
    NSString *msg = (isOn ? @"Are you sure to remove the password?" : @"Are you sure to revert the password?");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        MKMainCellModel *model = weakSelf.bottomDataList[2];
        model.isOn = !isOn;
        [weakSelf.tableView reloadData];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf commandForLockState:isOn];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)commandForLockState:(BOOL)isOn{
    WS(weakSelf);
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXPInterface setBXPLockState:(isOn ? MKBXPLockStateUnlockAutoMaticRelockDisabled : MKBXPLockStateOpen)
                                       sucBlock:^(id returnData) {
                                           [[MKHudManager share] hide];
                                           MKMainCellModel *model = self.bottomDataList[2];
                                           model.isOn = isOn;
                                       }
                                    failedBlock:^(NSError *error) {
                                        [[MKHudManager share] hide];
                                        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
                                        MKMainCellModel *model = self.bottomDataList[2];
                                        model.isOn = !isOn;
                                        [weakSelf.tableView reloadData];
                                    }];
}

#pragma mark -

- (void)loadDatas{
    if (self.showPassword) {
        MKMainCellModel *passwordModel = [[MKMainCellModel alloc] init];
        passwordModel.leftIconName = @"setting_password";
        passwordModel.leftMsg = @"Change Password";
        [self.topDataList addObject:passwordModel];
        
        MKMainCellModel *resetModel = [[MKMainCellModel alloc] init];
        resetModel.leftIconName = @"setting_reset";
        resetModel.leftMsg = @"Factory Reset";
        [self.topDataList addObject:resetModel];
    }
    
    MKMainCellModel *updateModel = [[MKMainCellModel alloc] init];
    updateModel.leftIconName = @"setting_updateFirmwareIcon";
    updateModel.leftMsg = @"Update Firmware";
    [self.topDataList addObject:updateModel];
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        MKMainCellModel *threeAxisModel = [[MKMainCellModel alloc] init];
        threeAxisModel.leftIconName = @"slotDataTypeThreeAccelerometerIcon";
        threeAxisModel.leftMsg = @"3-axis Sensor";
        threeAxisModel.destVC = NSClassFromString(@"MKThreeAxisConfigController");
        [self.centerDataList addObject:threeAxisModel];
    }else if ([[MKDataManager shared].deviceType isEqualToString:@"02"]) {
        //带SHT3X温湿度传感器
        MKMainCellModel *THModel = [[MKMainCellModel alloc] init];
        THModel.leftIconName = @"slotDataTypeT&HIcon";
        THModel.leftMsg = @"T&H";
        THModel.destVC = NSClassFromString(@"MKHTConfigController");
        [self.centerDataList addObject:THModel];
    }else if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        MKMainCellModel *threeAxisModel = [[MKMainCellModel alloc] init];
        threeAxisModel.leftIconName = @"slotDataTypeThreeAccelerometerIcon";
        threeAxisModel.leftMsg = @"3-axis Sensor";
        threeAxisModel.destVC = NSClassFromString(@"MKThreeAxisConfigController");
        [self.centerDataList addObject:threeAxisModel];
        
        MKMainCellModel *THModel = [[MKMainCellModel alloc] init];
        THModel.leftIconName = @"slotDataTypeT&HIcon";
        THModel.leftMsg = @"T&H";
        THModel.destVC = NSClassFromString(@"MKHTConfigController");
        [self.centerDataList addObject:THModel];
    }
    
    MKMainCellModel *connectModel = [[MKMainCellModel alloc] init];
    connectModel.leftIconName = @"setting_connectable";
    connectModel.leftMsg = @"Connectable";
    connectModel.isOn = YES;
    [self.bottomDataList addObject:connectModel];
    
    MKMainCellModel *powerOffModel = [[MKMainCellModel alloc] init];
    powerOffModel.leftIconName = @"setting_powerOff";
    powerOffModel.leftMsg = @"Power Off";
    powerOffModel.isOn = YES;
    [self.bottomDataList addObject:powerOffModel];
    
    MKMainCellModel *directedModel = [[MKMainCellModel alloc] init];
    directedModel.leftIconName = @"setting_directed";
    directedModel.leftMsg = @"No Password";
    directedModel.isOn = !self.showPassword;
    [self.bottomDataList addObject:directedModel];
    
    [self.tableView reloadData];
}

- (void)loadSubViews{
    self.defaultTitle = @"SETTING";
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - setter & getter

- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)topDataList{
    if (!_topDataList) {
        _topDataList = [NSMutableArray array];
    }
    return _topDataList;
}

- (NSMutableArray *)centerDataList {
    if (!_centerDataList) {
        _centerDataList = [NSMutableArray array];
    }
    return _centerDataList;
}

- (NSMutableArray *)bottomDataList{
    if (!_bottomDataList) {
        _bottomDataList = [NSMutableArray array];
    }
    return _bottomDataList;
}

@end
