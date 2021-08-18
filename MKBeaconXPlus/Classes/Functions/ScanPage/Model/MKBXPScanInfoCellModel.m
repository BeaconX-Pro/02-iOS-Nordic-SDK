//
//  MKBXPScanInfoCellModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPScanInfoCellModel.h"

@implementation MKBXPScanInfoCellModel

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
