//
//  MKScanViewController.m
//  BeaconXPlus
//
//  Created by aa on 2019/4/19.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanViewController.h"

@interface MKScanViewController ()

@end

@implementation MKScanViewController

#pragma mark - life circle
- (void)dealloc {
    NSLog(@"MKScanViewController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    self.defaultTitle = @"扫描";
}

#pragma mark - super method
- (void)leftButtonMethod {
    [[MKBXPCentralManager shared] startScanPeripheral];
}

@end
