//
//  MKSlotController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotController.h"
#import "MKHaveRefreshTableView.h"
#import "MKOptionsCell.h"
#import "MKSlotConfigController.h"
#import "MKSlotDataTypeModel.h"

static NSString *const MKSlotControllerCellIdenty = @"MKSlotControllerCellIdenty";

@interface MKSlotController ()<UITableViewDelegate, UITableViewDataSource, MKHaveRefreshViewDelegate>

@property (nonatomic, strong)MKHaveRefreshTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 当进入到通道页面之后，再次返回才需要重新获取通道数据类型
 */
@property (nonatomic, assign)BOOL needReloadData;

@end

@implementation MKSlotController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKSlotController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.needReloadData || [MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        return;
    }
    [self getSlotDataType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    self.needReloadData = YES;
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法

- (void)leftButtonMethod{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKPopToRootViewControllerNotification" object:nil];
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
    MKOptionsCell *cell = [MKOptionsCell initCellWithTabelView:tableView];
    if (indexPath.row < self.dataList.count) {
        cell.dataModel = self.dataList[indexPath.row];
        WS(weakSelf);
        cell.configSlotDataBlock = ^(MKSlotDataTypeModel *dataModel) {
            weakSelf.needReloadData = YES;
            weakSelf.hidesBottomBarWhenPushed = YES;
            MKSlotConfigController *vc = [[MKSlotConfigController alloc] init];
            vc.vcModel = dataModel;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            weakSelf.hidesBottomBarWhenPushed = NO;
        };
    }
    return cell;
}

#pragma mark - MKHaveRefreshTableViewDelegate
/**
 *  header开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshTableView:(MKHaveRefreshTableView *)tableView headBeginRefreshing:(UIView *)headView{
    [self getSlotDataType];
}

#pragma mark - Private method

- (void)getSlotDataType{
    [[MKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [MKBXPInterface readBXPSlotDataTypeWithSucBlock:^(id returnData) {
        [[MKHudManager share] hide];
        [weakSelf.tableView stopRefresh];
        weakSelf.needReloadData = NO;
        [weakSelf parseSlotDataTypeDatas:returnData];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.tableView stopRefresh];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)parseSlotDataTypeDatas:(id)returnData{
    if (!ValidDict(returnData)) {
        return;
    }
    NSArray *list = returnData[@"result"][@"slotTypeList"];
    if (!ValidArray(list)) {
        for (MKSlotDataTypeModel *model in self.dataList) {
            model.clickEnable = NO;
        }
        return;
    }
    [self.dataList removeAllObjects];
    for (NSInteger i = 0; i < list.count; i ++) {
        NSString *type = list[i];
        MKSlotDataTypeModel *slotInfo = [[MKSlotDataTypeModel alloc] init];
        slotInfo.slotType = [self getSlotFrameType:type];
        slotInfo.clickEnable = YES;
        slotInfo.slotIndex = i;
        [self.dataList addObject:slotInfo];
    }
//    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
//        //带LIS3DH3轴加速度计
//        MKSlotDataTypeModel *lastModel = [self.dataList lastObject];
//        lastModel.slotType = slotFrameTypeThreeASensor;
//    }else if ([[MKDataManager shared].deviceType isEqualToString:@"02"]) {
//        //带SHT3X温湿度传感器
//        MKSlotDataTypeModel *lastModel = [self.dataList lastObject];
//        lastModel.slotType = slotFrameTypeTHSensor;
//    }else if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
//        //同时带有LIS3DH及SHT3X传感器
//        MKSlotDataTypeModel *lastModel = [self.dataList lastObject];
//        lastModel.slotType = slotFrameTypeThreeASensor;
//        MKSlotDataTypeModel *lastModel1 = self.dataList[4];
//        lastModel1.slotType = slotFrameTypeTHSensor;
//    }
//    /*
//     目前设备有四种类型，无传感器版本、带LIS3DH3轴加速度计版本、带SHT31温湿度传感器版本、同时带有LIS3DH及SHT30传感器版本，
//     根据新的业务需求，
//     无传感器版本:
//     带LIS3DH3轴加速度计版本:最后一个通道固定为传感器通道
//     带SHT31温湿度传感器版本:最后一个通道固定为温湿度传感器通道
//     同时带有LIS3DH及SHT30传感器版本:最后两个通道分别固定为温湿度传感器通道、传感器通道
//     */
    
    [self.tableView reloadData];
}
- (slotFrameType )getSlotFrameType:(NSString *)type{
    //@"00":UID,@"10":URL,@"20":TLM,@"40":设备信息,@"50":iBeacon,@"60":3轴加速度计,@"70":温湿度传感器,@"FF":NO DATA
    if (!ValidStr(type) || [type isEqualToString:@"ff"]) {
        return slotFrameTypeNull;
    }
    if ([type isEqualToString:@"00"]) {
        return slotFrameTypeUID;
    }
    if ([type isEqualToString:@"10"]) {
        return slotFrameTypeURL;
    }
    if ([type isEqualToString:@"20"]) {
        return slotFrameTypeTLM;
    }
    if ([type isEqualToString:@"40"]) {
        return slotFrameTypeInfo;
    }
    if ([type isEqualToString:@"50"]) {
        return slotFrameTypeiBeacon;
    }
    if ([type isEqualToString:@"60"]) {
        return slotFrameTypeThreeASensor;
    }
    if ([type isEqualToString:@"70"]) {
        return slotFrameTypeTHSensor;
    }
    return slotFrameTypeNull;
}

- (void)loadSubViews{
    self.defaultTitle = @"Options";
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
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

- (MKHaveRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKHaveRefreshTableView alloc] initWithFrame:CGRectZero sourceType:PLHaveRefreshSourceTypeHeader];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.refreshDelegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


@end
