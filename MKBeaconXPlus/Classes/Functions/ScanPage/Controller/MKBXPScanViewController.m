//
//  MKBXPScanViewController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPScanViewController.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "UIViewController+HHTransition.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKTrackerAboutController.h"
#import "MKProgressView.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXPSDK.h"

#import "MKBXPConnectManager.h"

#import "MKBXPScanInfoCell.h"
#import "MKBXPScanBeaconCell.h"
#import "MKBXPScanHTCell.h"
#import "MKBXPScanThreeASensorCell.h"
#import "MKBXPScanTLMCell.h"
#import "MKBXPScanUIDCell.h"
#import "MKBXPScanURLCell.h"
#import "MKBXPScanFilterView.h"
#import "MKBXPScanSearchButton.h"

#import "MKBXPScanBeaconModel.h"
#import "MKBXPBaseBeacon+MKBXPAdd.h"

#import "MKBXPTabBarController.h"

static CGFloat const offset_X = 15.f;
static CGFloat const searchButtonHeight = 40.f;
static CGFloat const headerViewHeight = 90.f;
static CGFloat const uidCellHeight = 85.f;
static CGFloat const urlCellHeight = 70.f;
static CGFloat const tlmCellHeight = 110.f;
static CGFloat const htCellHeight = 105.f;
static CGFloat const threeSensorCellHeight = 140.f;

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKBXPAboutPageModel : NSObject<MKTrackerAboutParamsProtocol>

/// 导航栏标题,默认@"ABOUT"
@property (nonatomic, copy)NSString *title;

/// 导航栏title颜色，默认白色
@property (nonatomic, strong)UIColor *titleColor;

/// 顶部导航栏背景颜色，默认蓝色
@property (nonatomic, strong)UIColor *titleBarColor;

/// 最上面那个关于的icon
@property (nonatomic, strong)UIImage *aboutIcon;

/// 底部背景图片
@property (nonatomic, strong)UIImage *bottomBackIcon;

/// 要显示的app名字，如果不填，则默认显示当前工程的app名称
@property (nonatomic, copy)NSString *appName;

/// app当前版本，如果不填，则默认取当前工程的版本号
@property (nonatomic, copy)NSString *appVersion;

@end

@implementation MKBXPAboutPageModel
@end

@interface MKBXPScanViewController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXPSearchButtonDelegate,
mk_bxp_centralManagerScanDelegate,
MKBXPScanInfoCellDelegate,
MKBXPTabBarControllerDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXPSearchButtonModel *buttonModel;

@property (nonatomic, strong)MKBXPScanSearchButton *searchButton;

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 当左侧按钮停止扫描的时候,currentScanStatus = NO,开始扫描的时候currentScanStatus=YES
@property (nonatomic, assign)BOOL currentScanStatus;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

@property (nonatomic, strong)UITextField *passwordField;

@end

@implementation MKBXPScanViewController

- (void)dealloc {
    NSLog(@"MKBXPScanViewController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKBXPCentralManager shared] stopScan];
    [MKBXPCentralManager removeFromCentralList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self startRefresh];
}

#pragma mark - super method
- (void)leftButtonMethod {
    if ([MKBXPCentralManager shared].centralStatus != mk_bxp_centralManagerStatusEnable) {
        [self.view showCentralToast:@"The current system of bluetooth is not available!"];
        return;
    }
    self.leftButton.selected = !self.leftButton.selected;
    self.currentScanStatus = self.leftButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.leftButton.isSelected) {
        //停止扫描
        [[MKBXPCentralManager shared] stopScan];
        if (self.scanTimer) {
            dispatch_cancel(self.scanTimer);
        }
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [self scanTimerRun];
}

- (void)rightButtonMethod {
    MKBXPAboutPageModel *model = [[MKBXPAboutPageModel alloc] init];
    model.aboutIcon = LOADICON(@"MKBeaconXPlus", @"MKBXPScanViewController", @"bxp_aboutIcon.png");
    model.appName = @"BeaconX Pro";
    MKTrackerAboutController *vc = [[MKTrackerAboutController alloc] initWithProtocol:model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.dataList.count) {
        MKBXPScanBeaconModel *model = self.dataList[section];
        return (model.dataArray.count + 1);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //第一个row固定为设备信息帧
        MKBXPScanInfoCell *cell = [MKBXPScanInfoCell initCellWithTableView:tableView];
        cell.beacon = self.dataList[indexPath.section];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [self loadCellDataWithIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return headerViewHeight;
    }
    MKBXPScanBeaconModel *model = self.dataList[indexPath.section];
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
            return 0.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    MKTableSectionLineHeaderModel *sectionData = [[MKTableSectionLineHeaderModel alloc] init];
    sectionData.contentColor = RGBCOLOR(237, 243, 250);
    headerView.headerModel = sectionData;
    return headerView;
}

#pragma mark - MKBXPSearchButtonDelegate
- (void)bxp_scanSearchButtonMethod {
    [MKBXPScanFilterView showSearchName:self.buttonModel.searchName
                             macAddress:self.buttonModel.searchMac
                                   rssi:self.buttonModel.searchRssi
                            searchBlock:^(NSString * _Nonnull searchName, NSString * _Nonnull searchMacAddress, NSInteger searchRssi) {
        self.buttonModel.searchRssi = searchRssi;
        self.buttonModel.searchName = searchName;
        self.buttonModel.searchMac = searchMacAddress;
        self.searchButton.dataModel = self.buttonModel;
        
        self.leftButton.selected = NO;
        self.currentScanStatus = NO;
        [self leftButtonMethod];
    }];
}

- (void)bxp_scanSearchButtonClearMethod {
    self.buttonModel.searchRssi = -100;
    self.buttonModel.searchMac = @"";
    self.buttonModel.searchName = @"";
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

#pragma mark - mk_bxp_centralManagerScanDelegate
- (void)mk_bxp_receiveBeacon:(NSArray <MKBXPBaseBeacon *>*)beaconList {
    for (MKBXPBaseBeacon *beacon in beaconList) {
        [self updateDataWithBeacon:beacon];
    }
}

- (void)mk_bxp_stopScan {
    //如果是左上角在动画，则停止动画
    if (self.leftButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.leftButton setSelected:NO];
    }
}

#pragma mark - MKBXPScanInfoCellDelegate
- (void)connectPeripheralWithIndex:(NSInteger)index {
    [self connectPeripheral:index];
}

#pragma mark - MKBXPTabBarControllerDelegate
- (void)mk_bxp_needResetScanDelegate:(BOOL)need {
    if (need) {
        [MKBXPCentralManager shared].delegate = self;
    }
    [self performSelector:@selector(startScanDevice) withObject:nil afterDelay:(need ? 1.f : 0.1f)];
}

#pragma mark - notice method
- (void)showCentralStatus{
    if ([MKBXPCentralManager shared].centralStatus != mk_bxp_centralManagerStatusEnable) {
        NSString *msg = @"The current system of bluetooth is not available!";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dismiss"
                                                                                 message:msg
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:moreAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self leftButtonMethod];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
}

- (void)scanTimerRun{
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKBXPCentralManager shared] startScan];
    self.scanTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    //开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC);
    //间隔时间
    uint64_t interval = 60 * NSEC_PER_SEC;
    dispatch_source_set_timer(self.scanTimer, start, interval, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.scanTimer, ^{
        @strongify(self);
        [[MKBXPCentralManager shared] stopScan];
        [self needRefreshList];
    });
    dispatch_resume(self.scanTimer);
}

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    @weakify(self);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @strongify(self);
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (self.isNeedRefresh) {
                [self.tableView reloadData];
                [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithBeacon:(MKBXPBaseBeacon *)beacon{
    if (!beacon || beacon.frameType == MKBXPUnknownFrameType) {
        return;
    }
    
    if (ValidStr(self.buttonModel.searchMac) || ValidStr(self.buttonModel.searchName)) {
        //如果打开了过滤，先看是否需要过滤设备名字和mac地址
        //如果是设备信息帧,判断mac和名字是否符合要求
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self filterBeaconWithSearchName:beacon];
        }
        return;
    }
    if (self.buttonModel.searchRssi > self.buttonModel.minSearchRssi) {
        //开启rssi过滤
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self processBeacon:beacon];
        }
        return;
    }
    [self processBeacon:beacon];
}

/**
 通过设备名称和mac地址过滤设备，这个时候肯定开启了rssi
 
 @param beacon 设备
 */
- (void)filterBeaconWithSearchName:(MKBXPBaseBeacon *)beacon{
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //如果是设备信息帧
        MKBXPDeviceInfoBeacon *tempBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        if ([[tempBeacon.deviceName uppercaseString] containsString:[self.buttonModel.searchName uppercaseString]]
            || [[[tempBeacon.macAddress stringByReplacingOccurrencesOfString:@":" withString:@""] uppercaseString] containsString:[self.buttonModel.searchMac uppercaseString]]) {
            //如果mac地址和设备名称包含搜索条件，则加入
            [self processBeacon:beacon];
        }
        return;
    }
    //如果不是设备信息帧，则判断对应的有没有设备信息帧在当前数据源，如果没有直接舍弃，如果存在，则加入
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (!contain) {
        return;
    }
    MKBXPScanBeaconModel *exsitModel = array[0];
    [self beaconExistDataSource:exsitModel beacon:beacon];
}

- (void)processBeacon:(MKBXPBaseBeacon *)beacon{
    //查看数据源中是否已经存在相关设备
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKBXPScanBeaconModel的dataArray里面去
        MKBXPScanBeaconModel *exsitModel = array[0];
        [self beaconExistDataSource:exsitModel beacon:beacon];
        return;
    }
    //不存在，则加入
    [self beaconNoExistDataSource:beacon];
}

/**
 将扫描到的设备加入到数据源
 
 @param beacon 扫描到的设备
 */
- (void)beaconNoExistDataSource:(MKBXPBaseBeacon *)beacon{
    MKBXPScanBeaconModel *newModel = [[MKBXPScanBeaconModel alloc] init];
    [self.dataList addObject:newModel];
    newModel.index = self.dataList.count - 1;
    newModel.identifier = beacon.peripheral.identifier.UUIDString;
    newModel.rssi = beacon.rssi;
    newModel.deviceName = (ValidStr(beacon.deviceName) ? beacon.deviceName : @"");
    newModel.displayTime = @"N/A";
    newModel.lastScanDate = kSystemTimeStamp;
    newModel.connectable = beacon.connectEnable;
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //如果是设备信息帧
        newModel.infoBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        [self needRefreshList];
    }else{
        //如果是URL、TLM、UID、iBeacon中的一种，直接加入到newModel中的数据帧数组里面
        [newModel.dataArray addObject:beacon];
        beacon.index = 0;
        
        if (beacon.frameType == MKBXPThreeASensorFrameType) {
            //如果是三轴的数据，并且新版本包含电压、传感器类型、Mac地址，则需要创建一个新的设备信息帧附加到当前model
            MKBXPThreeASensorBeacon *tempBeacon = (MKBXPThreeASensorBeacon *)beacon;
            if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
                MKBXPDeviceInfoBeacon *infoBeacon = [[MKBXPDeviceInfoBeacon alloc] init];
                infoBeacon.macAddress = tempBeacon.macAddress;
                infoBeacon.battery = tempBeacon.battery;
                infoBeacon.rssi0M = tempBeacon.rssi0M;
                infoBeacon.peripheral = tempBeacon.peripheral;
                newModel.infoBeacon = infoBeacon;
            }
        }else if (beacon.frameType == MKBXPTHSensorFrameType) {
            //如果是温湿度传感器的数据，并且新版本包含电压、传感器类型、Mac地址，则需要创建一个新的设备信息帧附加到当前model
            MKBXPTHSensorBeacon *tempBeacon = (MKBXPTHSensorBeacon *)beacon;
            if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
                MKBXPDeviceInfoBeacon *infoBeacon = [[MKBXPDeviceInfoBeacon alloc] init];
                infoBeacon.macAddress = tempBeacon.macAddress;
                infoBeacon.battery = tempBeacon.battery;
                infoBeacon.rssi0M = tempBeacon.rssi0M;
                infoBeacon.peripheral = tempBeacon.peripheral;
                newModel.infoBeacon = infoBeacon;
            }
        }
        
        [self needRefreshList];
    }
}

/**
 如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKBXPScanBeaconModel的dataArray里面去
 
 @param exsitModel 位于哪个MKBXPScanBeaconModel下面
 @param beacon  新扫描到的数据帧
 */
- (void)beaconExistDataSource:(MKBXPScanBeaconModel *)exsitModel beacon:(MKBXPBaseBeacon *)beacon{
    exsitModel.connectable = beacon.connectEnable;
    if (ValidStr(beacon.deviceName)) {
        exsitModel.deviceName = beacon.deviceName;
    }
    if (ValidStr(exsitModel.lastScanDate)) {
        exsitModel.displayTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)([kSystemTimeStamp integerValue] - [exsitModel.lastScanDate integerValue]) * 1000,@"ms"];
        exsitModel.lastScanDate = kSystemTimeStamp;
    }
    if (beacon.frameType == MKBXPDeviceInfoFrameType) {
        //设备信息帧
        exsitModel.infoBeacon = (MKBXPDeviceInfoBeacon *)beacon;
        [self needRefreshList];
        return;
    }
    if (beacon.frameType == MKBXPThreeASensorFrameType && !exsitModel.infoBeacon) {
        //如果是三轴的数据并且当前model没有包含设备信息帧，新版本三轴数据包含电压、传感器类型、Mac地址,则需要创建一个新的设备信息帧附加到当前model
        MKBXPThreeASensorBeacon *tempBeacon = (MKBXPThreeASensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            MKBXPDeviceInfoBeacon *infoBeacon = [[MKBXPDeviceInfoBeacon alloc] init];
            infoBeacon.macAddress = tempBeacon.macAddress;
            infoBeacon.battery = tempBeacon.battery;
            infoBeacon.rssi0M = tempBeacon.rssi0M;
            infoBeacon.peripheral = tempBeacon.peripheral;
            exsitModel.infoBeacon = infoBeacon;
        }
    }else if (beacon.frameType == MKBXPTHSensorFrameType && !exsitModel.infoBeacon) {
        //如果是温湿度的数据并且当前model没有包含设备信息帧，新版本三轴数据包含电压、传感器类型、Mac地址,则需要创建一个新的设备信息帧附加到当前model
        MKBXPTHSensorBeacon *tempBeacon = (MKBXPTHSensorBeacon *)beacon;
        if (ValidStr(tempBeacon.battery) && ValidStr(tempBeacon.macAddress)) {
            MKBXPDeviceInfoBeacon *infoBeacon = [[MKBXPDeviceInfoBeacon alloc] init];
            infoBeacon.macAddress = tempBeacon.macAddress;
            infoBeacon.battery = tempBeacon.battery;
            infoBeacon.rssi0M = tempBeacon.rssi0M;
            infoBeacon.peripheral = tempBeacon.peripheral;
            exsitModel.infoBeacon = infoBeacon;
        }
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
            [self needRefreshList];
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
    [self needRefreshList];
}

#pragma mark - 连接设备

- (void)connectPeripheral:(NSInteger )section{
    if (section >= self.dataList.count) {
        return;
    }
    MKBXPScanBeaconModel *model = self.dataList[section];
    CBPeripheral *peripheral;
    if (model.infoBeacon) {
        peripheral = model.infoBeacon.peripheral;
    }else if (ValidArray(model.dataArray)){
        MKBXPBaseBeacon *beacon = model.dataArray[0];
        peripheral = beacon.peripheral;
    }
    //停止扫描
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKBXPCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [[MKBXPCentralManager shared] readLockStateWithPeripheral:peripheral sucBlock:^(NSString *lockState) {
        [[MKHudManager share] hide];
        if ([lockState isEqualToString:@"00"]) {
            //密码登录
            [self showPasswordAlert:peripheral];
            return ;
        }
        if ([lockState isEqualToString:@"02"]) {
            //免密码登录
            [self connectDeviceWithoutPassword:peripheral];
            return;
        }
    } failedBlock:^(NSError *error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)connectDeviceWithoutPassword:(CBPeripheral *)peripheral{
    MKProgressView *progressView = [[MKProgressView alloc] initWithTitle:@"Connecting..." message:@"Make sure your phone and device are as close as possible."];
    [progressView show];
    [[MKBXPCentralManager shared] connectPeripheral:peripheral progressBlock:^(float progress) {
        [progressView setProgress:(progress * 0.01) animated:NO];
    } sucBlock:^(CBPeripheral *peripheral) {
        [progressView dismiss];
        [self readDeviceType];
    } failedBlock:^(NSError *error) {
        [progressView dismiss];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)connectDeviceWithPassword:(CBPeripheral *)peripheral{
    NSString *password = self.passwordField.text;
    if (!ValidStr(password) || password.length > 16) {
        [self.view showCentralToast:@"Password error"];
        return;
    }
    MKProgressView *progressView = [[MKProgressView alloc] initWithTitle:@"Connecting..." message:@"Make sure your phone and device are as close as possible."];
    [progressView show];
    [[MKBXPCentralManager shared] connectPeripheral:peripheral password:password progressBlock:^(float progress) {
        [progressView setProgress:(progress * 0.01) animated:NO];
    } sucBlock:^(CBPeripheral *peripheral) {
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"mk_bxp_localPasswordKey"];
        [MKBXPConnectManager shared].password = password;
        [progressView dismiss];
        [self readDeviceType];
    } failedBlock:^(NSError *error) {
        [progressView dismiss];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)readDeviceType {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_readDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [MKBXPConnectManager shared].deviceType = returnData[@"result"][@"deviceType"];
        [self readManuDate];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)readManuDate {
    //根据生产日期确认是否支持新版本固件功能，生产日期2021/01/01以后的都是新固件
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_readProductionDateWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSString *date = [returnData[@"result"][@"productionDate"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        [MKBXPConnectManager shared].newVersion = ([date integerValue] >= 20210101);
        [self performSelector:@selector(pushTabBarPage) withObject:nil afterDelay:0.3f];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)pushTabBarPage {
    MKBXPTabBarController *vc = [[MKBXPTabBarController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    [self hh_presentViewController:vc presentStyle:HHPresentStyleErected completion:^{
        @strongify(self);
        vc.delegate = self;
    }];
}

- (void)connectFailed {
    self.leftButton.selected = NO;
    self.currentScanStatus = NO;
    [self leftButtonMethod];
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
    @weakify(self);
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        @strongify(self);
        self.passwordField = nil;
        self.passwordField = textField;
        if (ValidStr([[NSUserDefaults standardUserDefaults] objectForKey:@"mk_bxp_localPasswordKey"])) {
            textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"mk_bxp_localPasswordKey"];
        }
        self.passwordField.placeholder = @"1~16 characters";
        [textField addTarget:self action:@selector(passwordInput) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self connectFailed];
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self connectDeviceWithPassword:peripheral];
    }];
    [alertController addAction:moreAction];
    
    [kAppRootController presentViewController:alertController animated:YES completion:nil];
}
/**
 监听输入的密码
 */
- (void)passwordInput{
    NSString *tempInputString = self.passwordField.text;
    if (!ValidStr(tempInputString)) {
        self.passwordField.text = @"";
        return;
    }
    self.passwordField.text = (tempInputString.length > 16 ? [tempInputString substringToIndex:16] : tempInputString);
}

#pragma mark -
- (void)startRefresh {
    self.searchButton.dataModel = self.buttonModel;
    [self runloopObserver];
    [MKBXPCentralManager shared].delegate = self;
    //此处延时3.5s，与启动页加载3.5s对应，另外第一次安装的时候有蓝牙弹窗授权，也需要延时用来防止出现获取权限的时候出现蓝牙未打开的情况。
    //新的业务需求，第一次安装app的时候，需要用户手动点击左上角开启扫描，后面每次需要自动开启扫描     20210413
    NSNumber *install = [[NSUserDefaults standardUserDefaults] objectForKey:@"mk_bxp_installedKey"];
    if (!ValidNum(install) || ![install boolValue]) {
        //第一次安装
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"mk_bxp_installedKey"];
        return;
    }
    [self performSelector:@selector(showCentralStatus) withObject:nil afterDelay:3.5f];
}

#pragma mark - cell 加载

- (MKBaseCell *)loadCellDataWithIndexPath:(NSIndexPath *)indexPath{
    MKBXPScanBeaconModel *model = self.dataList[indexPath.section];
    MKBXPBaseBeacon *beacon = model.dataArray[indexPath.row - 1];
    MKBaseCell *cell;
    if (beacon.frameType == MKBXPUIDFrameType) {
        //UID
        cell = [MKBXPScanUIDCell initCellWithTableView:self.tableView];
    }else if (beacon.frameType == MKBXPURLFrameType){
        //URL
        cell = [MKBXPScanURLCell initCellWithTableView:self.tableView];
    }else if (beacon.frameType == MKBXPTLMFrameType){
        //TLM
        cell = [MKBXPScanTLMCell initCellWithTableView:self.tableView];
    }else if (beacon.frameType == MKBXPBeaconFrameType){
        cell = [MKBXPScanBeaconCell initCellWithTableView:self.tableView];
    }else if (beacon.frameType == MKBXPTHSensorFrameType) {
        cell = [MKBXPScanHTCell initCellWithTable:self.tableView];
    }else if (beacon.frameType == MKBXPThreeASensorFrameType) {
        cell = [MKBXPScanThreeASensorCell initCellWithTable:self.tableView];
    }
    if ([cell respondsToSelector:@selector(setBeacon:)]) {
        [cell performSelector:@selector(setBeacon:) withObject:beacon];
    }
    return cell;
}

- (CGFloat )getiBeaconCellHeightWithBeacon:(MKBXPBaseBeacon *)beacon{
    MKBXPiBeacon *iBeaconModel = (MKBXPiBeacon *)beacon;
    return [MKBXPScanBeaconCell getCellHeightWithUUID:iBeaconModel.uuid];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    [self.rightButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPScanViewController", @"bxp_scanRightAboutIcon.png") forState:UIControlStateNormal];
    self.titleLabel.text = @"DEVICE(0)";
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton addSubview:self.refreshIcon];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftButton.mas_centerX);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    UIView *headerView = [[UIView alloc] init];
    
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(defaultTopInset);
        make.height.mas_equalTo(searchButtonHeight + 2 * offset_X);
    }];
    
    [headerView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(offset_X);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(headerView.mas_bottom);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPScanViewController", @"bxp_scanRefresh.png");
    }
    return _refreshIcon;
}

- (MKBXPScanSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[MKBXPScanSearchButton alloc] init];
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (MKBXPSearchButtonModel *)buttonModel {
    if (!_buttonModel) {
        _buttonModel = [[MKBXPSearchButtonModel alloc] init];
        _buttonModel.placeholder = @"Edit Filter";
        _buttonModel.minSearchRssi = -100;
        _buttonModel.searchRssi = -100;
    }
    return _buttonModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
