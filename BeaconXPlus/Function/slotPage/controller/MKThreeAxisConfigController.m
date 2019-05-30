//
//  MKThreeAxisConfigController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKThreeAxisConfigController.h"
#import "MKBaseTableView.h"
#import "MKSlotLineHeader.h"
#import "MKAxisAcceDataCell.h"
#import "MKAxisParametersCell.h"

@interface MKThreeAxisConfigController ()<UITableViewDelegate, UITableViewDataSource, MKAxisAcceDataCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@end

@implementation MKThreeAxisConfigController

- (void)dealloc {
    NSLog(@"MKThreeAxisConfigController销毁");
    [[MKBXPCentralManager shared] notifyThreeAxisAcceleration:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveThreeAxisData:)
                                                 name:MKBXPReceiveThreeAxisAccelerometerDataNotification
                                               object:nil];
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
        return 80.f;
    }
    return 170.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKSlotLineHeader *header = [MKSlotLineHeader initHeaderViewWithTableView:tableView];
    return header;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKAxisAcceDataCell *cell = [MKAxisAcceDataCell initCellWithTableView:self.tableView];
        cell.delegate = self;
        return cell;
    }
    MKAxisParametersCell *cell = [MKAxisParametersCell initCellWithTableView:self.tableView];
    cell.dataDic = self.dataDic;
    return cell;
}

#pragma mark - MKAxisAcceDataCellDelegate
- (void)updateThreeAxisNotifyStatus:(BOOL)notify {
    [[MKBXPCentralManager shared] notifyThreeAxisAcceleration:notify];
}

- (void)receiveThreeAxisData:(NSNotification *)note {
    MKAxisAcceDataCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!cell || ![cell isKindOfClass:NSClassFromString(@"MKAxisAcceDataCell")]) {
        return;
    }
    [cell setAxisData:note.userInfo];
}

#pragma mark - interface
- (void)readParamsFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface readBXPThreeAxisDataParamsWithSuccessBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        self.dataDic = returnData[@"result"];
        [self.tableView reloadData];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)configParams {
    MKSlotBaseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (cell == nil || ![cell isKindOfClass:NSClassFromString(@"MKAxisParametersCell")]) {
        return;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDictionary *dic = [cell getContentData];
    [MKBXPInterface setBXPThreeAxisDataParams:[dic[@"result"][@"dataRate"] integerValue] acceleration:[dic[@"result"][@"scale"] integerValue] sensitivity:[dic[@"result"][@"sensitivity"] integerValue] sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"success"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method

- (void)loadSubViews {
    self.defaultTitle = @"3-Axis";
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.rightButton setImage:LOADIMAGE(@"slotSaveIcon", @"png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(defaultTopInset + 5.f);
        make.bottom.mas_equalTo(0);
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

@end
