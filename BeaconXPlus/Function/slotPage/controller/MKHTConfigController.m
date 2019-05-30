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

@interface MKHTConfigController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKHTDataCell *cell = [MKHTDataCell initCellWithTableView:tableView];
    return cell;
}

- (void)receiveHTData:(NSNotification *)note {
//    MKAxisAcceDataCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    if (!cell || ![cell isKindOfClass:NSClassFromString(@"MKAxisAcceDataCell")]) {
//        return;
//    }
//    [cell setAxisData:note.userInfo];
}

#pragma mark - interface
- (void)readParamsFromDevice {
    
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
    self.defaultTitle = @"H&T";
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
