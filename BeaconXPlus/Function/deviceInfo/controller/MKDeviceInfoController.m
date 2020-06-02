//
//  MKDeviceInfoController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDeviceInfoController.h"
#import "MKBaseTableView.h"
#import "MKIconInfoCell.h"
#import "MKDeviceInfoModel.h"
#import "MKMainCellModel.h"

static NSString *const MKDeviceInfoControllerCellIdenty = @"MKDeviceInfoControllerCellIdenty";

@interface MKDeviceInfoController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKDeviceInfoModel *infoModel;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKDeviceInfoController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKDeviceInfoController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadDatas];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadSystemInfoDatas];
}

#pragma mark - 父类方法

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification"
                                                        object:nil];
}

#pragma mark - 代理方法

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKIconInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:MKDeviceInfoControllerCellIdenty];
    if (!cell) {
        cell = [[MKIconInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKDeviceInfoControllerCellIdenty];
    }
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
    }
    return cell;
}

#pragma mark - Private method

- (void)loadSystemInfoDatas{
    [[MKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [self.infoModel startLoadSystemInformation:^{
        [[MKHudManager share] hide];
        [weakSelf reloadDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)reloadDatas{
    if (ValidStr(self.infoModel.battery)) {
        MKMainCellModel *soc = self.dataList[0];
        soc.rightMsg = [self.infoModel.battery stringByAppendingString:@"mV"];
    }
    if (ValidStr(self.infoModel.macAddress)) {
        MKMainCellModel *mac = self.dataList[1];
        mac.rightMsg = self.infoModel.macAddress;
    }
    if (ValidStr(self.infoModel.produce)) {
        MKMainCellModel *produceModel = self.dataList[2];
        produceModel.rightMsg = self.infoModel.produce;
    }
    if (ValidStr(self.infoModel.software)) {
        MKMainCellModel *softwareModel = self.dataList[3];
        softwareModel.rightMsg = self.infoModel.software;
    }
    if (ValidStr(self.infoModel.firmware)) {
        MKMainCellModel *firmwareModel = self.dataList[4];
        firmwareModel.rightMsg = self.infoModel.firmware;
    }
    if (ValidStr(self.infoModel.hardware)) {
        MKMainCellModel *hardware = self.dataList[5];
        hardware.rightMsg = self.infoModel.hardware;
    }
    if (ValidStr(self.infoModel.manuDate)) {
        MKMainCellModel *manuDateModel = self.dataList[6];
        manuDateModel.rightMsg = self.infoModel.manuDate;
    }
    if (ValidStr(self.infoModel.manu)) {
        MKMainCellModel *manuModel = self.dataList[7];
        manuModel.rightMsg = self.infoModel.manu;
    }
    [self.tableView reloadData];
}

- (void)loadDatas{
    MKMainCellModel *socModel = [[MKMainCellModel alloc] init];
    socModel.leftIconName = @"device_soc";
    socModel.leftMsg = @"Battery Voltage";
    socModel.rightMsg = @"0mV";
    socModel.hiddenRightIcon = YES;
    [self.dataList addObject:socModel];
    
    MKMainCellModel *macModel = [[MKMainCellModel alloc] init];
    macModel.leftIconName = @"device_macadress";
    macModel.leftMsg = @"Mac Address";
    macModel.rightMsg = @"CE:12:A4:32:1B:2E";
    macModel.hiddenRightIcon = YES;
    [self.dataList addObject:macModel];
    
    MKMainCellModel *produceModel = [[MKMainCellModel alloc] init];
    produceModel.leftIconName = @"device_productmodel";
    produceModel.leftMsg = @"Product Model";
    produceModel.rightMsg = @"HHHH";
    produceModel.hiddenRightIcon = YES;
    [self.dataList addObject:produceModel];
    
    MKMainCellModel *softwareModel = [[MKMainCellModel alloc] init];
    softwareModel.leftIconName = @"device_software";
    softwareModel.leftMsg = @"Software Version";
    softwareModel.rightMsg = @"V1.0.0";
    softwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:softwareModel];
    
    MKMainCellModel *firmwareModel = [[MKMainCellModel alloc] init];
    firmwareModel.leftIconName = @"device_firmware";
    firmwareModel.leftMsg = @"Firmware Version";
    firmwareModel.rightMsg = @"V1.0.0";
    firmwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:firmwareModel];
    
    MKMainCellModel *hardwareModel = [[MKMainCellModel alloc] init];
    hardwareModel.leftIconName = @"device_hardware";
    hardwareModel.leftMsg = @"Hardware Version";
    hardwareModel.rightMsg = @"V1.0.0";
    hardwareModel.hiddenRightIcon = YES;
    [self.dataList addObject:hardwareModel];
    
    MKMainCellModel *manuDateModel = [[MKMainCellModel alloc] init];
    manuDateModel.leftIconName = @"device_runningtime";
    manuDateModel.leftMsg = @"Manufacture Date";
    manuDateModel.rightMsg = @"1d2h3m15s";
    manuDateModel.hiddenRightIcon = YES;
    [self.dataList addObject:manuDateModel];
    
    MKMainCellModel *manuModel = [[MKMainCellModel alloc] init];
    manuModel.leftIconName = @"device_manufacture";
    manuModel.leftMsg = @"Manufacture";
    manuModel.rightMsg = @"LTD";
    manuModel.hiddenRightIcon = YES;
    [self.dataList addObject:manuModel];
    
    [self.tableView reloadData];
}

- (void)loadSubViews{
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"Device info";
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-49.f);
    }];
}

#pragma mark - setter & getter

- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (MKDeviceInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [MKDeviceInfoModel new];
    }
    return _infoModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
