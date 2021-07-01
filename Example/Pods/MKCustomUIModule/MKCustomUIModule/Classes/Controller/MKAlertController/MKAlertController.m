//
//  MKAlertController.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/7/1.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKAlertController.h"

#import "MKMacroDefines.h"

@interface MKAlertController ()

@end

@implementation MKAlertController

- (void)dealloc {
    NSLog(@"MKAlertController销毁");
    if (ValidStr(self.notificationName)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:self.notificationName
                                                      object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (ValidStr(self.notificationName)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:self.notificationName object:nil];
    }
}

#pragma mark - note method
- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
