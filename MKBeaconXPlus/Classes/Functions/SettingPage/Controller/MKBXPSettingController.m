//
//  MKBXPSettingController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSettingController.h"

#import "MLInputDodger.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"
#import "MKTextFieldCell.h"
#import "MKAlertController.h"

#import "MKBXPConnectManager.h"

#import "MKBXPInterface+MKBXPConfig.h"
#import "MKBXPInterface.h"

#import "MKBXPSensorConfigController.h"
#import "MKBXPQuickSwitchController.h"
#import "MKBXPUpdateController.h"

@interface MKBXPSettingController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *section3List;

@property (nonatomic, strong)UITextField *passwordTextField;

@property (nonatomic, strong)UITextField *confirmTextField;

@property (nonatomic, assign)BOOL dfuModule;

@property (nonatomic, copy)NSString *interval;

@end

@implementation MKBXPSettingController

- (void)dealloc {
    NSLog(@"MKBXPSettingController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    if (self.dfuModule) {
        return;
    }
    [self readDataFromDevice];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSection0Datas];
    [self loadSection2Datas];
    [self loadSection3Datas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStartDFUProcess)
                                                 name:@"mk_bxp_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_popToRootViewControllerNotification" object:nil];
}

- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *cellModel = nil;
    
    if (indexPath.section == 0) {
        cellModel = self.section0List[indexPath.row];
    }else if (indexPath.section == 1) {
        cellModel = self.section1List[indexPath.row];
    }else if (indexPath.section == 2) {
        cellModel = self.section2List[indexPath.row];
    }
    if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
        [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
    if (section == 3) {
        return self.section3List.count;
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
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        return cell;
    }
    if (indexPath.section == 2) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section2List[indexPath.row];
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section3List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Effective click interval
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = value;
        self.interval = value;
        return;
    }
}

#pragma mark - note
- (void)deviceStartDFUProcess {
    self.dfuModule = YES;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_readEffectiveClickIntervalWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSInteger tempData = [returnData[@"result"][@"interval"] integerValue] / 100;
        self.interval = [NSString stringWithFormat:@"%ld",(long)tempData];
        MKTextFieldCellModel *cellModel = self.section3List[0];
        cellModel.textFieldValue = self.interval;
        [self loadSection1Datas];
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self loadSection1Datas];
        [self.tableView reloadData];
    }];
}

- (void)saveDataToDevice {
    if (!ValidStr(self.interval) || [self.interval integerValue] < 5 || [self.interval integerValue] > 15) {
        [self.view showCentralToast:@"Params Error"];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_configEffectiveClickInterval:[self.interval integerValue] sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - section0
- (void)loadSection0Datas {
    if (![[MKBXPConnectManager shared].deviceType isEqualToString:@"00"]) {
        //00为不带传感器
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"Sensor configurations";
        cellModel1.methodName = @"pushSensorConfigPage";
        [self.section0List addObject:cellModel1];
    }
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.showRightIcon = YES;
    cellModel2.leftMsg = @"Quick switch";
    cellModel2.methodName = @"pushQuickSwitchPage";
    [self.section0List addObject:cellModel2];
    
    MKNormalTextCellModel *cellModel3 = [[MKNormalTextCellModel alloc] init];
    cellModel3.showRightIcon = YES;
    cellModel3.leftMsg = @"Turn off Beacon";
    cellModel3.methodName = @"powerOff";
    [self.section0List addObject:cellModel3];
}

#pragma mark - 传感器设置
- (void)pushSensorConfigPage {
    MKBXPSensorConfigController *vc = [[MKBXPSensorConfigController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 开关状态设置
- (void)pushQuickSwitchPage {
    MKBXPQuickSwitchController *vc = [[MKBXPQuickSwitchController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - App命令关机设备
- (void)powerOff{
    NSString *msg = @"Are you sure to turn off the Beacon?Please make sure the Beacon has a button to turn on!";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self commandPowerOff];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)commandPowerOff{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    @weakify(self);
    [MKBXPInterface bxp_configPowerOffWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_powerOffNotification" object:nil];
    } failedBlock:^(NSError *error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - section1
- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    if ([MKBXPConnectManager shared].passwordVerification) {
        MKNormalTextCellModel *resetModel = [[MKNormalTextCellModel alloc] init];
        resetModel.leftMsg = @"Reset Beacon";
        resetModel.showRightIcon = YES;
        resetModel.methodName = @"factoryReset";
        [self.section1List addObject:resetModel];
    }
    if (ValidStr([MKBXPConnectManager shared].password) && [MKBXPConnectManager shared].passwordVerification) {
        //是否能够修改密码取决于用户是否是输入密码这种情况进来的
        MKNormalTextCellModel *passwordModel = [[MKNormalTextCellModel alloc] init];
        passwordModel.leftMsg = @"Modify password";
        passwordModel.showRightIcon = YES;
        passwordModel.methodName = @"configPassword";
        [self.section1List addObject:passwordModel];
    }
}

#pragma mark - 设置密码
- (void)configPassword{
    @weakify(self);
    NSString *msg = @"Note:The password should not be exceed 16 characters in length.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Modify password"
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordTextField = nil;
        self.passwordTextField = textField;
        [self.passwordTextField setPlaceholder:@"Enter new password"];
        [self.passwordTextField addTarget:self
                                   action:@selector(passwordTextFieldValueChanged:)
                         forControlEvents:UIControlEventEditingChanged];
    }];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.confirmTextField = nil;
        self.confirmTextField = textField;
        [self.confirmTextField setPlaceholder:@"Enter new password again"];
        [self.confirmTextField addTarget:self
                                  action:@selector(passwordTextFieldValueChanged:)
                        forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setPasswordToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
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
        [self.view showCentralToast:@"Password not match! Please try again."];
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configNewPassword:password originalPassword:[MKBXPConnectManager shared].password sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_modifyPasswordSuccessNotification" object:nil];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 恢复出厂设置
- (void)factoryReset{
    NSString *msg = @"Are you sure to reset the Beacon?";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertView addAction:cancelAction];
    @weakify(self);
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self sendResetCommandToDevice];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)sendResetCommandToDevice{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_factoryDataResetWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - section2
- (void)loadSection2Datas {
    MKNormalTextCellModel *dfuModel = [[MKNormalTextCellModel alloc] init];
    dfuModel.leftMsg = @"DFU";
    dfuModel.showRightIcon = YES;
    dfuModel.methodName = @"pushDFUPage";
    [self.section2List addObject:dfuModel];
}

- (void)pushDFUPage {
    MKBXPUpdateController *vc = [[MKBXPUpdateController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - section3
- (void)loadSection3Datas {
    MKTextFieldCellModel *cellModel = [[MKTextFieldCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Effective click interval";
    cellModel.textPlaceholder = @"5 ~ 15";
    cellModel.maxLength = 2;
    cellModel.textFieldType = mk_realNumberOnly;
    cellModel.unit = @"x 100ms";
    [self.section3List addObject:cellModel];
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"SETTING";
    [self.rightButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPSettingController", @"bxp_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-49.f);
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

- (NSMutableArray *)section3List {
    if (!_section3List) {
        _section3List = [NSMutableArray array];
    }
    return _section3List;
}

@end
