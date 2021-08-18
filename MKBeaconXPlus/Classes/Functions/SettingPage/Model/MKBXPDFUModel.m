//
//  MKBXPDFUModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPDFUModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBXPCentralManager.h"

@implementation MKBXPDFUModel

- (CBPeripheral *)peripheral {
    return [MKBXPCentralManager shared].peripheral;
}

- (void)sharedDealloc {
    [MKBXPCentralManager sharedDealloc];
}

@end
