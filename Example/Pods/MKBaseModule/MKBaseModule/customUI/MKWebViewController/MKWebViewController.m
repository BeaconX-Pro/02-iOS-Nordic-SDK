//
//  MKWebViewController.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKWebViewController.h"
#import "MKHudManager.h"
#import "MKCategoryModule.h"
#import <YYKit/YYKit.h>

@interface MKWebViewController ()<IMYWebViewDelegate>
@end

@implementation MKWebViewController

- (void)dealloc{
    NSLog(@"MKWebViewController销毁");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_url || _url.absoluteString.length == 0) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"url error"];
        return;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _webView = [[IMYWebView alloc] initWithFrame:CGRectMake(0.0f,
                                                                0.0f,
                                                                kScreenWidth,
                                                                kScreenHeight - 64.f)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _webView.delegate = self;
    
    if (_url) {
        [self reloadUrlData];
        [self.view addSubview:_webView];
    }
}

- (void)reloadUrlData{
    [[MKHudManager share] showHUDWithTitle:@"Loading..."
                                    inView:self.view
                             isPenetration:NO];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [request addValue:@"app" forHTTPHeaderField:@"agent"];
    [_webView loadRequest:request];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@"::"];
    if (components != nil && [components count] > 0) {
        NSString *pocotol = [components objectAtIndex:0];
        if ([pocotol isEqualToString:@"apply"]) {
            NSString *commandStr = [components objectAtIndex:1];
            NSArray *commandArray = [commandStr componentsSeparatedByString:@":"];
            if (commandArray != nil && [commandArray count] > 0) {
                NSString *command = [commandArray objectAtIndex:0];
                if ([command isEqualToString:@"carpark"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(IMYWebView *)webView{
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView{
    [self webViewDidFinished:webView];
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error{
    [[MKHudManager share] hide];
    if([error code] == NSURLErrorCancelled){
    }
    else{
        //reloadUrlData
    }
}

-(void)webViewDidFinished:(IMYWebView *)webView
{
    if (webView.title.length > 0) {
        self.title = webView.title;
    }
    [[MKHudManager share] hide];
}

#pragma mark - 父类方法
- (void)leftButtonMethod{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
    else{
        [self leftButtonMethod];
    }
}

@end
