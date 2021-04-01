//
//  MKBXPSettingController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSettingController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextSwitchCell.h"

#import "MKBXPConnectManager.h"

#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"
#import "MKBXPInterface.h"

#import "MKBXPSettingModel.h"

#import "MKBXPUpdateController.h"
#import "MKBXPAccelerationController.h"
#import "MKBXPHTConfigController.h"

@interface MKBXPSettingController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKBXPSettingModel *dataModel;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

/// 当前present的alert
@property (nonatomic, strong)UIAlertController *currentAlert;

@property (nonatomic, assign)BOOL dfuModule;

@end

@implementation MKBXPSettingController

- (void)dealloc {
    NSLog(@"MKBXPSettingController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dfuModule) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self processTableDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
    [self addNotifications];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCellModel *cellModel = self.section0List[indexPath.row];
        if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
        return;
    }
    if (indexPath.section == 2) {
        MKNormalTextCellModel *cellModel = self.section2List[indexPath.row];
        if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
            [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
        }
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    if (section == 2) {
        return self.section2List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 1) {
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index < 3) {
        MKTextSwitchCellModel *cellModel = self.section1List[index];
        cellModel.isOn = isOn;
    }else {
        //index == 3免密登录
        if ([MKBXPConnectManager shared].newVersion) {
            MKTextSwitchCellModel *cellModel = self.section1List[index];
            cellModel.isOn = isOn;
        }else {
            //旧版本免密登录
            MKTextSwitchCellModel *cellModel = self.section1List[2];
            cellModel.isOn = isOn;
        }
    }
    
    if (index == 0) {
        //可连接性
        [self configConnectEnable:isOn];
        return;
    }
    if (index == 1) {
        //关机
        [self powerOff];
        return;
    }
    if (index == 2) {
        //按键关机
        [self configButtonPowerOff:isOn];
        return;
    }
    if (index == 3) {
        //免密登录
        [self configPasswordVerification:isOn];
        return;
    }
}

#pragma mark - 注册的通知方法
- (void)dfuModuleStart {
    self.dfuModule = YES;
}

- (void)dismissAlert {
    if (self.currentAlert && (self.presentedViewController == self.currentAlert)) {
        [self.currentAlert dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.tableView reloadData];
}

- (void)processTableDatas {
    MKTextSwitchCellModel *connectModel = self.section1List[0];
    connectModel.isOn = self.dataModel.connectable;
    
    if ([MKBXPConnectManager shared].newVersion) {
        MKTextSwitchCellModel *buttonModel = self.section1List[2];
        buttonModel.isOn = self.dataModel.buttonPowerOff;
    }
    [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - section0

- (void)loadSection0Datas {
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //带三轴加速度
        MKNormalTextCellModel *axisModel = [[MKNormalTextCellModel alloc] init];
        axisModel.showRightIcon = YES;
        axisModel.leftMsg = @"Acceleration";
        axisModel.methodName = @"pushAccelerationPage";
        [self.section0List addObject:axisModel];
        return;
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"]) {
        //带温湿度传感器
        MKNormalTextCellModel *thModel = [[MKNormalTextCellModel alloc] init];
        thModel.showRightIcon = YES;
        thModel.leftMsg = @"Temperature & Humidity";
        thModel.methodName = @"pushTemperatureHumidityPage";
        [self.section0List addObject:thModel];
        return;
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //带温湿度传感器和三轴加速度计
        MKNormalTextCellModel *axisModel = [[MKNormalTextCellModel alloc] init];
        axisModel.showRightIcon = YES;
        axisModel.leftMsg = @"Acceleration";
        axisModel.methodName = @"pushAccelerationPage";
        [self.section0List addObject:axisModel];
        
        MKNormalTextCellModel *thModel = [[MKNormalTextCellModel alloc] init];
        thModel.showRightIcon = YES;
        thModel.leftMsg = @"Temperature & Humidity";
        thModel.methodName = @"pushTemperatureHumidityPage";
        [self.section0List addObject:thModel];
        return;
    }
}

- (void)pushAccelerationPage {
    MKBXPAccelerationController *vc = [[MKBXPAccelerationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushTemperatureHumidityPage {
    MKBXPHTConfigController *vc = [[MKBXPHTConfigController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - section1

- (void)loadSection1Datas {
    MKTextSwitchCellModel *connectModel = [[MKTextSwitchCellModel alloc] init];
    connectModel.msg = @"Connectable";
    connectModel.index = 0;
    [self.section1List addObject:connectModel];
    
    MKTextSwitchCellModel *remoteModel = [[MKTextSwitchCellModel alloc] init];
    remoteModel.msg = @"Remote Power OFF";
    remoteModel.index = 1;
    [self.section1List addObject:remoteModel];
    
    if ([MKBXPConnectManager shared].newVersion) {
        //新版本固件支持固件关机功能
        MKTextSwitchCellModel *buttonModel = [[MKTextSwitchCellModel alloc] init];
        buttonModel.msg = @"Button Power OFF";
        buttonModel.index = 2;
        [self.section1List addObject:buttonModel];
    }
    
    MKTextSwitchCellModel *verificationModel = [[MKTextSwitchCellModel alloc] init];
    verificationModel.msg = @"Password Verification";
    verificationModel.index = 3;
    verificationModel.isOn = ([MKBXPCentralManager shared].lockState == mk_bxp_lockStateOpen);
    [self.section1List addObject:verificationModel];
}

#pragma mark - 配置可连接状态
- (void)configConnectEnable:(BOOL)connect{
    if (connect) {
        [self setConnectStatusToDevice:connect];
        return;
    }
    //设置设备为不可连接状态
    NSString *msg = @"Are you sure to set the device non-connectable?";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = YES;
        [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setConnectStatusToDevice:connect];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configConnectStatus:connect sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[0];
        model.isOn = !connect;
        [self.tableView mk_reloadRow:0 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - App命令关机设备
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the device?Please make sure the device has a button to turn on!";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = NO;
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self commandPowerOff];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    @weakify(self);
    [MKBXPInterface bxp_configPowerOffWithSucBlockWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_powerOffNotification" object:nil];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[1];
        model.isOn = NO;
        [self.tableView mk_reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 配置按键关机状态
- (void)configButtonPowerOff:(BOOL)isOn {
    if (isOn) {
        [self setButtonPowerOffToDevice:isOn];
        return;
    }
    //禁用按键关机
    NSString *msg = @"If disable Button Power OFF, then it  cannot power off beacon by press button operation.";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        MKTextSwitchCellModel *model = self.section1List[2];
        model.isOn = YES;
        [self.tableView mk_reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setButtonPowerOffToDevice:isOn];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)setButtonPowerOffToDevice:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configButtonPowerStatus:isOn sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        MKTextSwitchCellModel *model = self.section1List[2];
        model.isOn = !isOn;
        [self.tableView mk_reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 设置设备是否免密码登录
- (void)configPasswordVerification:(BOOL)isOn {
    if (isOn) {
        [self commandForLockState:isOn];
        return;
    }
    NSString *msg = @"Are you sure to disable password verification?";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@""
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        NSInteger index = ([MKBXPConnectManager shared].newVersion ? 3 : 2);
        MKTextSwitchCellModel *model = self.section1List[index];
        model.isOn = !isOn;
        [self.tableView mk_reloadRow:index inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self commandForLockState:isOn];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)commandForLockState:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_configLockState:(isOn ? mk_bxp_lockStateOpen : mk_bxp_lockStateUnlockAutoMaticRelockDisabled) sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self loadSection2Datas];
        [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        NSInteger index = ([MKBXPConnectManager shared].newVersion ? 3 : 2);
        MKTextSwitchCellModel *model = self.section1List[index];
        model.isOn = !isOn;
        [self.tableView mk_reloadRow:index inSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - section2

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    if (ValidStr([MKBXPConnectManager shared].password)) {
        //是否能够修改密码取决于用户是否是输入密码这种情况进来的
        MKNormalTextCellModel *passwordModel = [[MKNormalTextCellModel alloc] init];
        passwordModel.leftMsg = @"Modify Password";
        passwordModel.showRightIcon = YES;
        passwordModel.methodName = @"configPassword";
        [self.section2List addObject:passwordModel];
    }
    MKTextSwitchCellModel *verificationModel = [self.section1List lastObject];
    if (verificationModel.isOn) {
        MKNormalTextCellModel *resetModel = [[MKNormalTextCellModel alloc] init];
        resetModel.leftMsg = @"Remote Reset";
        resetModel.showRightIcon = YES;
        resetModel.methodName = @"factoryReset";
        [self.section2List addObject:resetModel];
    }
    MKNormalTextCellModel *dfuModel = [[MKNormalTextCellModel alloc] init];
    dfuModel.leftMsg = @"OTA DFU";
    dfuModel.showRightIcon = YES;
    dfuModel.methodName = @"pushDFUPage";
    [self.section2List addObject:dfuModel];
}

#pragma mark - 设置密码
- (void)configPassword{
    @weakify(self);
    self.currentAlert = nil;
    NSString *msg = @"Note:The password should not be exceed 16 characters in length.";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Change Password"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordTextField = nil;
        self.passwordTextField = textField;
        [self.passwordTextField setPlaceholder:@"Enter new password"];
        [self.passwordTextField addTarget:self
                                   action:@selector(passwordTextFieldValueChanged:)
                         forControlEvents:UIControlEventEditingChanged];
    }];
    [self.currentAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.confirmTextField = nil;
        self.confirmTextField = textField;
        [self.confirmTextField setPlaceholder:@"Enter new password again"];
        [self.confirmTextField addTarget:self
                                  action:@selector(passwordTextFieldValueChanged:)
                        forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setPasswordToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
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
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configNewPassword:password originalPassword:[MKBXPConnectManager shared].password sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_modifyPasswordSuccessNotification" object:nil];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 恢复出厂设置

- (void)factoryReset{
    NSString *msg = @"Are you sure to reset the device?";
    self.currentAlert = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [self.currentAlert addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendResetCommandToDevice];
    }];
    [self.currentAlert addAction:moreAction];
    
    [self presentViewController:self.currentAlert animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_factoryDataResetWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Reset successfully!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)pushDFUPage {
    MKBXPUpdateController *vc = [[MKBXPUpdateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuModuleStart)
                                                 name:@"mk_bxp_startDfuProcessNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissAlert)
                                                 name:@"mk_bxp_settingPageNeedDismissAlert"
                                               object:nil];
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"SETTING";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (MKBXPSettingModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPSettingModel alloc] init];
    }
    return _dataModel;
}

@end
