//
//  MKBXPDeviceInfoModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPDeviceInfoModel.h"

#import "MKMacroDefines.h"

#import "MKBXPInterface.h"

@interface MKBXPDeviceInfoModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXPDeviceInfoModel

- (void)readWithSucBlock:(void (^)(NSDictionary *params))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBatteryPower]) {
            [self operationFailedBlockWithMsg:@"Read battery power error" block:failedBlock];
            return ;
        }
        if (![self readMacAddress]) {
            [self operationFailedBlockWithMsg:@"Read mac address error" block:failedBlock];
            return ;
        }
        if (![self readProduce]) {
            [self operationFailedBlockWithMsg:@"Read product model error" block:failedBlock];
            return ;
        }
        if (![self readSoftware]) {
            [self operationFailedBlockWithMsg:@"Read software error" block:failedBlock];
            return ;
        }
        if (![self readFirmware]) {
            [self operationFailedBlockWithMsg:@"Read firmware error" block:failedBlock];
            return ;
        }
        if (![self readHardware]) {
            [self operationFailedBlockWithMsg:@"Read hardware error" block:failedBlock];
            return ;
        }
        if (![self readManuDate]) {
            [self operationFailedBlockWithMsg:@"Read manufacture date error" block:failedBlock];
            return ;
        }
        if (![self readManu]) {
            [self operationFailedBlockWithMsg:@"Read manufacture error" block:failedBlock];
            return ;
        }
        NSDictionary *resultDic = @{
            mk_bx_deviceInfo_batteryKey:SafeStr(self.battery),
            mk_bx_deviceInfo_macAddressKey:SafeStr(self.macAddress),
            mk_bx_deviceInfo_produceKey:SafeStr(self.produce),
            mk_bx_deviceInfo_softwareKey:SafeStr(self.software),
            mk_bx_deviceInfo_firmwareKey:SafeStr(self.firmware),
            mk_bx_deviceInfo_hardwareKey:SafeStr(self.hardware),
            mk_bx_deviceInfo_manuDateKey:SafeStr(self.manuDate),
            mk_bx_deviceInfo_manuKey:SafeStr(self.manu),
        };
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readBatteryPower {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readBatteryWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.battery = returnData[@"result"][@"battery"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readMacAddress {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readMacAddresWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.macAddress = returnData[@"result"][@"macAddress"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readProduce {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readModeIDWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.produce = returnData[@"result"][@"modeID"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSoftware {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readSoftwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.software = returnData[@"result"][@"software"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFirmware {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readFirmwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.firmware = returnData[@"result"][@"firmware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHardware {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readHardwareWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hardware = returnData[@"result"][@"hardware"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManuDate {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readProductionDateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manuDate = returnData[@"result"][@"productionDate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManu {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readVendorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manu = returnData[@"result"][@"vendor"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"deviceInformation"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("deviceInfoParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
