//
//  MKScanBeaconModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScanBeaconModel : NSObject

/**
 设备信息帧，这个需要单列出来
 */
@property (nonatomic, strong)MKBXPDeviceInfoBeacon *infoBeacon;

/**
 peripheral 标识符
 */
@property (nonatomic, copy)NSString *identifier;

/**
 信号值强度,会动态变化，TLM、iBeacon、UID、URL、info都会改变这个值
 */
@property (nonatomic, strong)NSNumber *rssi;

/**
 当前model所在的section
 */
@property (nonatomic, assign)NSInteger index;

/**
 UID、URL、iBeacon、TLM数据帧
 */
@property (nonatomic, strong)NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
