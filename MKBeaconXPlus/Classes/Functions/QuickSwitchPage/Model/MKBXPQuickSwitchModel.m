//
//  MKBXPQuickSwitchModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPQuickSwitchModel.h"

#import "MKMacroDefines.h"

#import "MKBXPConnectManager.h"

#import "MKBXPInterface.h"

@interface MKBXPQuickSwitchModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXPQuickSwitchModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readConnectable]) {
            [self operationFailedBlockWithMsg:@"Read Connectable Error" block:failedBlock];
            return;
        }
        if (![self readTriggerLED]) {
            [self operationFailedBlockWithMsg:@"Read Trigger LED notification Error" block:failedBlock];
            return;
        }
        if (![self readTurnOffByButton]) {
            [self operationFailedBlockWithMsg:@"Read Turn off Beacon by button Error" block:failedBlock];
            return;
        }
        if (![self readResetByButton]) {
            [self operationFailedBlockWithMsg:@"Read Reset Beacon by button Error" block:failedBlock];
            return;
        }
        self.passwordVerification = [MKBXPConnectManager shared].passwordVerification;
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readConnectable {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readConnectEnableStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.connectable = [returnData[@"result"][@"connectEnable"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerLED {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readLEDTriggerStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerLED = [returnData[@"result"][@"isOn"] boolValue];
        self.supportLED = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTurnOffByButton {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readButtonPowerStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.turnOffByButton = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readResetByButton {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readResetBeaconByButtonStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.resetByButton = [returnData[@"result"][@"isOn"] boolValue];
        self.supportResetByButton = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"quickSwitchParams"
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
        _readQueue = dispatch_queue_create("quickSwitchQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
