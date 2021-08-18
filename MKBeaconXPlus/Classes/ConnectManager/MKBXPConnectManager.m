//
//  MKBXPConnectManager.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPConnectManager.h"

#import "MKMacroDefines.h"

@interface MKBXPConnectManager ()

@end

@implementation MKBXPConnectManager

+ (MKBXPConnectManager *)shared {
    static MKBXPConnectManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[MKBXPConnectManager alloc] init];
        }
    });
    return manager;
}

- (void)clearParams {
    self.password = @"";
    self.deviceType = @"";
    self.newVersion = NO;
}

@end
