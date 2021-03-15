//
//  Target_BXP_Module.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "Target_BXP_Module.h"

#import "MKBXPScanViewController.h"

@implementation Target_BXP_Module

- (UIViewController *)Action_BXP_Module_ScanController:(NSDictionary *)params {
    return [[MKBXPScanViewController alloc] init];
}

@end
