//
//  MKBXPSensorConfigController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSensorConfigController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKNormalTextCell.h"

#import "MKBXPConnectManager.h"

#import "MKBXPAccelerationController.h"
#import "MKBXPHTConfigController.h"
#import "MKBXPLightSensorController.h"

@interface MKBXPSensorConfigController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBXPSensorConfigController

- (void)dealloc {
    NSLog(@"MKBXPSensorConfigController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *cellModel = self.dataList[indexPath.row];
    if (ValidStr(cellModel.methodName) && [self respondsToSelector:NSSelectorFromString(cellModel.methodName)]) {
        [self performSelector:NSSelectorFromString(cellModel.methodName) withObject:nil];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - cell点击事件
- (void)pushAccelerationPage {
    MKBXPAccelerationController *vc = [[MKBXPAccelerationController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHTConfigPage {
    MKBXPHTConfigController *vc = [[MKBXPHTConfigController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushLightSensorPage {
    MKBXPLightSensorController *vc = [[MKBXPLightSensorController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    //00:无传感器,01:带LIS3DH3轴加速度计,02:带SHT3X温湿度传感器,03:同时带有LIS3DH及SHT3X传感器
    //04:光感,05三轴+光感
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //三轴传感器
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"3-axis accelerometer";
        cellModel1.methodName = @"pushAccelerationPage";
        [self.dataList addObject:cellModel1];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"]) {
        //温湿度
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"Temperature & Humidity";
        cellModel1.methodName = @"pushHTConfigPage";
        [self.dataList addObject:cellModel1];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //三轴+温湿度
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"3-axis accelerometer";
        cellModel1.methodName = @"pushAccelerationPage";
        [self.dataList addObject:cellModel1];
        
        MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
        cellModel2.showRightIcon = YES;
        cellModel2.leftMsg = @"Temperature & Humidity";
        cellModel2.methodName = @"pushHTConfigPage";
        [self.dataList addObject:cellModel2];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"04"]) {
        //光感
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"Light sensor";
        cellModel1.methodName = @"pushLightSensorPage";
        [self.dataList addObject:cellModel1];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"05"]) {
        //三轴+光感
        MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
        cellModel1.showRightIcon = YES;
        cellModel1.leftMsg = @"3-axis accelerometer";
        cellModel1.methodName = @"pushAccelerationPage";
        [self.dataList addObject:cellModel1];
        
        MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
        cellModel2.showRightIcon = YES;
        cellModel2.leftMsg = @"Light sensor";
        cellModel2.methodName = @"pushLightSensorPage";
        [self.dataList addObject:cellModel2];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Sensor configurations";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
