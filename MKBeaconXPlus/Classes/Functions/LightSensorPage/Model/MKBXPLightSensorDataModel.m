//
//  MKBXPLightSensorDataModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/9/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPLightSensorDataModel.h"

#import "MKMacroDefines.h"

#import "MKBXPInterface.h"

@interface MKBXPLightSensorDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXPLightSensorDataModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readDetected]) {
            [self operationFailedBlockWithMsg:@"Read Detected Error" block:failedBlock];
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

#pragma mark - interface
- (BOOL)readDetected {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readLightSensorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.detected = [returnData[@"result"][@"status"] isEqualToString:@"01"];
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
        NSArray *dateList = [returnData[@"result"][@"deviceTime"] componentsSeparatedByString:@"-"];
        self.date = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",dateList[2],dateList[1],dateList[0],dateList[3],dateList[4],dateList[5]];
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
        NSError *error = [[NSError alloc] initWithDomain:@"lightSensorParams"
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
        _readQueue = dispatch_queue_create("lightSensorQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
