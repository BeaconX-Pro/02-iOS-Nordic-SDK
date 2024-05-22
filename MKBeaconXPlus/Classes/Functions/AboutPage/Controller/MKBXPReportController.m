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

/*
- (void)urlPrintWithUIGraphics {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];

    UIGraphicsBeginPDFContextToFile(self.pathPDF, CGRectZero, NULL);


    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    UIGraphicsBeginPDFPage();

    [[[MKBXPRoadCasePrint alloc] init] drawInquestRecordAction:nil];

    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[MKBXPRoadCasePrint alloc] init] drawSiteRecordAction:nil];


    UIGraphicsEndPDFContext();

}

- (void)dataPrintWithUIGraphics {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF =  [documentPath stringByAppendingPathComponent:@"绘制.pdf"];
    
    NSMutableData *data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, NULL);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[MKBXPRoadCasePrint alloc] init] drawInquestRecordAction:nil];

    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [[[MKBXPRoadCasePrint alloc] init] drawSiteRecordAction:nil];

    UIGraphicsEndPDFContext();
    
    
    [data writeToFile:self.pathPDF atomically:YES];
}

- (void)urlPrintWithCoreGraphics {
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];

    const char *filename = [self.pathPDF UTF8String];
    
    CFStringRef path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    // 释放
    CFRelease(path);
    
    // 创建基于URL的PDF图形上下文
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);
    // 释放
    CFRelease(url);

    CGRect pageRect = CGRectMake(0, 0, 1240, 1754);
    
    // 使指定的图形上下文成为当前上下文
    UIGraphicsPushContext(pdfContext);
    
    // 在基于页面的图形上下文中启动新页面
    CGContextBeginPage(pdfContext, &pageRect);
    
    // 坐标系向上平移了pageRect.size.height, 具体原因下面会解释
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    // y轴的缩放因子是-1, y乘缩放因子-1, x轴不变, y轴就是沿x轴翻转了过来
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    // 绘制内容的代码，具体下面会说
    [[[MKBXPRoadCasePrint alloc] init] drawInquestRecordAction:nil];
    
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    // 释放
    CGContextRelease(pdfContext);
}

- (void)dataPrintWithCoreGraphics {
    
    NSMutableData *pdfData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)pdfData);
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, NULL, NULL);
    
    CGDataConsumerRelease(dataConsumer);
    
    CGRect pageRect = CGRectMake(0.0f, 0.0f, 1240, 1754);
    
    UIGraphicsPushContext(pdfContext);
    CGContextBeginPage(pdfContext, &pageRect);

    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    
    [[[MKBXPRoadCasePrint alloc] init] drawSiteRecordAction:nil];

    CGContextEndPage(pdfContext);
    CGPDFContextClose(pdfContext);
    UIGraphicsPopContext();

    CGContextRelease(pdfContext);
    
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];
    
    [pdfData writeToFile:self.pathPDF atomically:YES];
}

// 模板两个字的位置变了, 是因为两个pdf的大小不一样
- (void)printAlreadyWithCoreGraphics {
    NSString *docsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    self.pathPDF = [NSString stringWithFormat:@"%@/绘制.pdf",docsDirectory];
    
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"MKBXPReportController")];
    NSString *bundlePath = [bundle pathForResource:@"MKBeaconXPlus" ofType:@"bundle"];
    
    NSString *pathName = [bundlePath stringByAppendingPathComponent:@"模板.pdf"];

    const char *filename = [self.pathPDF UTF8String];
    const char *bgFilename = [pathName UTF8String];

    CFStringRef path = CFStringCreateWithCString (NULL, filename, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease(path);
    
    CFStringRef bgPath = CFStringCreateWithCString (NULL, bgFilename, kCFStringEncodingUTF8);
    CFURLRef bgUrl = CFURLCreateWithFileSystemPath (NULL, bgPath, kCFURLPOSIXPathStyle, 0);
    CFRelease(bgPath);

    // 创建基于URL的PDF图形上下文
    CGContextRef pdfContext = CGPDFContextCreateWithURL(url, NULL, NULL);
    CFRelease(url);

    // 使用URL指定的数据创建核心图形PDF文档。获取模板这个PDF文件
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(bgUrl);
    // document也可以用data创建
//    NSData *pdfData = [NSData dataWithContentsOfFile:pathName];
//    CFDataRef myPDFData = (__bridge CFDataRef) pdfData;
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
//    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(provider);
//    CGDataProviderRelease(provider);
    
    CFRelease(bgUrl);
    
    // 返回核心图形PDF文档中的页面。获取这个文档的第一页
    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1);
    
    //获取page页面的大小
//    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect pageRect = CGRectMake(0.0f, 0.0f, 1240, 1754);
    
    // 使指定的图形上下文成为当前上下文
    UIGraphicsPushContext(pdfContext);
    
    // 在基于页面的图形上下文中启动新页面
    CGContextBeginPage(pdfContext, &pageRect);
    
    // 将PDF页面的内容绘制到当前图形上下文中
    CGContextDrawPDFPage(pdfContext, page);
    
    // 坐标系向上平移了pageRect.size.height, 具体原因下面会解释
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    // y轴的缩放因子是-1, y乘缩放因子-1, x轴不变, y轴就是沿x轴翻转了过来
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    [[[MKBXPRoadCasePrint alloc] init] drawSiteRecordAction:nil];
    // 在PDF图形上下文中结束当前页
    CGPDFContextEndPage(pdfContext);
    
    // 第二页
    CGContextBeginPage(pdfContext, &pageRect);
    CGContextTranslateCTM(pdfContext, 0, pageRect.size.height);
    CGContextScaleCTM(pdfContext, 1.0, -1.0);
    [[[MKBXPRoadCasePrint alloc] init] drawInquestRecordAction:nil];
    CGPDFContextEndPage(pdfContext);
    
    
    // 从堆栈顶部移除当前图形上下文，恢复以前的上下文
    UIGraphicsPopContext();
    // 关闭pdf文档
    CGPDFContextClose(pdfContext);
    
    
    CGPDFDocumentRelease(document);
    CGContextRelease(pdfContext);
    
}
*/

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
