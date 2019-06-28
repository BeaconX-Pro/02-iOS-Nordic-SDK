//
//  MKHTConfigController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKHTConfigController.h"
#import "MKBaseTableView.h"
#import "MKSlotLineHeader.h"
#import "MKHTDataCell.h"
#import "MKHTParamsConfigCell.h"
#import "MKHTDateTimeCell.h"
#import "MKExportHTDataCell.h"

#import "MKExportHTDataController.h"

@interface MKHTDateModel : NSObject<MKBXPDeviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@implementation MKHTDateModel

@end

@interface MKHTStorageConditionsModel : NSObject<MKBXPHTStorageConditionsProtocol>

@property (nonatomic, assign)HTStorageConditions condition;

/**
 HTStorageConditions != HTStorageConditionsTime,当前值会被缩小10倍之后设置给设备,0~1000
 */
@property (nonatomic, assign)NSInteger temperature;

/**
 HTStorageConditions != HTStorageConditionsTime,0~100
 */
@property (nonatomic, assign)NSInteger humidity;

/**
 
 HTStorageConditions == HTStorageConditionsTime, 情况下，范围值为1~255,
 */
@property (nonatomic, assign)NSInteger time;

@end

@implementation MKHTStorageConditionsModel

@end

@interface MKHTConfigController ()<UITableViewDelegate, UITableViewDataSource, MKHTDateTimeCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKHTConfigController

- (void)dealloc {
    NSLog(@"MKHTConfigController销毁");
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHTData:)
                                                 name:MKBXPReceiveHTDataNotification
                                               object:nil];
    [self loadCells];
    [self readParamsFromDevice];
    // Do any additional setup after loading the view.
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self configParams];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 150.f;
    }
    if (indexPath.section == 1) {
        return 170.f;
    }
    if (indexPath.section == 2) {
        return 80.f;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKSlotLineHeader *header = [MKSlotLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataList.count - 1) {
        //最后一行是导出温湿度数据
        MKExportHTDataController *vc = [[MKExportHTDataController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataList[indexPath.section];
}

#pragma mark - MKHTDateTimeCellDelegate
- (void)bxpUpdateDeviceTime {
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        BOOL success = [self setDeviceTime];
        if (!success) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Set the current time failure equipment"];
            });
            return ;
        }
        NSString *deviceTime = [self readDeviceTime];
        if (!ValidStr(deviceTime)) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Reading equipment current time failed"];
            });
            return;
        }
        moko_dispatch_main_safe((^{
            [[MKHudManager share] hide];
            MKHTDateTimeCell *timeCell = self.dataList[2];
            if ([timeCell isKindOfClass:NSClassFromString(@"MKHTDateTimeCell")]) {
                NSArray *dateList = [deviceTime componentsSeparatedByString:@"-"];
                timeCell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@   %@:%@:%@",dateList[0],dateList[1],dateList[2],dateList[3],dateList[4],dateList[5]];
            }
        }));
    });
    
}

#pragma mark - note
- (void)receiveHTData:(NSNotification *)note {
    MKHTDataCell *cell = self.dataList[0];
    if (![cell isKindOfClass:NSClassFromString(@"MKHTDataCell")]) {
        return;
    }
    cell.dataDic = note.userInfo;
}

#pragma mark - interface
- (void)readParamsFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    dispatch_async(self.configQueue, ^{
        NSString *samplingRate = [self readSamplingRate];
        NSDictionary *storageConditions = [self readHTStorageConditions];
        NSString *deviceTime = [self readDeviceTime];
        moko_dispatch_main_safe((^{
            [[MKHudManager share] hide];
            if (!ValidStr(samplingRate)) {
                [self.view showCentralToast:@"Read the temperature and humidity sampling rate errors"];
                return ;
            }
            if (!ValidDict(storageConditions)) {
                [self.view showCentralToast:@"Error reading the temperature and humidity storage conditions"];
                return;
            }
            if (!ValidStr(deviceTime)) {
                [self.view showCentralToast:@"Reading equipment current time failed"];
                return;
            }
            MKHTDataCell *cell = self.dataList[0];
            if ([cell isKindOfClass:NSClassFromString(@"MKHTDataCell")]) {
                cell.textField.text = samplingRate;
            }
            MKHTParamsConfigCell *paramsCell = self.dataList[1];
            if ([paramsCell isKindOfClass:NSClassFromString(@"MKHTParamsConfigCell")]) {
                [paramsCell setDataDic:storageConditions];
            }
            MKHTDateTimeCell *timeCell = self.dataList[2];
            if ([timeCell isKindOfClass:NSClassFromString(@"MKHTDateTimeCell")]) {
                NSArray *dateList = [deviceTime componentsSeparatedByString:@"-"];
                timeCell.timeLabel.text = [NSString stringWithFormat:@"%@/%@/%@   %@:%@:%@",dateList[0],dateList[1],dateList[2],dateList[3],dateList[4],dateList[5]];
            }
        }));
    });
}

- (void)configParams {
    MKHTDataCell *htCell = self.dataList[0];
    if (![htCell isKindOfClass:NSClassFromString(@"MKHTDataCell")]) {
        return;
    }
    NSString *samplingRate = [htCell.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!ValidStr(samplingRate)) {
        [self.view showCentralToast:@"Sampling rate error"];
        return;
    }
    MKSlotBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell == nil || ![cell isKindOfClass:NSClassFromString(@"MKHTParamsConfigCell")]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDictionary *dic = [cell getContentData];
    MKHTStorageConditionsModel *conditionsModel = [[MKHTStorageConditionsModel alloc] init];
    conditionsModel.condition = [dic[@"result"][@"functionType"] integerValue];
    conditionsModel.temperature = [dic[@"result"][@"temperature"] integerValue];
    conditionsModel.humidity = [dic[@"result"][@"humidity"] integerValue];
    conditionsModel.time = [dic[@"result"][@"storageTime"] integerValue];
    dispatch_async(self.configQueue, ^{
        if (![self configBXPHTSamplingRate:[samplingRate integerValue]]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Config sampling rate error"];
            });
            return ;
        }
        if (![self configHTStorageConditions:conditionsModel]) {
            moko_dispatch_main_safe(^{
                [[MKHudManager share] hide];
                [self.view showCentralToast:@"Config error"];
            });
            return ;
        }
        moko_dispatch_main_safe(^{
            [[MKHudManager share] hide];
            [self.view showCentralToast:@"Config success"];
        });
    });
}

- (NSString *)readSamplingRate {
    __block NSString *samplingRate = @"";
    [MKBXPInterface readBXPHTSamplingRateWithSuccessBlock:^(id  _Nonnull returnData) {
        samplingRate = returnData[@"result"][@"samplingRate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return samplingRate;
}

- (NSDictionary *)readHTStorageConditions {
    __block NSDictionary *dataDic = @{};
    [MKBXPInterface readBXPHTStorageConditionsWithSuccessBlock:^(id  _Nonnull returnData) {
        dataDic = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return dataDic;
}

- (NSString *)readDeviceTime {
    __block NSString *deviceTime = @"";
    [MKBXPInterface readBXPDeviceTimeWithSuccessBlock:^(id  _Nonnull returnData) {
        deviceTime = returnData[@"result"][@"deviceTime"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return deviceTime;
}

- (BOOL)setDeviceTime {
    __block BOOL success = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *dateList = [date componentsSeparatedByString:@"-"];
    MKHTDateModel *dateModel = [[MKHTDateModel alloc] init];
    dateModel.year = [dateList[0] integerValue];
    dateModel.month = [dateList[1] integerValue];
    dateModel.day = [dateList[2] integerValue];
    dateModel.hour = [dateList[3] integerValue];
    dateModel.minutes = [dateList[4] integerValue];
    dateModel.seconds = [dateList[5] integerValue];
    [MKBXPInterface setBXPDeviceTime:dateModel sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configHTStorageConditions:(MKHTStorageConditionsModel *)model {
    __block BOOL success = NO;
    [MKBXPInterface setBXPHTStorageConditions:model sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBXPHTSamplingRate:(NSInteger)rate {
    __block BOOL success = NO;
    [MKBXPInterface setBXPHTSamplingRate:rate sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method

- (void)loadCells {
    MKHTDataCell *htCell = [MKHTDataCell initCellWithTableView:self.tableView];
    [self.dataList addObject:htCell];
    MKHTParamsConfigCell *paramsCell = [MKHTParamsConfigCell initCellWithTableView:self.tableView];
    [self.dataList addObject:paramsCell];
    MKHTDateTimeCell *dateCell = [MKHTDateTimeCell initCellWithTableView:self.tableView];
    dateCell.delegate = self;
    [self.dataList addObject:dateCell];
    MKExportHTDataCell *exportCell = [MKExportHTDataCell initCellWithTableView:self.tableView];
    [self.dataList addObject:exportCell];
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.defaultTitle = @"T&H";
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(defaultTopInset + 5.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - setter & getter
-(MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("HTConfigParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end
