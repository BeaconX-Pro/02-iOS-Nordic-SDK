//
//  MKBXDeviceInfoController.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXDeviceInfoController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

@interface MKBXDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBXDeviceInfoController

- (void)dealloc {
    NSLog(@"MKBXDeviceInfoController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReadDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadTableViewDatas];
}

#pragma mark - super method
- (void)leftButtonMethod {
    if (self.leftButtonActionBlock) {
        self.leftButtonActionBlock();
    }
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
    if (!self.dataModel || ![self.dataModel conformsToProtocol:@protocol(MKBXDeviceInfoDataProtocol)]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^(NSDictionary * _Nonnull params) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadDatasFromDevice:params];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)loadDatasFromDevice:(NSDictionary *)params {
    if (!ValidDict(params)) {
        return;
    }
    MKNormalTextCellModel *batteryModel = self.dataList[0];
    batteryModel.rightMsg = [SafeStr(params[mk_bx_deviceInfo_batteryKey]) stringByAppendingString:@"mV"];
    
    MKNormalTextCellModel *macModel = self.dataList[1];
    macModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_macAddressKey]);
    
    MKNormalTextCellModel *productModel = self.dataList[2];
    productModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_produceKey]);
    
    MKNormalTextCellModel *softwareModel = self.dataList[3];
    softwareModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_softwareKey]);
    
    MKNormalTextCellModel *firmwareModel = self.dataList[4];
    firmwareModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_firmwareKey]);
    
    MKNormalTextCellModel *hardwareModel = self.dataList[5];
    hardwareModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_hardwareKey]);
    
    MKNormalTextCellModel *manuDateModel = self.dataList[6];
    manuDateModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_manuDateKey]);
    
    MKNormalTextCellModel *manufactureModel = self.dataList[7];
    manufactureModel.rightMsg = SafeStr(params[mk_bx_deviceInfo_manuKey]);
    
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
    manufactureModel.leftMsg = @"Manufacturer";
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

@end
