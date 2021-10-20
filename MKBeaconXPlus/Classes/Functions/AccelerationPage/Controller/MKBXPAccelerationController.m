//
//  MKBXPAccelerationController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPAccelerationController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXPCentralManager.h"

#import "MKBXPAccelerationModel.h"

#import "MKBXPAccelerationHeaderView.h"
#import "MKBXPAccelerationParamsCell.h"

@interface MKBXPAccelerationController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXPAccelerationHeaderViewDelegate,
MKBXPAccelerationParamsCellDelegate>

@property (nonatomic, strong)MKBXPAccelerationHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXPAccelerationModel *dataModel;

@end

@implementation MKBXPAccelerationController

- (void)dealloc {
    NSLog(@"MKBXPAccelerationController销毁");
    [[MKBXPCentralManager shared] notifyThreeAxisAcceleration:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxp_receiveThreeAxisAccelerometerDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXPAccelerationParamsCell *cell = [MKBXPAccelerationParamsCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXPAccelerationHeaderViewDelegate
- (void)bxp_updateThreeAxisNotifyStatus:(BOOL)notify {
    [[MKBXPCentralManager shared] notifyThreeAxisAcceleration:notify];
}

#pragma mark - MKBXPAccelerationParamsCellDelegate
/// 用户改变了scale.
/// @param scale 0:±2g,1:±4g,2:±8g,3:±16g
- (void)bxp_accelerationParamsScaleChanged:(NSInteger)scale {
    self.dataModel.scale = scale;
    MKBXPAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.scale = scale;
}

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxp_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate {
    self.dataModel.samplingRate = samplingRate;
    MKBXPAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.samplingRate = samplingRate;
}

/// 用户改变了sensitivityValue
/// @param sensitivityValue sensitivityValue
- (void)bxp_accelerationParamsSensitivityValueChanged:(NSInteger)sensitivityValue {
    self.dataModel.sensitivityValue = sensitivityValue;
    MKBXPAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.sensitivityValue = sensitivityValue;
}

#pragma mark - 通知
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSArray *tempList = dic[@"axisData"];
    if (!ValidArray(tempList)) {
        return;
    }
    NSDictionary *axisData = [tempList lastObject];
    [self.headerView updateDataWithXData:axisData[@"x-Data"] yData:axisData[@"y-Data"] zData:axisData[@"z-Data"]];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    MKBXPAccelerationParamsCellModel *cellModel = [[MKBXPAccelerationParamsCellModel alloc] init];
    cellModel.scale = self.dataModel.scale;
    cellModel.samplingRate = self.dataModel.samplingRate;
    cellModel.sensitivityValue = self.dataModel.sensitivityValue;
    [self.dataList addObject:cellModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-axis accelerometer";
    [self.rightButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPAccelerationController", @"bxp_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (MKBXPAccelerationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXPAccelerationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 120.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXPAccelerationModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPAccelerationModel alloc] init];
    }
    return _dataModel;
}

@end
