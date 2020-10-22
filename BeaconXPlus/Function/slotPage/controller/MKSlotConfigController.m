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
#import "MKAdvContentDeviceCell.h"
#import "MKAxisAcceDataCell.h"
#import "MKAxisParametersCell.h"
#import "MKSlotTriggerCell.h"

#import "MKSlotConfigManager.h"

static CGFloat const offset_X = 15.f;
static CGFloat const headerViewHeight = 130.f;

@interface MKSlotConfigController ()<UITableViewDelegate, UITableViewDataSource ,MKBaseParamsCellDelegate, MKSlotTriggerCellDelegate, MKFrameTypeViewDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKFrameTypeView *tableHeader;

@property (nonatomic, assign)slotFrameType frameType;

@property (nonatomic, strong)NSMutableArray *dataList;

/**
 进来的时候拿的当前通道数据
 */
@property (nonatomic, strong)NSMutableDictionary *originalDic;

@property (nonatomic, strong)MKSlotConfigManager *configManager;

@property (nonatomic, assign)BOOL triggerIsOn;

@property (nonatomic, strong)MKAdvContentiBeaconCell *iBeaconCell;

@property (nonatomic, strong)MKAdvContentUIDCell *uidCell;

@property (nonatomic, strong)MKAdvContentURLCell *urlCell;

@property (nonatomic, strong)MKBaseParamsCell *baseParamsCell;

@property (nonatomic, strong)MKAdvContentDeviceCell *deviceAdvCell;

@property (nonatomic, strong)MKSlotTriggerCell *triggerCell;

@end

@implementation MKSlotConfigController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKSlotConfigController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        make.bottom.mas_equalTo(-VirtualHomeHeight);
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
    MKSlotConfigCellModel *model = self.dataList[indexPath.section];
    if ([model.cell isKindOfClass:NSClassFromString(@"MKSlotTriggerCell")] && !self.triggerIsOn) {
        return 50.f;
    }
    return model.cell.cellHeight;
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
    MKSlotConfigCellModel *model = self.dataList[indexPath.section];
    MKSlotBaseCell *cell = model.cell;
    if ([cell respondsToSelector:@selector(setDataDic:)]) {
        [cell performSelector:@selector(setDataDic:) withObject:model.dataDic];
    }
    return cell;
}

#pragma mark - MKBaseParamsCellDelegate
- (void)advertisingStatusChanged:(BOOL)isOn {
    NSMutableDictionary *baseParams = [NSMutableDictionary dictionaryWithDictionary:self.originalDic[@"baseParam"]];
    [baseParams setObject:@(isOn) forKey:@"advertisingIsOn"];
    [self.originalDic setObject:baseParams forKey:@"baseParam"];
    MKSlotConfigCellModel *baseParamModel = self.dataList[2];
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    [self.tableView reloadRow:0 inSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKSlotTriggerCellDelegate
- (void)triggerSwitchStatusChanged:(BOOL)isOn {
    self.triggerIsOn = isOn;
    NSDictionary *dic = self.originalDic[@"triggerConditions"];
    if (ValidDict(dic)) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic setObject:@(isOn) forKey:@"trigger"];
        [self.originalDic setObject:tempDic forKey:@"triggerConditions"];
    }
    MKSlotConfigCellModel *triggerModel = [self.dataList lastObject];
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    [self.tableView reloadRow:0 inSection:(self.dataList.count - 1) withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - MKFrameTypeViewDelegate
- (void)frameTypeChangedMethod:(slotFrameType)frameType {
    self.frameType = frameType;
    [self reloadTableViewData];
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
        weakSelf.originalDic = [NSMutableDictionary dictionaryWithDictionary:returnData];
        weakSelf.frameType = [weakSelf loadFrameType:returnData[@"advData"][@"frameType"]];
        [weakSelf.tableHeader updateFrameType:weakSelf.frameType];
        weakSelf.triggerIsOn = [returnData[@"triggerConditions"][@"trigger"] boolValue];
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
    [self setBaseParamsType];
    [self.tableView reloadData];
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
            return [self createNewDeviceInfoList];
            
        case slotFrameTypeThreeASensor:
            return [self createNewThreeAxisList];
        case slotFrameTypeTHSensor:
            return [self createNewTHList];
            
        case slotFrameTypeNull:
            return @[];
    }
}

/**
 生成iBeacon模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewIbeaconList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cell = self.iBeaconCell;
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    triggerModel.cell = self.triggerCell;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    baseParamModel.cell = self.baseParamsCell;
    if (self.vcModel.slotType == slotFrameTypeiBeacon && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    
    return @[advModel, baseParamModel, triggerModel];
}

/**
 生成UID模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewUIDList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cell = self.uidCell;
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    triggerModel.cell = self.triggerCell;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    baseParamModel.cell = self.baseParamsCell;
    if (self.vcModel.slotType == slotFrameTypeUID && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel, triggerModel];
}

/**
 生成url模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewUrlList{
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cell = self.urlCell;
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    triggerModel.cell = self.triggerCell;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    baseParamModel.cell = self.baseParamsCell;
    if (self.vcModel.slotType == slotFrameTypeURL && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel, triggerModel];
}

/**
 生成TLM模式下的数据源
 
 @return NSArray
 */
- (NSArray *)createNewTLMOrInfoList{
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cell = self.baseParamsCell;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    triggerModel.cell = self.triggerCell;
    
    return @[baseParamModel, triggerModel];
}

- (NSArray *)createNewDeviceInfoList {
    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    advModel.cell = self.deviceAdvCell;
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.cell = self.triggerCell;
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cell = self.baseParamsCell;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    if (self.vcModel.slotType == slotFrameTypeInfo && ValidDict(self.originalDic)) {
        advModel.dataDic = self.originalDic[@"advData"];
    }
    return @[advModel, baseParamModel, triggerModel];
}

- (NSArray *)createNewThreeAxisList {
    //    MKSlotConfigCellModel *advModel = [[MKSlotConfigCellModel alloc] init];
    //    advModel.cellType = axisAcceDataContent;
    //
    //    MKSlotConfigCellModel *paramsModel = [[MKSlotConfigCellModel alloc] init];
    //    paramsModel.cellType = axisAcceParamsContent;
    
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cell = self.baseParamsCell;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.cell = self.triggerCell;
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    
    //    if (self.vcModel.slotType == slotFrameTypeThreeASensor && ValidDict(self.originalDic)) {
    //        paramsModel.dataDic = self.originalDic[@"advData"];
    //    }
    return @[baseParamModel, triggerModel];
}

- (NSArray *)createNewTHList {
    MKSlotConfigCellModel *baseParamModel = [[MKSlotConfigCellModel alloc] init];
    baseParamModel.cell = self.baseParamsCell;
    baseParamModel.dataDic = self.originalDic[@"baseParam"];
    
    MKSlotConfigCellModel *triggerModel = [[MKSlotConfigCellModel alloc] init];
    triggerModel.cell = self.triggerCell;
    triggerModel.dataDic = self.originalDic[@"triggerConditions"];
    
    return @[baseParamModel, triggerModel];
}

- (void)setBaseParamsType {
    NSString *type = @"";
    if (self.frameType == slotFrameTypeiBeacon) {
        type = MKSlotBaseCelliBeaconType;
    }else if (self.frameType == slotFrameTypeTLM){
        type = MKSlotBaseCellTLMType;
    }else if (self.frameType == slotFrameTypeUID){
        type = MKSlotBaseCellUIDType;
    }else if (self.frameType == slotFrameTypeURL){
        type = MKSlotBaseCellURLType;
    }else if (self.frameType == slotFrameTypeInfo) {
        type = MKSlotBaseCellDeviceInfoType;
    }else if (self.frameType == slotFrameTypeThreeASensor) {
        type = MKSlotBaseCellAxisAcceDataType;
    }
    self.baseParamsCell.baseCellType = type;
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
            if (![cell isKindOfClass:NSClassFromString(@"MKAxisAcceDataCell")]) {
                //三轴传感器监听cell不需要设置
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableHeader];
        
        if (@available(iOS 11.0, *)) {
            
        }else {
            _tableView.estimatedRowHeight = 44.f;
        }
    }
    return _tableView;
}

- (MKFrameTypeView *)tableHeader{
    if (!_tableHeader) {
        _tableHeader = [[MKFrameTypeView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         kScreenWidth - 2 * offset_X,
                                                                         headerViewHeight)];
        _tableHeader.delegate = self;
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

- (NSMutableDictionary *)originalDic {
    if (!_originalDic) {
        _originalDic = [NSMutableDictionary dictionary];
    }
    return _originalDic;
}

- (MKAdvContentiBeaconCell *)iBeaconCell {
    if (!_iBeaconCell) {
        _iBeaconCell = [MKAdvContentiBeaconCell initCellWithTableView:self.tableView];
        _iBeaconCell.cellHeight = 145.f;
    }
    return _iBeaconCell;
}

- (MKAdvContentUIDCell *)uidCell {
    if (!_uidCell) {
        _uidCell = [MKAdvContentUIDCell initCellWithTableView:self.tableView];
        _uidCell.cellHeight = 120.f;
    }
    return _uidCell;
}

- (MKAdvContentURLCell *)urlCell {
    if (!_urlCell) {
        _urlCell = [MKAdvContentURLCell initCellWithTableView:self.tableView];
        _urlCell.cellHeight = 100.f;
    }
    return _urlCell;
}

- (MKBaseParamsCell *)baseParamsCell {
    if (!_baseParamsCell) {
        _baseParamsCell = [MKBaseParamsCell initCellWithTableView:self.tableView];
        _baseParamsCell.delegate = self;
        _baseParamsCell.cellHeight = 190.f;
    }
    return _baseParamsCell;
}

- (MKAdvContentDeviceCell *)deviceAdvCell {
    if (!_deviceAdvCell) {
        _deviceAdvCell = [MKAdvContentDeviceCell initCellWithTable:self.tableView];
        _deviceAdvCell.cellHeight = 100.f;
    }
    return _deviceAdvCell;
}

- (MKSlotTriggerCell *)triggerCell {
    if (!_triggerCell) {
        _triggerCell = [MKSlotTriggerCell initCellWithTableView:self.tableView];
        _triggerCell.delegate = self;
        _triggerCell.cellHeight = 280.f;
    }
    return _triggerCell;
}

@end
