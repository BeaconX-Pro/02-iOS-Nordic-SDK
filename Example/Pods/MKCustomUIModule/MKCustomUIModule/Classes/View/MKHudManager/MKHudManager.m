//
//  MKHudManager.m
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKHudManager.h"
#import "MBProgressHUD.h"
#import "MKMacroDefines.h"

@interface MKHudManager (){
    __weak UIView *_inView;
}

@property (nonatomic,strong) MBProgressHUD      *mBProgressHUD;

@end

@implementation MKHudManager

+ (instancetype)share{
    static dispatch_once_t t;
    static MKHudManager *manager = nil;
    dispatch_once(&t, ^{
        manager = [[MKHudManager alloc] init];
    });
    return manager;
}

- (void)showHUDWithTitle:(NSString *)title
                  inView:(UIView *)inView
           isPenetration:(BOOL)isPenetration{
    if (_mBProgressHUD) {
        [self hide];
        _mBProgressHUD = nil;
    }
    _inView = inView;
    UIView *baseView = nil;
    if (_inView) {
        baseView = _inView;
    }
    else{
        baseView = kAppWindow;
    }
    
    _mBProgressHUD = [[MBProgressHUD alloc] initWithView:baseView];
    _mBProgressHUD.userInteractionEnabled = !isPenetration;
    _mBProgressHUD.removeFromSuperViewOnHide = YES;
    _mBProgressHUD.bezelView.layer.cornerRadius = 5.0;
    _mBProgressHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.75];
    _inView = inView;
    if (_inView) {
        [_inView addSubview:_mBProgressHUD];
    }
    else{
        [kAppWindow addSubview:_mBProgressHUD];
    }
    
    _mBProgressHUD.label.text = title;
    [self show];
}

-(void)show{
    [kAppWindow bringSubviewToFront:_mBProgressHUD];
    [_mBProgressHUD showAnimated:YES];
}

-(void)hide{
    if (_inView) {
        _inView.userInteractionEnabled = YES;
    }
    moko_dispatch_main_safe(^{
        [_mBProgressHUD hideAnimated:YES];
    });
}

- (void)hideAfterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

@end
