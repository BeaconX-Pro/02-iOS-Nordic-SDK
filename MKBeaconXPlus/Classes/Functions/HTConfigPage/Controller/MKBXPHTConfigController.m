//
//  MKBXPHTConfigController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPHTConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPDeviceTimeDataModel.h"

#import "MKBXPHTConfigHeaderView.h"
#import "MKBXPStorageTriggerCell.h"
#import "MKBXPHTConfigNormalCell.h"
#import "MKBXPSyncBeaconTimeCell.h"

#import "MKBXPHTConfigModel.h"

#import "MKBXPExportDataController.h"

@interface MKBXPHTConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXPSyncBeaconTimeCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKBXPHTConfigHeaderView *headerView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKBXPHTConfigModel *dataModel;

@property (nonatomic, strong)MKBXPStorageTriggerCell *triggerCell;

@end

@implementation MKBXPHTConfigController

- (void)dealloc {
    NSLog(@"MKBXPHTConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[MKBXPCentralManager shared] notifyTHData:YES];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[MKBXPCentralManager shared] notifyTHData:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self startReadDatas];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHTDatas:)
                                                 name:mk_bxp_receiveHTDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSString *samplingInterval = [self.headerView getSamplingInterval];
    if (!ValidStr(samplingInterval) || [samplingInterval integerValue] < 1 || [samplingInterval integerValue] > 65535) {
        [self.view showCentralToast:@"Sampling interval error"];
        return;
    }
    NSDictionary *dic = [self.triggerCell getStorageTriggerConditions];
    MKBXPHTStorageConditionsModel *model = [[MKBXPHTStorageConditionsModel alloc] init];
    model.condition = [dic[@"triggerType"] integerValue];
    if (SafeStr(dic[@"temperature"])) {
        model.temperature = [dic[@"temperature"] floatValue] * 10;
    }
    if (SafeStr(dic[@"humidity"])) {
        model.humidity = [dic[@"humidity"] floatValue] * 10;
    }
    if (SafeStr(dic[@"time"])) {
        model.time = [dic[@"time"] integerValue];
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSamplingInterval:[samplingInterval integerValue] triggerConditions:model sucBlock:^{
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
    if (indexPath.section == 0) {
        return 190.f;
    }
    if (indexPath.section == 1) {
        return 100.f;
    }
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 0) {
        //导出页面
        MKBXPExportDataController *vc = [[MKBXPExportDataController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
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
        return self.triggerCell;
    }
    if (indexPath.section == 1) {
        MKBXPSyncBeaconTimeCell *cell = [MKBXPSyncBeaconTimeCell initCellWithTableView:tableView];
        cell.dataModel = self.section1List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKBXPHTConfigNormalCell *cell = [MKBXPHTConfigNormalCell initCellWithTableView:tableView];
    cell.dataModel = self.section2List[indexPath.row];
    return cell;
}

#pragma mark - MKBXPHTConfigHeaderViewDelegate
- (void)bxp_samplingIntervalChanged:(NSString *)interval {
    self.dataModel.samplingInterval = interval;
}

#pragma mark - MKBXPSyncBeaconTimeCellDelegate
- (void)bxp_needUpdateDate {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *dateList = [date componentsSeparatedByString:@"-"];
    
    MKBXPDeviceTimeDataModel *dateModel = [[MKBXPDeviceTimeDataModel alloc] init];
    dateModel.year = [dateList[0] integerValue];
    dateModel.month = [dateList[1] integerValue];
    dateModel.day = [dateList[2] integerValue];
    dateModel.hour = [dateList[3] integerValue];
    dateModel.minutes = [dateList[4] integerValue];
    dateModel.seconds = [dateList[5] integerValue];
    
    [MKBXPInterface bxp_configDeviceTime:dateModel sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        MKBXPSyncBeaconTimeCellModel *cellModel = self.section1List[0];
        cellModel.date = [NSString stringWithFormat:@"%@/%@/%@",dateList[2],dateList[1],dateList[0]];
        cellModel.time = [NSString stringWithFormat:@"%@:%@:%@",dateList[3],dateList[4],dateList[5]];
        [self.tableView mk_reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - notes
- (void)receiveHTDatas:(NSNotification *)note {
    NSDictionary *dataDic = note.userInfo;
    if (!ValidDict(dataDic)) {
        return;
    }
    [self.headerView updateTemperature:dataDic[@"temperature"] humidity:dataDic[@"humidity"]];
}

#pragma mark - 读取数据
- (void)startReadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载数据
- (void)loadSectionDatas {
    [self.headerView updateSamplingInterval:self.dataModel.samplingInterval];
    
    MKBXPStorageTriggerCellModel *triggerModel = [[MKBXPStorageTriggerCellModel alloc] init];
    triggerModel.triggerType = self.dataModel.triggerType;
    triggerModel.temperature = self.dataModel.temperature;
    triggerModel.humidity = self.dataModel.humidity;
    triggerModel.storageTime = self.dataModel.storageTime;
    
    [self.section0List addObject:triggerModel];
    
    MKBXPSyncBeaconTimeCellModel *timeModel = [[MKBXPSyncBeaconTimeCellModel alloc] init];
    timeModel.date = self.dataModel.date;
    timeModel.time = self.dataModel.time;
    [self.section1List addObject:timeModel];
    
    MKBXPHTConfigNormalCellModel *textModel = [[MKBXPHTConfigNormalCellModel alloc] init];
    textModel.msg = @"Export T&H data";
    [self.section2List addObject:textModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Temperature & Humidity";
    [self.rightButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPHTConfigController", @"bxp_slotSaveIcon.png") forState:UIControlStateNormal];
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

- (MKBXPHTConfigHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXPHTConfigHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 150.f)];
    }
    return _headerView;
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

- (MKBXPHTConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPHTConfigModel alloc] init];
    }
    return _dataModel;
}

- (MKBXPStorageTriggerCell *)triggerCell {
    if (!_triggerCell) {
        _triggerCell = [MKBXPStorageTriggerCell initCellWithTableView:self.tableView];
        _triggerCell.dataModel = self.section0List[0];
    }
    return _triggerCell;
}

@end
