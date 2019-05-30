//
//  MKSlotConfigManager.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/28.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotConfigManager.h"
#import "MKSlotDataTypeModel.h"

@interface MKSlotConfigManager ()

@property (nonatomic, strong)dispatch_queue_t configQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKSlotConfigManager

#pragma mark - public method
- (void)readSlotDetailData:(MKSlotDataTypeModel *)slotModel
              successBlock:(void (^)(id returnData))successBlock
               failedBlock:(void (^)(NSError *error))failedBlock{
    dispatch_async(self.configQueue, ^{
        if (![self configActiveSlot:slotModel.slotIndex]) {
            if (failedBlock) {
                moko_dispatch_main_safe(^{
                    failedBlock([self configError]);
                });
            }
            return ;
        }
        if (slotModel.slotType == slotFrameTypeNull) {
            if (successBlock) {
                moko_dispatch_main_safe(^{
                    NSDictionary *json = @{
                                           @"advData":@{@"frameType":@"ff"}
                                           };
                    successBlock(json);
                });
            }
            return;
        }
        NSString *radioTxPower = [self readRadioTxPower];
        NSString *advTxPower = [self readAdvTxPower];
        NSString *advInterval = [self readAdvInterval];
        NSDictionary *advDic = @{};
        NSMutableDictionary *baseParams = [NSMutableDictionary dictionary];
        [baseParams setObject:radioTxPower forKey:@"radioTxPower"];
        [baseParams setObject:advTxPower forKey:@"advTxPower"];
        [baseParams setObject:advInterval forKey:@"advInterval"];
        if (slotModel.slotType == slotFrameTypeThreeASensor) {
            NSDictionary *tempAdvDic = [self readAdvData];
            BOOL advertisingIsOn = [tempAdvDic[@"frameType"] isEqualToString:@"60"];
            [baseParams setObject:@(advertisingIsOn) forKey:@"advertisingIsOn"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self readThreeAxisParams]];
            [dic setObject:@"60" forKey:@"frameType"];
            advDic = dic;
        }else if (slotModel.slotType == slotFrameTypeTHSensor) {
            
        }else {
            advDic = [self readAdvData];
        }
        NSDictionary *resultDic = @{
                                    @"baseParam":baseParams,
                                    @"advData":advDic,
                                    };
        if (successBlock) {
            moko_dispatch_main_safe(^{
                successBlock(resultDic);
            });
        }
    });
}

- (void)setSlotDetailData:(bxpActiveSlotNo)slotNo
            slotFrameType:(slotFrameType)slotFrameType
               detailData:(NSDictionary *)detailData
             successBlock:(void (^)(void))successBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!ValidDict(detailData) && slotFrameType != slotFrameTypeNull) {
        //NO DATA的情况下，不需要具体详情数据
        if (failedBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            failedBlock(error);
        }
        return;
    }
    dispatch_async(self.configQueue, ^{
        if (![self configActiveSlot:slotNo]) {
            if (failedBlock) {
                moko_dispatch_main_safe(^{
                    failedBlock([self configError]);
                });
            }
            return ;
        }
        BOOL advDataSuccess = NO;
        if (slotFrameType == slotFrameTypeTLM) {
            advDataSuccess = [self configTLMAdvDatas];
        }else if (slotFrameType == slotFrameTypeUID) {
            advDataSuccess = [self configUIDAdvDatas:detailData[@"UID"][@"nameSpace"] instanceID:detailData[@"UID"][@"instanceID"]];
        }else if (slotFrameType == slotFrameTypeURL) {
            advDataSuccess = [self configURLAdvDatas:detailData[@"URL"][@"urlHeader"] content:detailData[@"URL"][@"urlContent"] expansion:detailData[@"URL"][@"urlExpansion"]];
        }else if (slotFrameType == slotFrameTypeiBeacon) {
            advDataSuccess = [self configiBeacon:detailData[@"iBeacon"][@"uuid"] major:[detailData[@"iBeacon"][@"major"] integerValue] minor:[detailData[@"iBeacon"][@"minor"] integerValue]];
        }else if (slotFrameType == slotFrameTypeNull) {
            advDataSuccess = [self configNoDatas];
        }else if (slotFrameType == slotFrameTypeInfo) {
            advDataSuccess = [self configDeviceName:detailData[@"deviceInfo"][@"deviceName"]];
        }else if (slotFrameType == slotFrameTypeThreeASensor) {
            advDataSuccess = [self configThreeAxisAdvData:[detailData[@"advertising"] boolValue]];
            if (advDataSuccess) {
                [self configThreeAxisDataParams:[detailData[@"threeAxis"][@"dataRate"] integerValue] acceleration:[detailData[@"threeAxis"][@"scale"] integerValue] sensitivity:[detailData[@"threeAxis"][@"sensitivity"] integerValue]];
            }
        }
        if (!advDataSuccess) {
            if (failedBlock) {
                moko_dispatch_main_safe(^{
                    failedBlock([self configError]);
                });
            }
            return;
        }
        [self configAdvTxPower:[detailData[@"baseParam"][@"advTxPower"] integerValue]];
        [self configRadioTxPower:[self getRadioTxPower:detailData[@"baseParam"][@"txPower"]]];
        [self configAdvInterval:[detailData[@"baseParam"][@"advInterval"] integerValue]];
        if (successBlock) {
            moko_dispatch_main_safe(^{
                successBlock();
            });
        }
    });
}

- (slotRadioTxPower)getRadioTxPower:(NSString *)txPower{
    if ([txPower isEqualToString:@"4dBm"]) {
        return slotRadioTxPower4dBm;
    }else if ([txPower isEqualToString:@"3dBm"]){
        return slotRadioTxPower3dBm;
    }else if ([txPower isEqualToString:@"0dBm"]){
        return slotRadioTxPower0dBm;
    }else if ([txPower isEqualToString:@"-4dBm"]){
        return slotRadioTxPowerNeg4dBm;
    }else if ([txPower isEqualToString:@"-8dBm"]){
        return slotRadioTxPowerNeg8dBm;
    }else if ([txPower isEqualToString:@"-12dBm"]){
        return slotRadioTxPowerNeg12dBm;
    }else if ([txPower isEqualToString:@"-16dBm"]){
        return slotRadioTxPowerNeg16dBm;
    }else if ([txPower isEqualToString:@"-20dBm"]){
        return slotRadioTxPowerNeg20dBm;
    }else if ([txPower isEqualToString:@"-40dBm"]){
        return slotRadioTxPowerNeg40dBm;
    }
    return slotRadioTxPower0dBm;
}

#pragma mark - interface
- (BOOL)configActiveSlot:(bxpActiveSlotNo)slotNo {
    __block BOOL success = NO;
    [MKBXPInterface setBXPActiveSlot:slotNo sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSString *)readRadioTxPower {
    __block NSString *radioTxPower = @"";
    [MKBXPInterface readBXPRadioTxPowerWithSucBlock:^(id  _Nonnull returnData) {
        radioTxPower = returnData[@"result"][@"radioTxPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return radioTxPower;
}

- (BOOL)configRadioTxPower:(slotRadioTxPower)txPower {
    __block BOOL success = NO;
    [MKBXPInterface setBXPRadioTxPower:txPower sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSString *)readAdvTxPower {
    __block NSString *advTxPower = @"";
    [MKBXPInterface readBXPAdvTxPowerWithSuccessBlock:^(id  _Nonnull returnData) {
        advTxPower = returnData[@"result"][@"advTxPower"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return advTxPower;
}

- (BOOL)configAdvTxPower:(NSInteger)advTxPower {
    __block BOOL success = NO;
    [MKBXPInterface setBXPAdvTxPower:advTxPower sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSDictionary *)readAdvData {
    __block NSDictionary *advData = @{};
    [MKBXPInterface readBXPAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        advData = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return advData;
}

- (NSString *)readAdvInterval {
    __block NSString *interval = @"";
    [MKBXPInterface readBXPAdvIntervalWithSuccessBlock:^(id  _Nonnull returnData) {
        interval = returnData[@"result"][@"advertisingInterval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return interval;
}

- (NSDictionary *)readThreeAxisParams {
    __block NSDictionary *dataDic = @{};
    [MKBXPInterface readBXPThreeAxisDataParamsWithSuccessBlock:^(id  _Nonnull returnData) {
        dataDic = returnData[@"result"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return dataDic;
}

- (BOOL)configAdvInterval:(NSInteger)interval {
    __block BOOL success = NO;
    [MKBXPInterface setBXPAdvInterval:interval sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTLMAdvDatas {
    __block BOOL success = NO;
    [MKBXPInterface setBXPTLMAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUIDAdvDatas:(NSString *)namespace instanceID:(NSString *)instanceID {
    __block BOOL success = NO;
    [MKBXPInterface setBXPUIDAdvDataWithNameSpace:namespace instanceID:instanceID sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configURLAdvDatas:(NSString *)urlHeader content:(NSString *)content expansion:(NSString *)expansion {
    __block BOOL success = NO;
    NSString *tempContent = content;
    if (ValidStr(expansion)) {
        tempContent = [tempContent stringByAppendingString:expansion];
    }
    urlHeaderType urlType = urlHeaderType1;
    if ([urlHeader isEqualToString:@"https://www."]){
        urlType = urlHeaderType2;
    }else if ([urlHeader isEqualToString:@"http://"]){
        urlType = urlHeaderType3;
    }else if ([urlHeader isEqualToString:@"https://"]){
        urlType = urlHeaderType4;
    }
    [MKBXPInterface setBXPURLAdvData:urlType urlContent:tempContent sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configiBeacon:(NSString *)uuid major:(NSInteger)major minor:(NSInteger)minor {
    __block BOOL success = NO;
    [MKBXPInterface setBXPiBeaconAdvDataWithMajor:major minor:minor uuid:uuid sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNoDatas {
    __block BOOL success = NO;
    [MKBXPInterface setBXPNODATAAdvDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDeviceName:(NSString *)deviceName {
    __block BOOL success = NO;
    [MKBXPInterface setBXPDeviceInfoAdvDataWithDeviceName:deviceName sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configThreeAxisAdvData:(BOOL)advertising {
    __block BOOL success = NO;
    [MKBXPInterface setBXPThreeAxisAdvData:advertising sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configThreeAxisDataParams:(threeAxisDataRate)dataRate
                     acceleration:(threeAxisDataAG)acceleration
                      sensitivity:(NSInteger)sensitivity {
    __block BOOL success = NO;
    [MKBXPInterface setBXPThreeAxisDataParams:dataRate acceleration:acceleration sensitivity:sensitivity sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (NSError *)configError {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.bxpSDKDomain"
                                                code:-999
                                            userInfo:@{@"errorInfo":@"config data error"}];
    return error;
}

#pragma mark - setter & getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)configQueue {
    if (!_configQueue) {
        _configQueue = dispatch_queue_create("slotConfigParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _configQueue;
}

@end