//
//  MKBXPSlotConfigController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXPSlotConfigCellProtocol.h"

#import "MKBXPSlotConfigModel.h"

#import "MKBXPSlotConfigLineHeader.h"
#import "MKBXPSlotConfigFrameTypeView.h"
#import "MKBXPSlotConfigAdvParamsCell.h"
#import "MKBXPSlotConfigBeaconCell.h"
#import "MKBXPSlotConfigInfoCell.h"
#import "MKBXPSlotConfigTriggerCell.h"
#import "MKBXPSlotConfigUIDCell.h"
#import "MKBXPSlotConfigURLCell.h"

static NSString *const mk_advContentKey = @"mk_advContentKey";
static NSString *const mk_advParamsKey = @"mk_advParamsKey";
static NSString *const mk_advTriggerKey = @"mk_advTriggerKey";

static CGFloat const mk_beaconAdvContentHeight = 160.f;
static CGFloat const mk_advParamsContentHeight = 190.f;
static CGFloat const mk_triggerOpenHeight = 280.f;
static CGFloat const mk_triggerCloseHeight = 50.f;
static CGFloat const mk_uidAdvContentHeight = 120.f;
static CGFloat const mk_urlAdvContentHeight = 100.f;
static CGFloat const mk_deviceAdvContentHeight = 100.f;

@interface MKBXPSlotConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXPSlotConfigFrameTypeViewDelegate,
MKBXPSlotConfigTriggerCellDelegate>

@property (nonatomic, strong)MKBXPSlotConfigFrameTypeView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)MKBXPSlotConfigModel *dataModel;

@property (nonatomic, strong)NSMutableDictionary *cellDic;

@end

@implementation MKBXPSlotConfigController

- (void)dealloc {
    NSLog(@"MKBXPSlotConfigController销毁");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.dataModel.slotType != mk_bxp_slotFrameTypeNull) {
        //当前要配置的通道信息不是NO DATA
        NSArray *keys = self.cellDic.allKeys;
        for (NSString *key in keys) {
            id <MKBXPSlotConfigCellProtocol>protocol = self.cellDic[key];
            NSDictionary *paramDic = [protocol bxp_slotConfigCell_paramValue];
            if (ValidStr(paramDic[@"msg"])) {
                //存在参数错误
                [self.view showCentralToast:paramDic[@"msg"]];
                return;
            }
            [dataDic setObject:paramDic[@"result"][@"params"] forKey:paramDic[@"result"][@"dataType"]];
        }
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configSlotParams:dataDic sucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
        [self performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeightWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKBXPSlotConfigLineHeader *header = [MKBXPSlotConfigLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.dataModel.slotType == mk_bxp_slotFrameTypeNull) ? 0 : 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeNull) {
        return 0;
    }
    if (section == 0) {
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeBeacon
            || self.dataModel.slotType == mk_bxp_slotFrameTypeUID
            || self.dataModel.slotType == mk_bxp_slotFrameTypeURL
            || self.dataModel.slotType == mk_bxp_slotFrameTypeInfo) {
            return self.section0List.count;
        }
        return 0;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return self.section2List.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self loadCellWithIndexPath:indexPath];
}

#pragma mark - MKBXPSlotConfigFrameTypeViewDelegate
- (void)bxp_frameTypeChangedMethod:(mk_bxp_slotFrameType)frameType {
    self.dataModel.slotType = frameType;
    [self loadSectionDatas];
}

#pragma mark - MKBXPSlotConfigTriggerCellDelegate
- (void)bxp_triggerSwitchStatusChanged:(BOOL)isOn {
    [self.cellDic removeObjectForKey:mk_advTriggerKey];
    self.dataModel.triggerIsOn = isOn;
    MKBXPSlotConfigTriggerCellModel *cellModel = self.section2List[0];
    cellModel.isOn = isOn;
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - 列表刷新相关
- (void)loadSectionDatas {
    [self.section0List removeAllObjects];
    [self.section1List removeAllObjects];
    [self.section2List removeAllObjects];
    [self.cellDic removeAllObjects];
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeNull) {
        [self.tableView reloadData];
        return;
    }
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeBeacon) {
        MKBXPSlotConfigBeaconCellModel *cellModel = [[MKBXPSlotConfigBeaconCellModel alloc] init];
        if (ValidDict(self.dataModel.advSlotData) && [self.dataModel.advSlotData[@"frameType"] isEqualToString:@"50"]) {
            //当前设备广播通道是beacon
            cellModel.uuid = self.dataModel.advSlotData[@"uuid"];
            cellModel.major = self.dataModel.advSlotData[@"major"];
            cellModel.minor = self.dataModel.advSlotData[@"minor"];
        }
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeUID) {
        MKBXPSlotConfigUIDCellModel *cellModel = [[MKBXPSlotConfigUIDCellModel alloc] init];
        if (ValidDict(self.dataModel.advSlotData) && [self.dataModel.advSlotData[@"frameType"] isEqualToString:@"00"]) {
            //当前设备广播通道是UID
            cellModel.nameSpace = self.dataModel.advSlotData[@"namespaceId"];
            cellModel.instanceID = self.dataModel.advSlotData[@"instanceId"];
        }
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeURL) {
        MKBXPSlotConfigURLCellModel *cellModel = [[MKBXPSlotConfigURLCellModel alloc] init];
        if (ValidDict(self.dataModel.advSlotData) && [self.dataModel.advSlotData[@"frameType"] isEqualToString:@"10"]) {
            //当前设备广播通道是URL
            cellModel.advData = self.dataModel.advSlotData[@"advData"];
        }
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeInfo) {
        MKBXPSlotConfigInfoCellModel *cellModel = [[MKBXPSlotConfigInfoCellModel alloc] init];
        if (ValidDict(self.dataModel.advSlotData) && [self.dataModel.advSlotData[@"frameType"] isEqualToString:@"40"]) {
            //当前设备广播通道是Info
            cellModel.deviceName = self.dataModel.advSlotData[@"peripheralName"];
        }
        [self.section0List addObject:cellModel];
        return;
    }
}

- (void)loadSection1Datas {
    MKBXPSlotConfigAdvParamsCellModel *cellModel = [[MKBXPSlotConfigAdvParamsCellModel alloc] init];
    cellModel.isBeacon = (self.dataModel.slotType == mk_bxp_slotFrameTypeBeacon);
    cellModel.txPower = self.dataModel.txPower;
    cellModel.rssiValue = self.dataModel.rssi0M;
    cellModel.advInterval = self.dataModel.advInterval;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    MKBXPSlotConfigTriggerCellModel *cellModel = [[MKBXPSlotConfigTriggerCellModel alloc] init];
    cellModel.type = self.dataModel.triggerConditions[@"type"];
    cellModel.conditions = self.dataModel.triggerConditions[@"conditions"];
    if (ValidDict(self.dataModel.triggerConditions) && ValidStr(self.dataModel.triggerConditions[@"type"])) {
        cellModel.isOn = !([self.dataModel.triggerConditions[@"type"] isEqualToString:@"00"]);
    }else {
        cellModel.isOn = NO;
    }
    
    [self.section2List addObject:cellModel];
}

- (UITableViewCell *)loadCellWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeBeacon) {
            //Beacon
            MKBXPSlotConfigBeaconCell *cell = [MKBXPSlotConfigBeaconCell initCellWithTableView:self.tableView];
            cell.dataModel = self.section0List[indexPath.row];
            [self.cellDic setObject:cell forKey:mk_advContentKey];
            return cell;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeUID) {
            //UID
            MKBXPSlotConfigUIDCell *cell = [MKBXPSlotConfigUIDCell initCellWithTableView:self.tableView];
            cell.dataModel = self.section0List[indexPath.row];
            [self.cellDic setObject:cell forKey:mk_advContentKey];
            return cell;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeURL) {
            //URL
            MKBXPSlotConfigURLCell *cell = [MKBXPSlotConfigURLCell initCellWithTableView:self.tableView];
            cell.dataModel = self.section0List[indexPath.row];
            [self.cellDic setObject:cell forKey:mk_advContentKey];
            return cell;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeInfo) {
            //Info
            MKBXPSlotConfigInfoCell *cell = [MKBXPSlotConfigInfoCell initCellWithTableView:self.tableView];
            cell.dataModel = self.section0List[indexPath.row];
            [self.cellDic setObject:cell forKey:mk_advContentKey];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        //AdvParams
        MKBXPSlotConfigAdvParamsCell *cell = [MKBXPSlotConfigAdvParamsCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[indexPath.row];
        [self.cellDic setObject:cell forKey:mk_advParamsKey];
        return cell;
    }
    //触发条件
    MKBXPSlotConfigTriggerCell *cell = [MKBXPSlotConfigTriggerCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section2List[indexPath.row];
    cell.delegate = self;
    [self.cellDic setObject:cell forKey:mk_advTriggerKey];
    return cell;
}

- (CGFloat)getCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    if (self.dataModel.slotType == mk_bxp_slotFrameTypeNull) {
        //NO DATA
        return 0.f;
    }
    if (indexPath.section == 0) {
        //adv content
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeBeacon) {
            //当前是beacon通道
            return mk_beaconAdvContentHeight;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeUID) {
            //当前是UID通道
            return mk_uidAdvContentHeight;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeURL) {
            //当前通道是URL
            return mk_urlAdvContentHeight;
        }
        if (self.dataModel.slotType == mk_bxp_slotFrameTypeInfo) {
            //当前通道是设备信息
            return mk_deviceAdvContentHeight;
        }
        return 0.f;
    }
    if (indexPath.section == 1) {
        //Adv parameters
        return mk_advParamsContentHeight;
    }
    //Trigger
    MKBXPSlotConfigTriggerCellModel *cellModel = self.section2List[0];
    return (cellModel.isOn ? mk_triggerOpenHeight : mk_triggerCloseHeight);
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [@"SLOT" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)(self.slotIndex + 1)]];
    [self.rightButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPSlotConfigController", @"bxp_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
    [self.headerView updateFrameType:self.dataModel.slotType];
}

#pragma mark - getter
- (MKBXPSlotConfigFrameTypeView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXPSlotConfigFrameTypeView alloc] initWithFrame:CGRectMake(0.f, 20.f, kViewWidth , 130.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = [self tableHeader];
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

- (MKBXPSlotConfigModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPSlotConfigModel alloc] init];
        
        _dataModel.slotType = self.slotType;
        _dataModel.slotIndex = self.slotIndex;
    }
    return _dataModel;
}

- (NSMutableDictionary *)cellDic {
    if (!_cellDic) {
        _cellDic = [NSMutableDictionary dictionary];
    }
    return _cellDic;
}

- (UIView *)tableHeader {
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(5.f, 0, kViewWidth - 2 * 5.f, 150.f)];
    tableHeader.backgroundColor = RGBCOLOR(242, 242, 242);
    
    [tableHeader addSubview:self.headerView];
    
    return tableHeader;
}

@end
