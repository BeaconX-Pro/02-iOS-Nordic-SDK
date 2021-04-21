//
//  MKBXPSlotConfigModel.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotConfigModel.h"

#import "MKMacroDefines.h"

#import "MKBXPInterface.h"
#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPSlotConfigCellProtocol.h"

@interface MKBXPSlotConfigModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

/// 固件某个版本存在bug，如果将设备的通道广播间隔设置得跟当前设备广播间隔值一样，则固件会产生bug，所以当读取回来的跟要设置的值一样的情况下，不再设置广播间隔给设备
@property (nonatomic, copy)NSString *originAdvInterval;

@end

@implementation MKBXPSlotConfigModel

- (void)readWithSucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configActiveSlot:self.slotIndex]) {
            [self operationFailedBlockWithMsg:@"Config Active Slot Error" block:failedBlock];
            return;
        }
        if (self.slotType == mk_bxp_slotFrameTypeNull) {
            //当前通道为NO DATA
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        if (![self readTxPower]) {
            [self operationFailedBlockWithMsg:@"Read Tx Power Error" block:failedBlock];
            return;
        }
        if (![self readRssi]) {
            [self operationFailedBlockWithMsg:@"Read RSSI Error" block:failedBlock];
            return;
        }
        if (![self readAdvInterval]) {
            [self operationFailedBlockWithMsg:@"Read Adv Interval Error" block:failedBlock];
            return;
        }
        if (![self readSlotAdvData]) {
            [self operationFailedBlockWithMsg:@"Read Slot Adv Data Error" block:failedBlock];
            return;
        }
        if (![self readTriggerConditions]) {
            [self operationFailedBlockWithMsg:@"Read Trigger Conditions Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configSlotParams:(NSDictionary *)params
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configActiveSlot:self.slotIndex]) {
            [self operationFailedBlockWithMsg:@"Config Active Slot Error" block:failedBlock];
            return;
        }
        if (self.slotType == mk_bxp_slotFrameTypeNull) {
            //NO DATA
            if (![self configAdvNoDatas]) {
                [self operationFailedBlockWithMsg:@"Config Adv Data Error" block:failedBlock];
                return;
            }
            moko_dispatch_main_safe(^{
                if (sucBlock) {
                    sucBlock();
                }
            });
            return;
        }
        BOOL advResult = NO;
        if (self.slotType == mk_bxp_slotFrameTypeBeacon) {
            //当前广播通道设置为iBeacon
            advResult = [self configBeacon:params[bxp_slotConfig_advContentType]];
        }else if (self.slotType == mk_bxp_slotFrameTypeUID) {
            //当前广播通道设置为UID
            advResult = [self configUID:params[bxp_slotConfig_advContentType]];
        }else if (self.slotType == mk_bxp_slotFrameTypeURL) {
            //当前广播通道设置为URL
            advResult = [self configURL:params[bxp_slotConfig_advContentType]];
        }else if (self.slotType == mk_bxp_slotFrameTypeTLM) {
            //当前广播通道设置为TLM
            advResult = [self configTLM];
        }else if (self.slotType == mk_bxp_slotFrameTypeInfo) {
            //当前广播通道设置为Info
            advResult = [self configDeviceInfo:params[bxp_slotConfig_advContentType]];
        }else if (self.slotType == mk_bxp_slotFrameTypeThreeASensor) {
            //当前广播通道设置为三轴
            advResult = [self configThressAxis];
        }else if (self.slotType == mk_bxp_slotFrameTypeTHSensor) {
            //当前广播通道设置为温湿度
            advResult = [self configHTAdvData];
        }
        if (!advResult) {
            [self operationFailedBlockWithMsg:@"Config Adv Data Error" block:failedBlock];
            return;
        }
        if (![self configTxPower:[params[bxp_slotConfig_advParamType][@"txPower"] integerValue]]) {
            [self operationFailedBlockWithMsg:@"Config Tx Power Error" block:failedBlock];
            return;
        }
        if (self.slotType != mk_bxp_slotFrameTypeTLM) {
            if (![self configRssi:[params[bxp_slotConfig_advParamType][@"rssi"] integerValue]]) {
                [self operationFailedBlockWithMsg:@"Config Rssi Error" block:failedBlock];
                return;
            }
        }
        if (![self.originAdvInterval isEqualToString:params[bxp_slotConfig_advParamType][@"interval"]]) {
            if (![self configAdvInterval:[params[bxp_slotConfig_advParamType][@"interval"] integerValue]]) {
                [self operationFailedBlockWithMsg:@"Config Interval Error" block:failedBlock];
                return;
            }
        }
        if (![self configTriggerConditions:params[bxp_slotConfig_advTriggerType]]) {
            [self operationFailedBlockWithMsg:@"Config Adv Trigger Error" block:failedBlock];
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
- (BOOL)configActiveSlot:(NSInteger)slotIndex {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configActiveSlot:slotIndex sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTxPower {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readRadioTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.txPower = [self getTxPowerValue:returnData[@"result"][@"radioTxPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTxPower:(NSInteger)txPower {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configRadioTxPower:txPower sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRssi {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readAdvTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rssi0M = [returnData[@"result"][@"advTxPower"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRssi:(NSInteger)rssi {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configAdvTxPower:rssi sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readAdvInterval {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readAdvIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger tempInterval = [returnData[@"result"][@"advertisingInterval"] integerValue] / 100;
        self.advInterval = [NSString stringWithFormat:@"%ld",(long)tempInterval];
        self.originAdvInterval = [NSString stringWithFormat:@"%ld",(long)tempInterval];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configAdvInterval:(NSInteger)interval {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configAdvInterval:interval sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSlotAdvData {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advSlotData = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerConditions {
    __block BOOL success = NO;
    [MKBXPInterface bxp_readTriggerConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerConditions = returnData[@"result"];
        self.triggerIsOn = ![returnData[@"result"][@"type"] isEqualToString:@"00"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 广播通道设置

- (BOOL)configAdvNoDatas {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configNODATAAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeacon:(NSDictionary *)dic {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configiBeaconAdvDataWithMajor:[dic[@"major"] integerValue] minor:[dic[@"minor"] integerValue] uuid:dic[@"uuid"] sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUID:(NSDictionary *)dic {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configUIDAdvDataWithNameSpace:dic[@"nameSpace"] instanceID:dic[@"instanceID"] sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configURL:(NSDictionary *)dic {
    __block BOOL success = NO;
    
    //@"http://www.",@"https://www.",@"http://",@"https://""
    mk_bxp_urlHeaderType headerType = mk_bxp_urlHeaderType1;
    if ([dic[@"urlHeader"] isEqualToString:@"https://www."]) {
        headerType = mk_bxp_urlHeaderType2;
    }else if ([dic[@"urlHeader"] isEqualToString:@"http://"]) {
        headerType = mk_bxp_urlHeaderType3;
    }else if ([dic[@"urlHeader"] isEqualToString:@"https://"]) {
        headerType = mk_bxp_urlHeaderType4;
    }
    
    [MKBXPInterface bxp_configURLAdvData:headerType urlContent:[dic[@"urlContent"] stringByAppendingString:dic[@"urlExpansion"]] sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTLM {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTLMAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceInfo:(NSDictionary *)dic {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configDeviceInfoAdvDataWithDeviceName:dic[@"deviceName"] sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configThressAxis {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configThreeAxisAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configHTAdvData {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configHTAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - 触发设置
- (BOOL)configTriggerConditions:(NSDictionary *)conditions {
    BOOL isOn = [conditions[@"isOn"] boolValue];
    if (!isOn) {
        //关闭触发
        return [self closeTrigger];
    }
    NSDictionary *triggerParams = conditions[@"triggerParams"];
    if ([triggerParams[@"triggerType"] isEqualToString:@"01"]) {
        //温度触发
        return [self configTriggerConditionsWithTemperature:[triggerParams[@"conditions"][@"above"] boolValue]
                                                temperature:[triggerParams[@"conditions"][@"temperature"] integerValue]
                                           startAdvertising:[triggerParams[@"conditions"][@"start"] boolValue]];
    }
    if ([triggerParams[@"triggerType"] isEqualToString:@"02"]) {
        //湿度触发
        return [self configTriggerConditionsWithHudimity:[triggerParams[@"conditions"][@"above"] boolValue]
                                                humidity:[triggerParams[@"conditions"][@"humidity"] integerValue]
                                        startAdvertising:[triggerParams[@"conditions"][@"start"] boolValue]];
    }
    if ([triggerParams[@"triggerType"] isEqualToString:@"03"]) {
        //双击触发
        return [self configTriggerConditionsWithDoubleTap:[triggerParams[@"conditions"][@"time"] integerValue]
                                                    start:[triggerParams[@"conditions"][@"start"] boolValue]];
    }
    if ([triggerParams[@"triggerType"] isEqualToString:@"04"]) {
        //三击触发
        return [self configTriggerConditionsWithTripleTap:[triggerParams[@"conditions"][@"time"] integerValue]
                                                    start:[triggerParams[@"conditions"][@"start"] boolValue]];
    }
    //移动触发
    return [self configTriggerConditionsWithMoves:[triggerParams[@"conditions"][@"time"] integerValue]
                                            start:[triggerParams[@"conditions"][@"start"] boolValue]];
}

- (BOOL)closeTrigger {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsNoneWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditionsWithTemperature:(BOOL)above
                                   temperature:(NSInteger)temperature
                              startAdvertising:(BOOL)start {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsWithTemperature:above temperature:temperature startAdvertising:start sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditionsWithHudimity:(BOOL)above
                                   humidity:(NSInteger)humidity
                           startAdvertising:(BOOL)start {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsWithHudimity:above humidity:humidity startAdvertising:start sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditionsWithDoubleTap:(NSInteger)time
                                       start:(BOOL)start {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsWithDoubleTap:time start:start sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditionsWithTripleTap:(NSInteger)time
                                       start:(BOOL)start {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsWithTripleTap:time start:start sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerConditionsWithMoves:(NSInteger)time
                                   start:(BOOL)start {
    __block BOOL success = NO;
    [MKBXPInterface bxp_configTriggerConditionsWithMoves:time start:start sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (NSInteger)getTxPowerValue:(NSString *)power {
    if ([power isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([power isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([power isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([power isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([power isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([power isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([power isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([power isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([power isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 0;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"slotConfigParams"
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
        _readQueue = dispatch_queue_create("slotConfigParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
