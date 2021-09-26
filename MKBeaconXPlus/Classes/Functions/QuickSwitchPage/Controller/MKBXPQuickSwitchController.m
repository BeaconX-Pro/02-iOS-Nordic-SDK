//
//  MKBXPQuickSwitchController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPQuickSwitchController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseCollectionView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKAlertController.h"

#import "MKBXQuickSwitchCell.h"

#import "MKBXPConnectManager.h"

#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPQuickSwitchModel.h"

@interface MKBXPQuickSwitchController ()<UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
MKBXQuickSwitchCellDelegate>

@property (nonatomic, strong)MKBaseCollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXPQuickSwitchModel *dataModel;

@end

@implementation MKBXPQuickSwitchController

- (void)dealloc {
    NSLog(@"MKBXPQuickSwitchController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MKBXQuickSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty" forIndexPath:indexPath];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kViewWidth - 3 * 11.f) / 2, 85.f);
}

#pragma mark - MKBXQuickSwitchCellDelegate
- (void)mk_bx_quickSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //可连接性
        [self configConnectEnable:isOn];
        return;
    }
    if (index == 1) {
        //按键关机
        [self configButtonPowerOff:isOn];
        return;
    }
    if (index == 2) {
        //密码验证
        [self configPasswordVerification:isOn];
        return;
    }
    if (index == 3) {
        //按键恢复出厂设置
        [self configButtonReset:isOn];
        return;
    }
    if (index == 4) {
        //设置LED触发
        [self configTriggerLEDNotification:isOn];
        return;
    }
}

#pragma mark - 设置参数部分

#pragma mark - 设置可连接状态
- (void)configConnectEnable:(BOOL)connect{
    if (connect) {
        [self setConnectStatusToDevice:connect];
        return;
    }
    //设置设备为不可连接状态
    NSString *msg = @"Are you sure to set the Beacon non-connectable？";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setConnectStatusToDevice:connect];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)setConnectStatusToDevice:(BOOL)connect{
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configConnectStatus:connect sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[0];
        cellModel.isOn = connect;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 设置LED触发功能
- (void)configTriggerLEDNotification:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configLEDTriggerStatus:isOn sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[1];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 配置按键关机状态
- (void)configButtonPowerOff:(BOOL)isOn {
    if (isOn) {
        [self setButtonPowerOffToDevice:isOn];
        return;
    }
    //禁用按键关机
    NSString *msg = @"If this function is disabled, you cannot power off the Beacon by button.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setButtonPowerOffToDevice:isOn];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)setButtonPowerOffToDevice:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configButtonPowerStatus:isOn sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[2];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 配置按键恢复出厂开关
- (void)configButtonReset:(BOOL)isOn {
    if (isOn) {
        [self setButtonResetToDevice:isOn];
        return;
    }
    //禁用按键关机
    NSString *msg = @"If Button reset is disabled, you cannot reset the Beacon by button operation.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self setButtonResetToDevice:isOn];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)setButtonResetToDevice:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    [MKBXPInterface bxp_configResetBeaconByButtonStatus:isOn sucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[3];
        cellModel.isOn = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 设置设备是否免密码登录
- (void)configPasswordVerification:(BOOL)isOn {
    if (isOn) {
        [self commandForLockState:isOn];
        return;
    }
    NSString *msg = @"If Password verification is disabled, it will not need password to connect the Beacon.";
    MKAlertController *alertView = [MKAlertController alertControllerWithTitle:@""
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
    alertView.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [alertView addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self commandForLockState:isOn];
    }];
    [alertView addAction:moreAction];
    
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)commandForLockState:(BOOL)isOn{
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_configLockState:(isOn ? mk_bxp_lockStateOpen : mk_bxp_lockStateUnlockAutoMaticRelockDisabled) sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        MKBXQuickSwitchCellModel *cellModel = self.dataList[4];
        cellModel.isOn = isOn;
        [MKBXPConnectManager shared].passwordVerification = isOn;
        [self.view showCentralToast:@"Success!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.collectionView reloadData];
    }];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionData];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionData
- (void)loadSectionData {
    MKBXQuickSwitchCellModel *cellModel1 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.titleMsg = @"Connectable status";
    cellModel1.isOn = self.dataModel.connectable;
    [self.dataList addObject:cellModel1];
    
    MKBXQuickSwitchCellModel *cellModel2 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.titleMsg = @"Turn off Beacon by button";
    cellModel2.isOn = self.dataModel.turnOffByButton;
    [self.dataList addObject:cellModel2];
    
    MKBXQuickSwitchCellModel *cellModel3 = [[MKBXQuickSwitchCellModel alloc] init];
    cellModel3.index = 2;
    cellModel3.titleMsg = @"Password verification";
    cellModel3.isOn = self.dataModel.passwordVerification;
    [self.dataList addObject:cellModel3];
    
    if (self.dataModel.supportResetByButton) {
        MKBXQuickSwitchCellModel *cellModel4 = [[MKBXQuickSwitchCellModel alloc] init];
        cellModel4.index = 3;
        cellModel4.titleMsg = @"Reset Beacon by button";
        cellModel4.isOn = self.dataModel.resetByButton;
        [self.dataList addObject:cellModel4];
    }
    
    if (self.dataModel.supportLED) {
        MKBXQuickSwitchCellModel *cellModel5 = [[MKBXQuickSwitchCellModel alloc] init];
        cellModel5.index = 4;
        cellModel5.titleMsg = @"Trigger LED indicator";
        cellModel5.isOn = self.dataModel.triggerLED;
        [self.dataList addObject:cellModel5];
    }
        
    [self.collectionView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Quick switch";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseCollectionView *)collectionView {
    if (!_collectionView) {
        MKBXQuickSwitchCellLayout *layout = [[MKBXQuickSwitchCellLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(11.f, 11.f, 0, 11.f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[MKBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = RGBCOLOR(246.f, 247.f, 251.f);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:MKBXQuickSwitchCell.class forCellWithReuseIdentifier:@"MKBXQuickSwitchCellIdenty"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXPQuickSwitchModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPQuickSwitchModel alloc] init];
    }
    return _dataModel;
}

@end
