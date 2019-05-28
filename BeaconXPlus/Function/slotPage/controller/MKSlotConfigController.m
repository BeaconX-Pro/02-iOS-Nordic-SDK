//
//  MKSlotConfigController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotConfigController.h"
#import "MKSlotDataTypeModel.h"
#import "MKBaseTableView.h"
#import "MKSlotConfigCellModel.h"
#import "MKSlotBaseCell.h"
#import "MKAdvContentiBeaconCell.h"
#import "MKAdvContentUIDCell.h"
#import "MKAdvContentURLCell.h"
#import "MKAdvContentBaseCell.h"
#import "MKBaseParamsCell.h"
#import "MKFrameTypeView.h"
#import "MKSlotLineHeader.h"

#import "MKSlotConfigManager.h"

static CGFloat const offset_X = 15.f;
static CGFloat const headerViewHeight = 130.f;
static CGFloat const baseParamsCellHeight = 155.f;
static CGFloat const iBeaconAdvCellHeight = 145.f;
static CGFloat const uidAdvCellHeight = 120.f;
static CGFloat const urlAdvCellHeight = 100.f;

@interface MKSlotConfigController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKFrameTypeView *tableHeader;

@property (nonatomic, assign)slotFrameType frameType;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 进来的时候拿的当前通道数据
 */
@property (nonatomic, strong)NSDictionary *originalDic;

@property (nonatomic, strong)MKSlotConfigManager *configManager;

@end

@implementation MKSlotConfigController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKSlotConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MKPeripheralConnectStateChangedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultTitle = [self getDefaultTitle];
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(defaultTopInset + 5.f);
        make.bottom.mas_equalTo(0);
    }];
    [self reloadTableViewData];
    [self readSlotDetailData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peripheralConnectStateChanged)
                                                 name:MKPeripheralConnectStateChangedNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法

- (void)rightButtonMethod{
    [self saveDetailDatasToEddStone];
}

#pragma mark - 代理方法
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.dataList.count) {
        MKSlotConfigCellModel *model = self.dataList[indexPath.section];
        switch (model.cellType) {
            case iBeaconAdvContent:
                return iBeaconAdvCellHeight;
                
            case uidAdvContent:
                return uidAdvCellHeight;
                
            case urlAdvContent:
                return urlAdvCellHeight;
                
            case baseParam:
                return baseParamsCellHeight;
            default:
                break;
        }
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKSlotLineHeader *header = [MKSlotLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MKSlotBaseCell *cell;
    if (indexPath.section < self.dataList.count) {
        MKSlotConfigCellModel *model = self.dataList[indexPath.section];
        switch (model.cellType) {
            case iBeaconAdvContent:
                cell = [MKAdvContentiBeaconCell initCellWithTableView:tableView];
                break;
            case uidAdvContent:
                cell = [MKAdvContentUIDCell initCellWithTableView:tableView];
                break;
            case urlAdvContent:
                cell = [MKAdvContentURLCell initCellWithTableView:tableView];
                break;
            case baseParam:
                cell = [MKBaseParamsCell initCellWithTableView:tableView];
                [self setBaseCellType:cell];
                break;
            default:
                break;
        }
        if ([cell respondsToSelector:@selector(setDataDic:)]) {
            [cell performSelector:@selector(setDataDic:) withObject:model.dataDic];
        }
    }
    return cell;
}

#pragma mark - note method
- (void)peripheralConnectStateChanged{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected
        && [MKBXPCentralManager shared].managerState == MKBXPCentralManagerStateEnable) {
        [self leftButtonMethod];
    }
}

#pragma mark - Private method

/**
 从eddStone读取详情数据
 */
- (void)readSlotDetailData{
    [[MKHudManager share] showHUDWithTitle:@"Loading..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [self.configManager readSlotDetailData:self.vcModel successBlock:^(id returnData) {
        [[MKHudManager share] hide];
        weakSelf.originalDic = returnData;
        weakSelf.frameType = [weakSelf loadFrameType:returnData[@"advData"][@"frameType"]];
        weakSelf.tableHeader.index = [weakSelf getHeaderViewSelectedRow];
        [weakSelf reloadTableViewData];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

/**
 刷新table
 */
- (void)reloadTableViewData{
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[self reloadDatasWithType]];
    [self.tableView reloadData];
}

- (void)setBaseCellType:(UITableViewCell *)cell{
    if (!cell) {
        return;
    }
    NSString *type = @"";
    if (self.frameType == slotFrameTypeiBeacon) {
        type = MKSlotBaseCelliBeaconType;
    }else if (self.frameType == slotFrameTypeTLM){
        type = MKSlotBaseCellTLMType;
    }else if (self.frameType == slotFrameTypeUID){
        type = MKSlotBaseCellUIDType;
    }else if (self.frameType == slotFrameTypeURL){
        type = MKSlotBaseCellURLType;
    }
    [cell performSelector:@selector(setBaseCellType:) withObject:type];
}

/**
 根据frame type生成不同的数据
 
 @return 数据源
 */
- (NSArray *)reloadDatasWithType{
    switch (self.frameType) {
        case slotFrameTypeiBeacon:
            return [self createNewIbeaconList];
            
        case slotFrameTypeUID:
            return [self createNewUIDList];
            
        case slotFrameTypeURL:
            return [self createNewUrlList];
            
        case  slotFrameTypeTLM:
            return [self createNewTLMOrInfoList];
            
        case slotFrameTypeInfo:
            return [self createNewTLMOrInfoList];
            
        case slotFrameTypeNull:
            return @[];
        default:
            return nil;
            break;
    }
}

/**
 生成iBeacon模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewIbeaconList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cellType = iBeaconAdvContent;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeiBeacon && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    
    return @[advModel, baseParamModel];
}

/**
 生成UID模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewUIDList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cellType = uidAdvContent;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeUID && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel];
}

/**
 生成url模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewUrlList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cellType = urlAdvContent;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeURL && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel];
}

/**
 生成TLM模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewTLMOrInfoList{
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cellType = baseParam;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    return @[baseParamModel];
}

- (slotFrameType )loadFrameType:(NSString *)type{
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

/**
 根据通道号返回对应的title
 
 @return title
 */
- (NSString *)getDefaultTitle{
    if (!self.vcModel) {
        return nil;
    }
    switch (self.vcModel.slotIndex) {
        case bxpActiveSlot1:
            return @"SLOT1";
        case bxpActiveSlot2:
            return @"SLOT2";
        case bxpActiveSlot3:
            return @"SLOT3";
        case bxpActiveSlot4:
            return @"SLOT4";
        case bxpActiveSlot5:
            return @"SLOT5";
        case bxpActiveSlot6:
            return @"SLOT6";
    }
}

/**
 根据通道数据类型返回列表header选中row
 
 @return 选中row
 */
- (NSInteger)getHeaderViewSelectedRow{
    switch (self.frameType) {
            
        case slotFrameTypeTLM:
            return 0;
            
        case slotFrameTypeUID:
            return 1;
            
        case slotFrameTypeURL:
            return 2;
            
        case slotFrameTypeiBeacon:
            return 3;
            
        case slotFrameTypeInfo:
            return 4;
            
        case slotFrameTypeNull:
            return 4;
            
        default:
            break;
    }
    return 9;
}

/**
 设置详情数据
 */
- (void)saveDetailDatasToEddStone{
    BOOL canSet = YES;
    NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
    if (self.frameType != slotFrameTypeNull) {
        //NO DATA情况下不需要详情
        NSArray *cellList = [self.tableView visibleCells];
        if (!ValidArray(cellList)) {
            [self.view showCentralToast:@"Set the data failure"];
            return;
        }
        for (MKSlotBaseCell *cell in cellList) {
            NSDictionary *dic = [cell getContentData];
            if (!ValidDict(dic)) {
                canSet = NO;
                break;
            }
            NSString *code = dic[@"code"];
            if ([code isEqualToString:@"2"]) {
                canSet = NO;
                [self.view showCentralToast:dic[@"msg"]];
                break;
            }
            NSString *type = dic[@"result"][@"type"];
            if (ValidStr(type)) {
                [detailDic setObject:dic[@"result"] forKey:type];
            }
        }
    }
    
    if (!canSet) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Setting..."
                                     inView:self.view
                              isPenetration:NO];
    WS(weakSelf);
    [self.configManager setSlotDetailData:self.vcModel.slotIndex slotFrameType:self.frameType detailData:detailDic successBlock:^{
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:@"success"];
        [weakSelf performSelector:@selector(leftButtonMethod) withObject:nil afterDelay:0.5f];
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Public method
- (void)setVcModel:(MKSlotDataTypeModel *)vcModel{
    _vcModel = nil;
    _vcModel = vcModel;
    if (!_vcModel) {
        return;
    }
    self.frameType = _vcModel.slotType;
}

#pragma mark - setter & getter
-(MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = [self tableHeader];
    }
    return _tableView;
}

- (MKFrameTypeView *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[MKFrameTypeView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          kScreenWidth - 2 * offset_X,
                                                                          headerViewHeight)];
        WS(weakSelf);
        _tableHeader.frameTypeChangedBlock = ^(slotFrameType frameType) {
            weakSelf.frameType = frameType;
            [weakSelf reloadTableViewData];
        };
        _tableHeader.index = [self getHeaderViewSelectedRow];
    }
    return _tableHeader;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKSlotConfigManager *)configManager {
    if (!_configManager) {
        _configManager = [[MKSlotConfigManager alloc] init];
    }
    return _configManager;
}

@end
