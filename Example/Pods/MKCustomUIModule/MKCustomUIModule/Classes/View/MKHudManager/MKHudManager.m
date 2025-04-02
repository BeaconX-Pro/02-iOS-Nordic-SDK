//
//  MKHudManager.m
//  FitPolo
//
//  Created by aa on 17/5/8.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKHudManager.h"
#import "MKProgressHUD.h"
#import "MKMacroDefines.h"

@interface MKHudManager (){
    __weak UIView *_inView;
}

@property (nonatomic,strong) MKProgressHUD      *MKProgressHUD;

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
    if (_MKProgressHUD) {
        [self hide];
        _MKProgressHUD = nil;
    }
    _inView = inView;
    UIView *baseView = nil;
    if (_inView) {
        baseView = _inView;
    }
    else{
        baseView = kAppWindow;
    }
    
    _MKProgressHUD = [[MKProgressHUD alloc] initWithView:baseView];
    _MKProgressHUD.userInteractionEnabled = !isPenetration;
    _MKProgressHUD.removeFromSuperViewOnHide = YES;
    _MKProgressHUD.bezelView.layer.cornerRadius = 5.0;
    _MKProgressHUD.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.75];
    _inView = inView;
    if (_inView) {
        [_inView addSubview:_MKProgressHUD];
    }
    else{
        [kAppWindow addSubview:_MKProgressHUD];
    }
    
    _MKProgressHUD.label.text = title;
    [self show];
}

-(void)show{
    [kAppWindow bringSubviewToFront:_MKProgressHUD];
    [_MKProgressHUD showAnimated:YES];
}

-(void)hide{
    if (_inView) {
        _inView.userInteractionEnabled = YES;
    }
    moko_dispatch_main_safe(^{
        [_MKProgressHUD hideAnimated:YES];
    });
}

- (void)hideAfterDelay:(NSTimeInterval)delay{
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

@end
