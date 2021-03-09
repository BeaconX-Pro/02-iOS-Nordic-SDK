//
//  MKBXPDeviceInfoController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKBXPDeviceInfoModel.h"

@interface MKBXPDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXPDeviceInfoModel *dataModel;

@end

@implementation MKBXPDeviceInfoController

- (void)dealloc {
    NSLog(@"MKBXPDeviceInfoController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableViewDatas];
    [self startReadDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCellModel *cellModel = self.dataList[indexPath.row];
    return [cellModel cellHeightWithContentWidth:kViewWidth];
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

#pragma mark - interface
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    WS(weakSelf);
    [self.dataModel readWithSucBlock:^{
        [[MKHudManager share] hide];
        [weakSelf loadDatasFromDevice];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadDatasFromDevice {
    MKNormalTextCellModel *batteryModel = self.dataList[0];
    batteryModel.rightMsg = [self.dataModel.battery stringByAppendingString:@"mV"];
    
    MKNormalTextCellModel *macModel = self.dataList[1];
    macModel.rightMsg = self.dataModel.macAddress;
    
    MKNormalTextCellModel *productModel = self.dataList[2];
    productModel.rightMsg = self.dataModel.produce;
    
    MKNormalTextCellModel *softwareModel = self.dataList[3];
    softwareModel.rightMsg = self.dataModel.software;
    
    MKNormalTextCellModel *firmwareModel = self.dataList[4];
    firmwareModel.rightMsg = self.dataModel.firmware;
    
    MKNormalTextCellModel *hardwareModel = self.dataList[5];
    hardwareModel.rightMsg = self.dataModel.hardware;
    
    MKNormalTextCellModel *manuDateModel = self.dataList[6];
    manuDateModel.rightMsg = self.dataModel.manuDate;
    
    MKNormalTextCellModel *manufactureModel = self.dataList[7];
    manufactureModel.rightMsg = self.dataModel.manu;
    
    [self.tableView reloadData];
}

#pragma mark - loadSectionDatas
- (void)loadTableViewDatas {
    MKNormalTextCellModel *batteryModel = [[MKNormalTextCellModel alloc] init];
    batteryModel.leftMsg = @"Battery voltage";
    [self.dataList addObject:batteryModel];
    
    MKNormalTextCellModel *macModel = [[MKNormalTextCellModel alloc] init];
    macModel.leftMsg = @"MAC address";
    [self.dataList addObject:macModel];
    
    MKNormalTextCellModel *productModel = [[MKNormalTextCellModel alloc] init];
    productModel.leftMsg = @"Product model";
    [self.dataList addObject:productModel];
    
    MKNormalTextCellModel *softwareModel = [[MKNormalTextCellModel alloc] init];
    softwareModel.leftMsg = @"Software version";
    [self.dataList addObject:softwareModel];
    
    MKNormalTextCellModel *firmwareModel = [[MKNormalTextCellModel alloc] init];
    firmwareModel.leftMsg = @"Firmware version";
    [self.dataList addObject:firmwareModel];
    
    MKNormalTextCellModel *hardwareModel = [[MKNormalTextCellModel alloc] init];
    hardwareModel.leftMsg = @"Hardware version";
    [self.dataList addObject:hardwareModel];
    
    MKNormalTextCellModel *manuDateModel = [[MKNormalTextCellModel alloc] init];
    manuDateModel.leftMsg = @"Manufacture date";
    [self.dataList addObject:manuDateModel];
    
    MKNormalTextCellModel *manufactureModel = [[MKNormalTextCellModel alloc] init];
    manufactureModel.leftMsg = @"Manufacture";
    [self.dataList addObject:manufactureModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"DEVICE";
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXPDeviceInfoModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPDeviceInfoModel alloc] init];
    }
    return _dataModel;
}

@end
