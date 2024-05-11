//
//  MKBXPConnectManager.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPConnectManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPDeviceTimeDataModel.h"

@interface MKBXPConnectManager ()

@property (nonatomic, strong)dispatch_queue_t connectQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@property (nonatomic, copy)NSString *software;

@property (nonatomic, copy)NSString *firmware;

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

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
            progressBlock:(void (^)(float progress))progressBlock
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.connectQueue, ^{
        NSDictionary *dic = @{};
        if (ValidStr(password) && password.length < 16) {
            //有密码登录
            dic = [self connectDevice:peripheral password:password progressBlock:progressBlock];
        }else {
            //免密登录
            dic = [self connectDevice:peripheral progressBlock:progressBlock];
        }
        
        
        if (![dic[@"success"] boolValue]) {
            [self operationFailedMsg:dic[@"msg"] completeBlock:failedBlock];
            return ;
        }
        if (![self readDeviceType]) {
            [self operationFailedMsg:@"Read Device Type Error" completeBlock:failedBlock];
            return;
        }
        if (![self readManuDate]) {
            [self operationFailedMsg:@"Read Manu Date Error" completeBlock:failedBlock];
            return;
        }
        if (![self readFirmware]) {
            [self operationFailedMsg:@"Read Firmware Error" completeBlock:failedBlock];
            return;
        }
        if (![self readSoftware]) {
            [self operationFailedMsg:@"Read Software Error" completeBlock:failedBlock];
            return;
        }
        
        if ([self.deviceType isEqualToString:@"02"]
            || [self.deviceType isEqualToString:@"03"]
            || [self.deviceType isEqualToString:@"04"]
            || [self.deviceType isEqualToString:@"05"]) {
            //温湿度和光感需要同步时间
            if ([self claSupport]) {
                //时间戳方式同步时间
                if (![self configTimeStamp]) {
                    [self operationFailedMsg:@"Config Date Error" completeBlock:failedBlock];
                    return;
                }
            }else {
                if (![self syncTimeToDevice]) {
                    [self operationFailedMsg:@"Config Date Error" completeBlock:failedBlock];
                    return;
                }
            }
        }
        self.password = password;
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral password:(NSString *)password progressBlock:(void (^)(float progress))progressBlock {
    __block NSDictionary *connectResult = @{};
    
    [[MKBXPCentralManager shared] connectPeripheral:peripheral password:password progressBlock:progressBlock sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (NSDictionary *)connectDevice:(CBPeripheral *)peripheral progressBlock:(void (^)(float progress))progressBlock {
    __block NSDictionary *connectResult = @{};
    
    [[MKBXPCentralManager shared] connectPeripheral:peripheral progressBlock:progressBlock sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        connectResult = @{
            @"success":@(YES),
        };
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        connectResult = @{
            @"success":@(NO),
            @"msg":SafeStr(error.userInfo[@"errorInfo"]),
        };
        dispatch_semaphore_signal(self.semaphore);
    }];
    
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return connectResult;
}

- (BOOL)readDeviceType {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readDeviceTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSString *deviceType = returnData[@"result"][@"deviceType"];
        if (deviceType.length > 2) {
            deviceType = [deviceType substringWithRange:NSMakeRange(deviceType.length - 2, 2)];
        }
        self.deviceType = deviceType;
        self.passwordVerification = ([MKBXPCentralManager shared].lockState == mk_bxp_lockStateOpen);
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
        NSString *date = [returnData[@"result"][@"productionDate"] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        [MKBXPConnectManager shared].newVersion = ([date integerValue] >= 20210101);
        
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
        NSString *tempFirmware = returnData[@"result"][@"firmware"];
        NSRange range = [tempFirmware rangeOfString:@"_V"];
        if (range.location != NSNotFound) {
            // 截取 "_V" 之后的子字符串
            self.firmware = [tempFirmware substringFromIndex:range.location + range.length];
        }
        
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

- (BOOL)syncTimeToDevice {
    __block BOOL success = NO;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *dateList = [date componentsSeparatedByString:@"-"];
    
    MKBXPDeviceTimeDataModel *dateModel = [[MKBXPDeviceTimeDataModel alloc] init];
    dateModel.year = [dateList[0] integerValue];
    dateModel.month = [dateList[1] integerValue];
    dateModel.day = [dateList[2] integerValue];
    dateModel.hour = [dateList[3] integerValue];
    dateModel.minutes = [dateList[4] integerValue];
    dateModel.seconds = [dateList[5] integerValue];
    
    [MKBXPInterface bxp_configDeviceTime:dateModel sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTimeStamp {
    __block BOOL success = NO;
    long long recordTime = [[NSDate date] timeIntervalSince1970];
    [MKBXPInterface bxp_configTimeStamp:recordTime sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (void)clearParams {
    self.password = @"";
    self.deviceType = @"";
    self.newVersion = NO;
    self.software = @"";
    self.firmware = @"";
}

- (BOOL)claSupport {
    if (!ValidStr(self.software) || !ValidStr(self.firmware)) {
        return NO;
    }
    if (![self.software isEqualToString:@"BXP-CL-a"]) {
        return NO;
    }
    NSString *firmwareVersion = [self.firmware stringByReplacingOccurrencesOfString:@"." withString:@""];
    firmwareVersion = [firmwareVersion stringByReplacingOccurrencesOfString:@"V" withString:@""];
    return ([firmwareVersion integerValue] >= 206);
}

#pragma mark - private method
- (void)operationFailedMsg:(NSString *)msg completeBlock:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        [[MKBXPCentralManager shared] disconnect];
        [self clearParams];
        if (block) {
            NSError *error = [[NSError alloc] initWithDomain:@"connectDevice"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":SafeStr(msg)}];
            block(error);
        }
    });
}

#pragma mark - getter
- (dispatch_queue_t)connectQueue {
    if (!_connectQueue) {
        _connectQueue = dispatch_queue_create("com.moko.connectQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _connectQueue;
}

- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

@end
