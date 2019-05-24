//
//  MKDeviceInfoModel.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDeviceInfoModel.h"

@interface MKDeviceInfoModel ()

@property (nonatomic, copy)void (^sucBlock)(void);

@property (nonatomic, copy)void (^failBlock)(NSError *error);

@end

@implementation MKDeviceInfoModel

- (void)startLoadSystemInformation:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failBlock = nil;
    self.failBlock = failedBlock;
    [self getBattery];
}

- (void)getBattery{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPBatteryWithSucBlock:^(id returnData) {
        weakSelf.battery = returnData[@"result"][@"battery"];
        [weakSelf getMacAddress];
    } failedBlock:^(NSError *error) {
        [weakSelf getMacAddress];
    }];
}

- (void)getMacAddress{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.macAddress)) {
        [self getProduce];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPMacAddresWithSucBlock:^(id returnData) {
        weakSelf.macAddress = returnData[@"result"][@"macAddress"];
        [weakSelf getProduce];
    } failedBlock:^(NSError *error) {
        [weakSelf getProduce];
    }];
}

- (void)getProduce{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.produce)) {
        [self getSoftware];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPModeIDWithSucBlock:^(id returnData) {
        weakSelf.produce = returnData[@"result"][@"modeID"];
        [weakSelf getSoftware];
    } failedBlock:^(NSError *error) {
        [weakSelf getSoftware];
    }];
}

- (void)getSoftware{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.software)) {
        [self getFirmware];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPSoftwareWithSucBlock:^(id returnData) {
        weakSelf.software = returnData[@"result"][@"software"];
        [weakSelf getFirmware];
    } failedBlock:^(NSError *error) {
        [weakSelf getFirmware];
    }];
}

- (void)getFirmware{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.firmware)) {
        [self getHardware];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPFirmwareWithSucBlock:^(id returnData) {
        weakSelf.firmware = returnData[@"result"][@"firmware"];
        [weakSelf getHardware];
    } failedBlock:^(NSError *error) {
        [weakSelf getHardware];
    }];
}

- (void)getHardware{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.hardware)) {
        [self getManuDate];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPHardwareWithSucBlock:^(id returnData) {
        weakSelf.hardware = returnData[@"result"][@"hardware"];
        [weakSelf getManuDate];
    } failedBlock:^(NSError *error) {
        [weakSelf getManuDate];
    }];
}

- (void)getManuDate{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.manuDate)) {
        [self getManu];
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPProductionDateWithSucBlock:^(id returnData) {
        weakSelf.manuDate = returnData[@"result"][@"productionDate"];
        [weakSelf getManu];
    } failedBlock:^(NSError *error) {
        [weakSelf getManu];
    }];
}

- (void)getManu{
    if ([MKBXPCentralManager shared].connectState != MKBXPConnectStatusConnected) {
        if (self.failBlock) {
            self.failBlock([self errorWithMsg:@"EddStone has been disconnected"]);
        }
        return;
    }
    if (ValidStr(self.manu)) {
        if (self.sucBlock) {
            self.sucBlock();
        }
        return;
    }
    WS(weakSelf);
    [MKBXPInterface readBXPVendorWithSucBlock:^(id returnData) {
        weakSelf.manu = returnData[@"result"][@"vendor"];
        if (weakSelf.sucBlock) {
            weakSelf.sucBlock();
        }
    } failedBlock:^(NSError *error) {
        if (weakSelf.sucBlock) {
            weakSelf.sucBlock();
        }
    }];
}

- (NSError *)errorWithMsg:(NSString *)msg{
    NSError *error = [[NSError alloc] initWithDomain:@"loadSystemInformation"
                                                code:-999
                                            userInfo:@{@"errorInfo":SafeStr(msg)}];
    return error;
}

@end
