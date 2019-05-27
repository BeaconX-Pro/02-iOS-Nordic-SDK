//
//  MKDataManager.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKDataManager.h"
#import "MKSlotDataTypeModel.h"

NSString *const MKCentralManagerStateChangedNotification = @"MKCentralManagerStateChangedNotification";
NSString *const MKPeripheralConnectStateChangedNotification = @"MKPeripheralConnectStateChangedNotification";
NSString *const MKPeripheralLockStateChangedNotification = @"MKPeripheralLockStateChangedNotification";

@interface MKDataManager ()<MKBXPCentralManagerDelegate>

/**
 slot的详情数据
 */
@property (nonatomic, strong)NSMutableDictionary *slotDetailDic;

/**
 设置给eddStone的详情数据
 */
@property (nonatomic, strong)NSDictionary *setSlotDetailDic;

@property (nonatomic, strong)MKSlotDataTypeModel *dataModel;

/**
 读取slot详细数据成功回调
 */
@property (nonatomic, copy)void (^readSlotDetailSucBlock)(id returnData);

/**
 读取slot详细数据失败回调
 */
@property (nonatomic, copy)void (^readSlotDetailFailBlock)(NSError *error);

/**
 设置slot详情数据成功回调
 */
@property (nonatomic, copy)void (^setSlotDetailSucBlock)(void);

/**
 设置slot详情数据失败回调
 */
@property (nonatomic, copy)void (^setSlotDetailFailBlock)(NSError *error);

@end

@implementation MKDataManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    if (self = [super init]) {
        [self setStateDelegate];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setStateDelegate)
                                                     name:@"MKCentralDeallocNotification"
                                                   object:nil];
    }
    return self;
}

+ (MKDataManager *)shared {
    static MKDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[MKDataManager alloc] init];
        }
    });
    return manager;
}

#pragma mark - MKBXPCentralManagerDelegate
- (void)bxp_centralStateChanged:(MKBXPCentralManagerState)managerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKCentralManagerStateChangedNotification object:nil];
}

- (void)bxp_peripheralConnectStateChanged:(MKBXPConnectStatus)connectState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralConnectStateChangedNotification object:nil];
}

- (void)bxp_LockStateChanged:(MKBXPLockState)lockState {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKPeripheralLockStateChangedNotification object:nil];
}

#pragma mark - event method
- (void)setStateDelegate{
    [MKBXPCentralManager shared].stateDelegate = self;
}

#pragma mark - Private method

/**
 读取发射功率
 */
- (void)readRadioTxPower{
    WS(weakSelf);
    [MKBXPInterface readBXPRadioTxPowerWithSucBlock:^(id returnData) {
        NSString *radio = returnData[@"result"][@"radioTxPower"];
        [weakSelf.slotDetailDic setObject:radio forKey:@"radioTxPower"];
        [weakSelf readAdvTxPower];
    } failedBlock:^(NSError *error) {
        [weakSelf readAdvTxPower];
    }];
}

/**
 读取广播功率
 */
- (void)readAdvTxPower{
    WS(weakSelf);
    [MKBXPInterface readBXPAdvTxPowerWithSuccessBlock:^(id returnData) {
        NSString *advPower = returnData[@"result"][@"advTxPower"];
        [weakSelf.slotDetailDic setObject:advPower forKey:@"advTxPower"];
        [weakSelf readADVData];
    } failedBlock:^(NSError *error) {
        [weakSelf readADVData];
    }];
}

/**
 读取广播信息
 */
- (void)readADVData{
    WS(weakSelf);
    [MKBXPInterface readBXPAdvDataWithSucBlock:^(id returnData) {
        NSDictionary *resultDic = returnData[@"result"];
        NSDictionary *json = @{
                               @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                               @"advData":(ValidDict(resultDic) ? resultDic : @{}),
                               };
        if (weakSelf.readSlotDetailSucBlock) {
            weakSelf.readSlotDetailSucBlock(json);
        }
    } failedBlock:^(NSError *error) {
        NSDictionary *json = @{
                               @"baseParam":(ValidDict(weakSelf.slotDetailDic) ? weakSelf.slotDetailDic : @{}),
                               @"advData":@{},
                               };
        if (weakSelf.readSlotDetailSucBlock) {
            weakSelf.readSlotDetailSucBlock(json);
        }
    }];
}

- (void)setDetailDataWithFrameType:(slotFrameType)frameType{
    if (!ValidDict(self.setSlotDetailDic) && frameType != slotFrameTypeNull) {
        if (self.setSlotDetailFailBlock) {
            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
                                                        code:-999
                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
            self.setSlotDetailFailBlock(error);
        }
        return;
    }
//    switch (frameType) {
//        case slotFrameTypeTLM:
//            [self setTLMDatas];
//            break;
//
//        case slotFrameTypeUID:
//            [self setUIDDetailDatas];
//            break;
//
//        case slotFrameTypeURL:
//            [self setURLDetailDatas];
//            break;
//
//        case slotFrameTypeInfo:
//            break;
//
//        case slotFrameTypeiBeacon:
//            [self setiBeaconDetailDatas];
//            break;
//
//        case slotFrameTypeNull:
//            [self setNoDatas];
//            break;
//        default:
//            break;
//    }
}

//- (void)setTLMDatas{
//    WS(weakSelf);
//    [MKEddystoneInterface setTLMEddystoneAdvDataWithSucBlock:^(id returnData) {
//        [weakSelf setAdvTxPower];
//    } failedBlock:self.setSlotDetailFailBlock];
//}
//
//- (void)setURLDetailDatas{
//    NSString *content = self.setSlotDetailDic[@"URL"][@"urlContent"];
//    if (ValidStr(self.setSlotDetailDic[@"URL"][@"urlExpansion"])) {
//        content = [content stringByAppendingString:self.setSlotDetailDic[@"URL"][@"urlExpansion"]];
//    }
//    WS(weakSelf);
//    urlHeaderType urlType;
//    /*
//     urlHeaderType1,             //http://www.
//     urlHeaderType2,             //https://www.
//     urlHeaderType3,             //http://
//     urlHeaderType4,             //https://
//     */
//    if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"http://www."]) {
//        urlType = urlHeaderType1;
//    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"https://www."]){
//        urlType = urlHeaderType2;
//    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"http://"]){
//        urlType = urlHeaderType3;
//    }else if ([self.setSlotDetailDic[@"URL"][@"urlHeader"] isEqualToString:@"https://"]){
//        urlType = urlHeaderType4;
//    }else{
//        [self setAdvTxPower];
//        return;
//    }
//    [MKEddystoneInterface setURLEddystoneAdvData:urlType urlContent:content sucBlock:^(id returnData) {
//        [weakSelf setAdvTxPower];
//    } failedBlock:self.setSlotDetailFailBlock];
//}
//
//- (void)setUIDDetailDatas{
//    NSString *nameSpace = self.setSlotDetailDic[@"UID"][@"nameSpace"];
//    NSString *instanceID = self.setSlotDetailDic[@"UID"][@"instanceID"];
//    if (!ValidStr(nameSpace) || !ValidStr(instanceID)) {
//        if (self.setSlotDetailFailBlock) {
//            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
//                                                        code:-999
//                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
//            self.setSlotDetailFailBlock(error);
//        }
//        return;
//    }
//    WS(weakSelf);
//    [MKEddystoneInterface setUIDEddystoneAdvDataWithNameSpace:nameSpace instanceID:instanceID sucBlock:^(id returnData) {
//        [weakSelf setAdvTxPower];
//    } failedBlock:self.setSlotDetailFailBlock];
//}
//
//- (void)setiBeaconDetailDatas{
//    NSString *major = self.setSlotDetailDic[@"iBeacon"][@"major"];
//    NSString *minor = self.setSlotDetailDic[@"iBeacon"][@"minor"];
//    NSString *uuid = self.setSlotDetailDic[@"iBeacon"][@"uuid"];
//    NSString *measurePower = self.setSlotDetailDic[@"baseParam"][@"advTxPower"];
//    if (!ValidStr(major) || !ValidStr(minor) || !ValidStr(uuid) || !ValidStr(measurePower)) {
//        if (self.setSlotDetailFailBlock) {
//            NSError *error = [[NSError alloc] initWithDomain:@"mokoEddStone"
//                                                        code:-999
//                                                    userInfo:@{@"errorInfo":@"To set up the data can not be empty"}];
//            self.setSlotDetailFailBlock(error);
//        }
//        return;
//    }
//
//    WS(weakSelf);
//    [MKEddystoneInterface setiBeaconEddystoneAdvDataWithMajor:[major integerValue] minor:[minor integerValue] uuid:uuid measurePower:labs([measurePower integerValue]) sucBlock:^(id returnData) {
//        [weakSelf setAdvTxPower];
//    } failedBlock:self.setSlotDetailFailBlock];
//}
//
//- (void)setNoDatas{
//    WS(weakSelf);
//    [MKEddystoneInterface setNoDataEddystoneAdvDataWithSucBlock:^(id returnData) {
//        if (weakSelf.setSlotDetailSucBlock) {
//            weakSelf.setSlotDetailSucBlock();
//        }
//    } failedBlock:self.setSlotDetailFailBlock];
//}
//
//- (void)setAdvTxPower{
//    NSString *advTxPower = self.setSlotDetailDic[@"baseParam"][@"advTxPower"];
//    if (!ValidStr(advTxPower)) {
//        [self setRadioTxPower];
//        return;
//    }
//    WS(weakSelf);
//    [MKEddystoneInterface setEddystoneAdvTxPower:[advTxPower integerValue] sucBlock:^(id returnData) {
//        [weakSelf setRadioTxPower];
//    } failedBlock:^(NSError *error) {
//        [weakSelf setRadioTxPower];
//    }];
//}
//
///**
// 设置发射功率
// */
//- (void)setRadioTxPower{
//    NSString *txPower = self.setSlotDetailDic[@"baseParam"][@"txPower"];
//    if (!ValidStr(txPower)) {
//        if (self.setSlotDetailSucBlock) {
//            self.setSlotDetailSucBlock();
//        }
//        return;
//    }
//    WS(weakSelf);
//    [MKEddystoneInterface setEddystoneRadioTxPower:[self getRadioTxPower:txPower] sucBlock:^(id returnData) {
//        if (weakSelf.setSlotDetailSucBlock) {
//            weakSelf.setSlotDetailSucBlock();
//        }
//    } failedBlock:^(NSError *error) {
//        if (weakSelf.setSlotDetailSucBlock) {
//            weakSelf.setSlotDetailSucBlock();
//        }
//    }];
//}

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

/**
 获取指定通道的详细数据,先切换到指定通道，再根据指定通道的数据类型加载不同数据。对于标准的EddStone广播帧(UID、TLM、URL)，根据相关的特征去获取当前活跃通道的广播内容，对于iBeacon和设备信息帧，需要用自定义协议来获取相关信息
 
 @param slotModel slotModel
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)readSlotDetailData:(MKSlotDataTypeModel *)slotModel
              successBlock:(void (^)(id returnData))successBlock
               failedBlock:(void (^)(NSError *error))failedBlock{
    WS(weakSelf);
    self.readSlotDetailSucBlock = nil;
    self.readSlotDetailSucBlock = successBlock;
    self.readSlotDetailFailBlock = nil;
    self.readSlotDetailFailBlock = failedBlock;
    self.dataModel = nil;
    self.dataModel = slotModel;
    [MKBXPInterface setBXPActiveSlot:slotModel.slotIndex sucBlock:^(id returnData) {
        if (slotModel.slotType == slotFrameTypeNull) {
            if (weakSelf.readSlotDetailSucBlock) {
                NSDictionary *json = @{
                                       @"advData":@{
                                               @"frameType":@"70",
                                               }
                                       };
                weakSelf.readSlotDetailSucBlock(json);
            }
            return ;
        }
        [weakSelf readRadioTxPower];
    } failedBlock:^(NSError *error) {
        if (failedBlock) {
            moko_dispatch_main_safe(^{
                failedBlock(error);
            });
        }
    }];
}

/**
 设置slot详情信息
 
 @param slotNo 通道号
 @param slotFrameType 通道数据类型
 @param detailData 详情数据
 @param successBlock 成功回调
 @param failedBlock 失败回调
 */
- (void)setSlotDetailData:(bxpActiveSlotNo )slotNo
            slotFrameType:(slotFrameType )slotFrameType
               detailData:(NSDictionary *)detailData
             successBlock:(void (^)(void))successBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
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
    self.setSlotDetailSucBlock = nil;
    self.setSlotDetailSucBlock = successBlock;
    self.setSlotDetailFailBlock = nil;
    self.setSlotDetailFailBlock = failedBlock;
    WS(weakSelf);
//    [MKEddystoneInterface setEddystoneActiveSlot:slotNo sucBlock:^(id returnData) {
//        weakSelf.setSlotDetailDic = detailData;
//        [weakSelf setDetailDataWithFrameType:slotFrameType];
//    } failedBlock:^(NSError *error) {
//        if (failedBlock) {
//            dispatch_main_async_safe(^{
//                failedBlock(error);
//            });
//        }
//    }];
}

#pragma mark - setter & getter
- (NSMutableDictionary *)slotDetailDic{
    if (!_slotDetailDic) {
        _slotDetailDic = [NSMutableDictionary dictionary];
    }
    return _slotDetailDic;
}

@end
