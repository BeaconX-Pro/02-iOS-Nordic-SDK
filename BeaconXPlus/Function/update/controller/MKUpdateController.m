//
//  MKUpdateController.m
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKUpdateController.h"
#import "MKDFUAdopter.h"
#import "MKBaseTableView.h"

@interface MKUpdateController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKDFUAdopter *adopter;

@end

@implementation MKUpdateController

#pragma mark -
- (void)dealloc {
    NSLog(@"MKUpdateController销毁");
    [self.adopter cancel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self getDatasFromSource];
    WS(weakSelf);
    [self.adopter startMonitoringDirectory:^{
        [weakSelf getDatasFromSource];
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *name = self.dataList[indexPath.row];
    WS(weakSelf);
    self.leftButton.enabled = NO;
    [self.adopter dfuUpdateWithFileName:name target:weakSelf];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKUpdateController"];
    cell.contentView.backgroundColor = COLOR_WHITE_MACROS;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKUpdateController"];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark -
- (void)getDatasFromSource{
    NSArray *list = [self.adopter getDfuFilesList];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:list];
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.titleLabel.textColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"OTA";
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - setter & getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(239, 239, 239);
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKDFUAdopter *)adopter {
    if (!_adopter) {
        _adopter = [[MKDFUAdopter alloc] init];
    }
    return _adopter;
}

@end
