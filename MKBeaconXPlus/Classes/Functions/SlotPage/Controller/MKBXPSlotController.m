//
//  MKBXPSlotController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKBXSlotDataAdopter.h"
#import "MKBXEnumerateDefine.h"

#import "MKBXPInterface.h"

#import "MKBXPSlotDataModel.h"

#import "MKBXPSlotConfigController.h"

@interface MKBXPSlotController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBXPSlotController

- (void)dealloc {
    NSLog(@"MKBXPSlotController销毁");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self readSlotDataType];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxp_popToRootViewControllerNotification" object:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXPSlotDataModel *cellModel = self.dataList[indexPath.row];
    return [cellModel cellHeightWithContentWidth:kViewWidth];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXPSlotDataModel *cellModel = self.dataList[indexPath.row];
    MKBXPSlotConfigController *vc = [[MKBXPSlotConfigController alloc] init];
    vc.slotType = cellModel.slotType;
    vc.slotIndex = cellModel.slotIndex;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    return cell;
}

#pragma mark - interface
- (void)readSlotDataType {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_readSlotDataTypeWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self parseSlotDataType:returnData[@"result"]];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)parseSlotDataType:(NSDictionary *)returnData {
    if (!ValidDict(returnData)) {
        return;
    }
    [self.dataList removeAllObjects];
    NSArray *slotList = returnData[@"slotTypeList"];
    for (NSInteger i = 0; i < slotList.count; i ++) {
        MKBXPSlotDataModel *slotModel = [[MKBXPSlotDataModel alloc] init];
        slotModel.slotType = [MKBXSlotDataAdopter fetchSlotFrameType:slotList[i]];
        slotModel.slotIndex = i;
        slotModel.leftMsg = [@"SLOT" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)(i + 1)]];
        slotModel.showRightIcon = YES;
        slotModel.rightMsg = [self fetchSlotCellRightMsg:slotModel.slotType];
        
        [self.dataList addObject:slotModel];
    }
    [self.tableView reloadData];
}

#pragma mark - private method
- (NSString *)fetchSlotCellRightMsg:(mk_bx_slotFrameType)type {
    switch (type) {
        case mk_bx_slotFrameTypeBeacon:
            return @"iBeacon";
        case mk_bx_slotFrameTypeUID:
            return @"UID";
        case mk_bx_slotFrameTypeURL:
            return @"URL";
        case mk_bx_slotFrameTypeTLM:
            return @"TLM";
        case mk_bx_slotFrameTypeNull:
            return @"NO DATA";
        case mk_bx_slotFrameTypeInfo:
            return @"Device info";
        case mk_bx_slotFrameTypeThreeASensor:
            return @"Accel";
        case mk_bx_slotFrameTypeTHSensor:
            return @"T&H";
    }
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"SLOT";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 49.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

@end
