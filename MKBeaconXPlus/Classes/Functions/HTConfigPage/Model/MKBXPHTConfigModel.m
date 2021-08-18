//
//  MKBXPHTConfigModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPHTConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXPInterface.h"

@implementation MKBXPHTStorageConditionsModel
@end

@interface MKBXPDeviceTimeDataModel : NSObject<MKBXPDeviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

@implementation MKBXPDeviceTimeDataModel
@end

@interface MKBXPHTConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXPHTConfigModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSamplingRate]) {
            [self operationFailedBlockWithMsg:@"Read Sampling Rate Error" block:failedBlock];
            return;
        }
        if (![self readHTStorageConditions]) {
            [self operationFailedBlockWithMsg:@"Read Storage Conditions Error" block:failedBlock];
            return;
        }
        if (![self readDeviceTime]) {
            [self operationFailedBlockWithMsg:@"Read Device Time Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDeviceTimeWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configDeviceTime]) {
            [self operationFailedBlockWithMsg:@"Config Device Time Error" block:failedBlock];
            return;
        }
        if (![self readDeviceTime]) {
            [self operationFailedBlockWithMsg:@"Read Device Time Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSamplingInterval:(NSInteger)interval
                     triggerConditions:(MKBXPHTStorageConditionsModel *)conditionsModel
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configSamplingRate:interval]) {
            [self operationFailedBlockWithMsg:@"Config Sampling Rate Error" block:failedBlock];
            return;
        }
        if (![self configHTStorageConditions:conditionsModel]) {
            [self operationFailedBlockWithMsg:@"Config Storage Conditions Error" block:failedBlock];
            return;
        }
        if (![self configDeviceTime]) {
            [self operationFailedBlockWithMsg:@"Config Device Time Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readSamplingRate {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readHTSamplingRateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.samplingInterval = returnData[@"result"][@"samplingRate"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSamplingRate:(NSInteger)interval {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configHTSamplingRate:interval sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHTStorageConditions {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readHTStorageConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerType = [returnData[@"result"][@"functionType"] integerValue];
        self.temperature = returnData[@"result"][@"temperature"];
        self.humidity = returnData[@"result"][@"humidity"];
        self.storageTime = returnData[@"result"][@"storageTime"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configHTStorageConditions:(MKBXPHTStorageConditionsModel *)conditionsModel {
    __block BOOL success = NO;
    
    [MKBXPInterface bxp_configHTStorageConditions:conditionsModel sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDeviceTime {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readDeviceTimeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSString *deviceTime = returnData[@"result"][@"deviceTime"];
        NSArray *dateList = [deviceTime componentsSeparatedByString:@"-"];
        self.date = [NSString stringWithFormat:@"%@/%@/%@",dateList[2],dateList[1],dateList[0]];
        self.time = [NSString stringWithFormat:@"%@:%@:%@",dateList[3],dateList[4],dateList[5]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceTime {
    __block BOOL success = NO;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *toTimeZone = [NSTimeZone localTimeZone];
    //转换后源日期与世界标准时间的偏移量
    NSInteger toGMTOffset = [toTimeZone secondsFromGMTForDate:[NSDate date]];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:toGMTOffset];
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

#pragma mark - private method

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"HTConfig"
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
        _readQueue = dispatch_queue_create("HTConfigQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
