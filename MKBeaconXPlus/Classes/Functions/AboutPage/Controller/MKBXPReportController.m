//
//  MKBXPReportController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2024/5/19.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPReportController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXPRoadCasePrint.h"

@interface MKBXPReportController ()

@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, copy) NSString *pathPDF;

@end

@implementation MKBXPReportController

- (void)dealloc {
    NSLog(@"MKBXPReportController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadDatas];
    [self.rightButton setTitle:@"Print" forState:UIControlStateNormal];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self selectRightAction];
}

#pragma mark - Load Data

- (void)loadDatas {
    [[MKHudManager share] showHUDWithTitle:@"Waiting..." inView:self.view isPenetration:NO];
//    [self loadDetailList];
    [self loadDataReport];
    NSURL *url1 = [NSURL fileURLWithPath:self.pathPDF];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url1]];
    [[MKHudManager share] hide];
}

- (void)loadDetailList {
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i < 1010; i ++) {
        MKBXPDataReportModel *dataModel = [[MKBXPDataReportModel alloc] init];
        dataModel.index = i;
        dataModel.timestamp = @"05/16/2024 16:32:50";
        dataModel.temperature = @"24.5";

        [dataList addObject:dataModel];
    }
    self.pathPDF = [[[MKBXPRoadCasePrint alloc] init] drawDataListReport:dataList];
}

- (void)loadDataReport {
    self.pathPDF = [[[MKBXPRoadCasePrint alloc] init] drawDetailDataReport:@{}];
}

// 隔空打印
- (void)selectRightAction {
    // 打印PDF canPrintURL不知道为什么返回false，就用canPrintData判断
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    NSData *myPDFData = [NSData dataWithContentsOfFile:self.pathPDF];
    if (pic && [UIPrintInteractionController canPrintData:myPDFData]) {
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"DataReport.pdf";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        
        pic.printInfo = printInfo;

        pic.printingItem = myPDFData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) NSLog(@"FAILED! due to error in domain %@ with error code %ld",error.domain, (long)error.code);
        };
        //直接打印
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"Data Report";
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.right.mas_equalTo(0.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
