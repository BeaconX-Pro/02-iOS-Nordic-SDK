//
//  MKWebViewController.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IMYWebView/IMYWebView.h>

@interface MKWebViewController : UIViewController

@property (nonatomic,readonly)IMYWebView *webView;
@property (nonatomic,strong)  NSURL *url;
@property (nonatomic,strong)  UIViewController *vc;

//完成回调方法 如需修改 子类重写该方法
- (void)webViewDidFinishLoad:(IMYWebView *)webView;

@end
