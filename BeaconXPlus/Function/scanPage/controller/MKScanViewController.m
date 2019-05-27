//
//  MKScanViewController.m
//  BeaconXPlus
//
//  Created by aa on 2019/4/19.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanViewController.h"
#import "MKBaseTableView.h"
#import "MKScanBeaconModel.h"

#import "MKEddStoneUIDCell.h"
#import "MKEddStoneURLCell.h"
#import "MKEddStoneTLMCell.h"
#import "MKScanInfoCell.h"
#import "MKEddStoneiBeaconCell.h"
#import "MKEddystoneHTCell.h"
#import "MKEddystoneThreeASensorCell.h"

#import "MKScanSearchButton.h"
#import "MKBXPBaseBeacon+MKAdd.h"
#import "MKConnectDeviceProgressView.h"

#import "MKAboutController.h"
#import "MKScanSearchView.h"

#import "MKMainTabBarController.h"


static NSString *const MKLeftButtonAnimationKey = @"MKLeftButtonAnimationKey";

static CGFloat const offset_X = 15.f;
static CGFloat const searchButtonHeight = 40.f;
static CGFloat const headerViewHeight = 90.f;
static CGFloat const uidCellHeight = 70.f;
static CGFloat const urlCellHeight = 55.f;
static CGFloat const tlmCellHeight = 110.f;
static CGFloat const htCellHeight = 90.f;
static CGFloat const threeSensorCellHeight = 110.f;

@interface MKSortModel : NSObject

/**
 过滤条件，mac或者名字包含的搜索条件
 */
@property (nonatomic, copy)NSString *searchName;

/**
 过滤设备的rssi
 */
@property (nonatomic, assign)NSInteger sortRssi;

/**
 是否打开了搜索条件
 */
@property (nonatomic, assign)BOOL isOpen;

@end

@implementation MKSortModel

@end

@interface MKScanViewController ()<UITableViewDelegate, UITableViewDataSource, MKBXPScanDelegate>

@property (nonatomic, strong)MKScanSearchButton *searchButton;

@property (nonatomic, strong)UIImageView *circleIcon;

@property (nonatomic, strong)MKBaseTableView *tableView;

/**
 数据源
 */
@property (nonatomic, strong)NSMutableArray *dataList;


@property (nonatomic, strong)MKSortModel *sortModel;

@property (nonatomic, strong)UITextField *passwordField;

/**
 当从配置页面返回的时候，需要扫描
 */
@property (nonatomic, assign)BOOL needScan;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/**
 缓存用户输入的密码。只有连接成功设备之后才会缓存
 */
@property (nonatomic, copy)NSString *localPassword;

@end

@implementation MKScanViewController

#pragma mark - life circle
- (void)dealloc{
    NSLog(@"MKScanViewController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needScan && [MKBXPCentralManager shared].managerState == MKBXPCentralManagerStateEnable) {
        self.needScan = NO;
        self.leftButton.selected = NO;
        [self leftButtonMethod];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCentralScanDelegate)
                                                 name:@"MKCentralDeallocNotification"
                                               object:nil];
    [self setCentralScanDelegate];
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:0.5];
    // Do any additional setup after loading the view.
}

#pragma mark - 父类方法

- (void)leftButtonMethod{
    if ([MKBXPCentralManager shared].managerState != MKBXPCentralManagerStateEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.leftButton.selected = !self.leftButton.selected;
    if (!self.leftButton.isSelected) {
        //停止扫描
        [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
        [[MKBXPCentralManager shared] stopScanPeripheral];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self resetDevicesNum];
    [self addAnimationForLeftButton];
    [self scanTimerRun];
}

- (void)rightButtonMethod{
    MKAboutController *vc = [[MKAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 代理方法

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    @synchronized(self.dataList) {
        return self.dataList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @synchronized(self.dataList){
        if (section < self.dataList.count) {
            MKScanBeaconModel *model = self.dataList[section];
            @synchronized(model.dataArray){
                return (model.dataArray.count + 1);
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //第一个row固定为设备信息帧
        @synchronized(self.dataList){
            MKScanInfoCell *cell = [MKScanInfoCell initCellWithTableView:tableView];
            cell.beacon = self.dataList[indexPath.section];
            WS(weakSelf);
            cell.connectPeripheralBlock = ^(NSInteger section) {
                [weakSelf connectPeripheral:section];
            };
            return cell;
        };
    }
    MKScanBaseCell *cell = [self loadCellDataWithIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return headerViewHeight;
    }
    if (indexPath.section < self.dataList.count) {
        @synchronized(self.dataList){
            MKScanBeaconModel *model = self.dataList[indexPath.section];
            @synchronized(model.dataArray){
                MKBXPBaseBeacon *beacon = model.dataArray[indexPath.row - 1];
                switch (beacon.frameType) {
                    case MKBXPUIDFrameType:
                        return uidCellHeight;
                    case MKBXPURLFrameType:
                        return urlCellHeight;
                    case MKBXPTLMFrameType:
                        return tlmCellHeight;
                    case MKBXPBeaconFrameType:
                        return [self getiBeaconCellHeightWithBeacon:beacon];
                    case MKBXPTHSensorFrameType:
                        return htCellHeight;
                    case MKBXPThreeASensorFrameType:
                        return threeSensorCellHeight;
                    default:
                        break;
                }
            }
        }
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 5.f)];
    return view;
}

#pragma mark - MKBXPScanDelegate
- (void)bxp_didReceiveBeacon:(NSArray <MKBXPBaseBeacon *>*)beaconList {
    for (MKBXPBaseBeacon *beacon in beaconList) {
        NSLog(@"+++++++++++++>%@",beacon.peripheral.identifier.UUIDString);
        [self updateDataWithBeacon:beacon];
    }
}

- (void)bxp_centralManagerStartScan {
    
}
- (void)bxp_centralManagerStopScan {
    //如果是左上角在动画，则停止动画
    if (self.leftButton.isSelected) {
        [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
        [self.leftButton setSelected:NO];
    }
}

#pragma mark - notice method
- (void)setCentralScanDelegate{
    [MKBXPCentralManager shared].scanDelegate = self;
}

#pragma mark - Private method

- (void)showCentralStatus{
    if (kSystemVersion >= 11.0 && [MKBXPCentralManager shared].managerState != MKBXPCentralManagerStateEnable) {
        //对于iOS11以上的系统，打开app的时候，如果蓝牙未打开，弹窗提示，后面系统蓝牙状态再发生改变就不需要弹窗了
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [kAppRootController presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self leftButtonMethod];
}

#pragma mark - 扫描部分
/**
 搜索设备
 */
- (void)serachButtonPressed{
    MKScanSearchView *searchView = [[MKScanSearchView alloc] init];
    WS(weakSelf);
    searchView.scanSearchViewDismisBlock = ^(BOOL update, NSString *text, CGFloat rssi) {
        if (!update) {
            return ;
        }
        weakSelf.sortModel.sortRssi = (NSInteger)rssi;
        weakSelf.sortModel.searchName = text;
        weakSelf.sortModel.isOpen = YES;
        weakSelf.searchButton.searchConditions = (ValidStr(weakSelf.sortModel.searchName) ?
                                                  [@[weakSelf.sortModel.searchName,[NSString stringWithFormat:@"%@dBm",[NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi]]] mutableCopy] :
                                                  [@[[NSString stringWithFormat:@"%@dBm",[NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi]]] mutableCopy]);
        weakSelf.leftButton.selected = NO;
        [weakSelf leftButtonMethod];
    };
    [searchView showWithText:(self.sortModel.isOpen ? self.sortModel.searchName : @"")
                   rssiValue:(self.sortModel.isOpen ? [NSString stringWithFormat:@"%ld",(long)weakSelf.sortModel.sortRssi] : @"")];
}

- (void)updateDataWithBeacon:(MKBXPBaseBeacon *)beacon{
    if (!beacon || beacon.frameType == MKBXPUnknownFrameType) {
        return;
    }
    if (self.sortModel.isOpen) {
        if (!ValidStr(self.sortModel.searchName)) {
            //打开了过滤，但是只过滤rssi
            [self filterBeaconWithRssi:beacon];
            return;
        }
        //如果打开了过滤，先看是否需要过滤设备名字和mac地址
        //如果是设备信息帧,判断mac和名字是否符合要求
        [self filterBeaconWithSearchName:beacon];
        return;
    }
    [self processBeacon:beacon];
}

/**
 通过rssi过滤设备
 */
- (void)filterBeaconWithRssi:(MKBXPBaseBeacon *)beacon{
    if ([beacon.rssi integerValue] < self.sortModel.sortRssi) {
        return;
    }
    [self processBeacon:beacon];
}

/**
 通过设备名称和mac地址过滤设备，这个时候肯定开启了rssi
 
 @param beacon 设备
 */
- (void)filterBeaconWithSearchName:(MKBXPBaseBeacon *)beacon{
    if ([beacon.rssi integerValue] < self.sortModel.sortRssi) {
        return;
    }
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //如果是设备信息帧
        MKBXPDeviceInfoBeacon *tempBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        if ([tempBeacon.deviceName containsString:self.sortModel.searchName] || [tempBeacon.macAddress containsString:self.sortModel.searchName]) {
            //如果mac地址和设备名称包含搜索条件，则加入
            [self processBeacon:beacon];
        }
        return;
    }
    //如果不是设备信息帧，则判断对应的有没有设备信息帧在当前数据源，如果没有直接舍弃，如果存在，则加入
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    @synchronized(self.dataList){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
        NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
        BOOL contain = ValidArray(array);
        if (!contain) {
            return;
        }
        MKScanBeaconModel *exsitModel = array[0];
        [self beaconExistDataSource:exsitModel beacon:beacon];
    }
}

- (void)processBeacon:(MKBXPBaseBeacon *)beacon{
    //查看数据源中是否已经存在相关设备
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    @synchronized(self.dataList){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
        NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
        BOOL contain = ValidArray(array);
        if (contain) {
            //如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKScanBeaconModel的dataArray里面去
            MKScanBeaconModel *exsitModel = array[0];
            [self beaconExistDataSource:exsitModel beacon:beacon];
            return;
        }
        //不存在，则加入
        [self beaconNoExistDataSource:beacon];
    }
}

/**
 将扫描到的设备加入到数据源
 
 @param beacon 扫描到的设备
 */
- (void)beaconNoExistDataSource:(MKBXPBaseBeacon *)beacon{
    MKScanBeaconModel *newModel = [[MKScanBeaconModel alloc] init];
    [self.dataList addObject:newModel];
    newModel.index = self.dataList.count - 1;
    newModel.identifier = beacon.peripheral.identifier.UUIDString;
    newModel.rssi = beacon.rssi;
    newModel.deviceName = (ValidStr(beacon.deviceName) ? beacon.deviceName : @"");
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //如果是设备信息帧
        newModel.infoBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:(self.dataList.count - 1)];
        [UIView performWithoutAnimation:^{
            [self.tableView insertSections:set withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else{
        //如果是URL、TLM、UID、iBeacon中的一种，直接加入到newModel中的数据帧数组里面
        [newModel.dataArray addObject:beacon];
        beacon.index = 0;
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:(self.dataList.count - 1)];
        [UIView performWithoutAnimation:^{
            [self.tableView insertSections:set withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    //刷新顶部设备数量
    [self resetDevicesNum];
}

/**
 如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKScanBeaconModel的dataArray里面去
 
 @param exsitModel 位于哪个MKScanBeaconModel下面
 @param beacon  新扫描到的数据帧
 */
- (void)beaconExistDataSource:(MKScanBeaconModel *)exsitModel beacon:(MKBXPBaseBeacon *)beacon{
    if (ValidStr(beacon.deviceName)) {
        exsitModel.deviceName = beacon.deviceName;
    }
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //设备信息帧
        exsitModel.infoBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:exsitModel.index];
        [UIView performWithoutAnimation:^{
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return;
    }
    //如果是URL、TLM、UID、iBeacon中的一种，
    //如果eddStone帧数组里面已经包含该类型数据，则判断是否是TLM，如果是TLM直接替换数组中的数据，如果不是，则判断广播内容是否一样，如果一样，则不处理，如果不一样，直接加入到帧数组
    for (MKBXPBaseBeacon *model in exsitModel.dataArray) {
        if ([model.advertiseData isEqualToData:beacon.advertiseData]) {
            //如果广播内容一样，直接舍弃数据
            return;
        }
        if (model.frameType == beacon.frameType && (beacon.frameType == MKBXPTLMFrameType || beacon.frameType == MKBXPTHSensorFrameType || beacon.frameType == MKBXPThreeASensorFrameType)) {
            //TLM信息帧需要替换
            beacon.index = model.index;
            [exsitModel.dataArray replaceObjectAtIndex:model.index withObject:beacon];
            NSIndexPath *path = [NSIndexPath indexPathForRow:beacon.index  inSection:exsitModel.index];
            [UIView performWithoutAnimation:^{
                [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            }];
            return;
        }
    }
    //如果eddStone帧数组里面不包含该数据，直接添加
    [exsitModel.dataArray addObject:beacon];
    beacon.index = exsitModel.dataArray.count - 1;
    NSArray *tempArray = [NSArray arrayWithArray:exsitModel.dataArray];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(MKBXPBaseBeacon *p1, MKBXPBaseBeacon *p2){
        if (p1.frameType > p2.frameType) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [exsitModel.dataArray removeAllObjects];
    for (NSInteger i = 0; i < sortedArray.count; i ++) {
        MKBXPBaseBeacon *tempModel = sortedArray[i];
        tempModel.index = i;
        [exsitModel.dataArray addObject:tempModel];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:exsitModel.index];
    [UIView performWithoutAnimation:^{
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (MKScanBaseCell *)loadCellDataWithIndexPath:(NSIndexPath *)indexPath{
    @synchronized(self.dataList){
        if (!indexPath || indexPath.section >= self.dataList.count) {
            return nil;
        }
        MKScanBeaconModel *model = self.dataList[indexPath.section];
        @synchronized(model.dataArray){
            MKBXPBaseBeacon *beacon = model.dataArray[indexPath.row - 1];
            MKScanBaseCell *cell;
            if (beacon.frameType == MKBXPUIDFrameType) {
                //UID
                cell = [MKEddStoneUIDCell initCellWithTableView:self.tableView];
            }else if (beacon.frameType == MKBXPURLFrameType){
                //URL
                cell = [MKEddStoneURLCell initCellWithTableView:self.tableView];
            }else if (beacon.frameType == MKBXPTLMFrameType){
                //TLM
                cell = [MKEddStoneTLMCell initCellWithTableView:self.tableView];
            }else if (beacon.frameType == MKBXPBeaconFrameType){
                cell = [MKEddStoneiBeaconCell initCellWithTableView:self.tableView];
            }else if (beacon.frameType == MKBXPTHSensorFrameType) {
                cell = [MKEddystoneHTCell initCellWithTable:self.tableView];
            }else if (beacon.frameType == MKBXPThreeASensorFrameType) {
                cell = [MKEddystoneThreeASensorCell initCellWithTable:self.tableView];
            }
            if ([cell respondsToSelector:@selector(setBeacon:)]) {
                [cell performSelector:@selector(setBeacon:) withObject:beacon];
            }
            return cell;
        }
    }
}

- (CGFloat )getiBeaconCellHeightWithBeacon:(MKBXPBaseBeacon *)beacon{
    MKBXPiBeacon *iBeaconModel = (MKBXPiBeacon *)beacon;
    return [MKEddStoneiBeaconCell getCellHeightWithUUID:iBeaconModel.uuid];
}

#pragma mark - 连接设备

- (void)connectPeripheral:(NSInteger )section{
    if (section >= self.dataList.count) {
        return;
    }
    MKScanBeaconModel *model = self.dataList[section];
    if (!model) {
        return;
    }
    CBPeripheral *peripheral;
    if (model.infoBeacon) {
        peripheral = model.infoBeacon.peripheral;
    }else if (ValidArray(model.dataArray)){
        MKBXPBaseBeacon *beacon = model.dataArray[0];
        peripheral = beacon.peripheral;
    }
    //停止扫描
    [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
    [[MKBXPCentralManager shared] stopScanPeripheral];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    WS(weakSelf);
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [[MKBXPCentralManager shared] readLockStateWithPeripheral:peripheral sucBlock:^(NSString *lockState) {
        [[MKHudManager share] hide];
        if ([lockState isEqualToString:@"00"]) {
            //密码登录
            [weakSelf showPasswordAlert:peripheral];
            return ;
        }
        if ([lockState isEqualToString:@"02"]) {
            //免密码登录
            [weakSelf connectDeviceWithoutPassword:peripheral];
            return;
        }
    } failedBlock:^(NSError *error) {
        [MKDataManager shared].password = @"";
        [[MKHudManager share] hide];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        weakSelf.leftButton.selected = NO;
        [weakSelf leftButtonMethod];
    }];
}

- (void)connectDeviceWithoutPassword:(CBPeripheral *)peripheral{
    MKConnectDeviceProgressView *progressView = [[MKConnectDeviceProgressView alloc] init];
    [progressView showConnectAlertViewWithTitle:@"Connecting..."];
    WS(weakSelf);
    [[MKBXPCentralManager shared] connectPeripheral:peripheral progressBlock:^(float progress) {
        [progressView setProgress:(progress * 0.01)];
    } sucBlock:^(CBPeripheral *peripheral) {
        [progressView dismiss];
        [weakSelf readDeviceType:peripheral];
        weakSelf.needScan = YES;
    } failedBlock:^(NSError *error) {
        [MKDataManager shared].password = @"";
        [progressView dismiss];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        weakSelf.leftButton.selected = NO;
        [weakSelf leftButtonMethod];
    }];
}

- (void)connectDeviceWithPassword:(CBPeripheral *)peripheral{
    NSString *password = self.passwordField.text;
    if (!ValidStr(password) || password.length > 16) {
        [self.view showCentralToast:@"Password error"];
        return;
    }
    MKConnectDeviceProgressView *progressView = [[MKConnectDeviceProgressView alloc] init];
    [progressView showConnectAlertViewWithTitle:@"Connecting..."];
    WS(weakSelf);
    [[MKBXPCentralManager shared] connectPeripheral:peripheral password:password progressBlock:^(float progress) {
        [progressView setProgress:(progress * 0.01)];
    } sucBlock:^(CBPeripheral *peripheral) {
        [MKDataManager shared].password = password;
        weakSelf.localPassword = password;
        [progressView dismiss];
        [weakSelf readDeviceType:peripheral];
        weakSelf.needScan = YES;
    } failedBlock:^(NSError *error) {
        [MKDataManager shared].password = @"";
        [progressView dismiss];
        [weakSelf.view showCentralToast:error.userInfo[@"errorInfo"]];
        weakSelf.leftButton.selected = NO;
        [weakSelf leftButtonMethod];
    }];
}

- (void)readDeviceType:(CBPeripheral *)peripheral {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface readBXPDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        MKMainTabBarController *vc = [[MKMainTabBarController alloc] init];
        NSDictionary *dic = @{
                              peripheralIdenty:peripheral,
                              passwordIdenty : SafeStr(self.localPassword)
                              };
        vc.params = dic;
        [self.navigationController pushViewController:vc animated:YES];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        self.leftButton.selected = NO;
        [self leftButtonMethod];
        [self showDeviceTypeErrorAlert];
    }];
}

- (void)showDeviceTypeErrorAlert {
    NSString *msg = @"Oops! Something went wrong. Please check the device version or contact MOKO.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:moreAction];
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}

- (void)showPasswordAlert:(CBPeripheral *)peripheral{
    NSString *msg = @"Please enter connection password.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter password"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        weakSelf.passwordField = nil;
        weakSelf.passwordField = textField;
        if (ValidStr(weakSelf.localPassword)) {
            textField.text = weakSelf.localPassword;
        }
        weakSelf.passwordField.placeholder = @"16 characters";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.leftButton.selected = NO;
        [weakSelf leftButtonMethod];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf connectDeviceWithPassword:peripheral];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}
/**
 监听输入的密码
 */
- (void)passwordInput{
    NSString *tempInputString = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 16 ? [tempInputString substringToIndex:16] : tempInputString);
}

- (void)resetDevicesNum{
    [self.titleLabel setText:[NSString stringWithFormat:@"Devices(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
}

- (void)addAnimationForLeftButton{
    [self.circleIcon.layer removeAnimationForKey:MKLeftButtonAnimationKey];
    [self.circleIcon.layer addAnimation:[self animation] forKey:MKLeftButtonAnimationKey];
}

- (CABasicAnimation *)animation{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = 2.f;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

#pragma mark - 扫描监听
- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKBXPCentralManager shared] startScanPeripheral];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        [[MKBXPCentralManager shared] stopScanPeripheral];
    });
    dispatch_resume(self.scanTimer);
    
}


- (void)loadSubViews{
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton addSubview:self.circleIcon];
    [self.circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self resetDevicesNum];
    [self.rightButton setImage:LOADIMAGE(@"scanRightAboutIcon", @"png") forState:UIControlStateNormal];
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  kScreenWidth - 2 * offset_X,
                                                                  searchButtonHeight + 2 * offset_X)];
    [headerView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(offset_X);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(searchButtonHeight + 2 * offset_X);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(headerView.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - setter & getter

- (MKScanSearchButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[MKScanSearchButton alloc] init];
        [_searchButton setBackgroundColor:COLOR_WHITE_MACROS];
        [_searchButton.layer setMasksToBounds:YES];
        [_searchButton.layer setCornerRadius:4.f];
        _searchButton.searchConditions = [@[] mutableCopy];
        WS(weakSelf);
        _searchButton.clearSearchConditionsBlock = ^{
            weakSelf.sortModel.isOpen = NO;
            weakSelf.sortModel.searchName = @"";
            weakSelf.sortModel.sortRssi = -127;
            weakSelf.leftButton.selected = NO;
            [weakSelf leftButtonMethod];
        };
        _searchButton.searchButtonPressedBlock = ^{
            [weakSelf serachButtonPressed];
        };
    }
    return _searchButton;
}

- (UIImageView *)circleIcon{
    if (!_circleIcon) {
        _circleIcon = [[UIImageView alloc] init];
        _circleIcon.image = LOADIMAGE(@"scanRefresh", @"png");
    }
    return _circleIcon;
}

- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKSortModel *)sortModel{
    if (!_sortModel) {
        _sortModel = [[MKSortModel alloc] init];
    }
    return _sortModel;
}

@end
