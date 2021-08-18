//
//  MKBXPScanPageAdopter.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXPBaseBeacon;
@class MKBXScanInfoCellModel;
@interface MKBXPScanPageAdopter : NSObject



/// 将扫描到的beacon数据转换成对应的cellModel
/*
 如果beacon是:
 MKBXPiBeacon:                   iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 MKBXPTHSensorBeacon:            温湿度广播帧(对应的dataModel是MKBXScanHTCellModel类型)
 MKBXPThreeASensorBeacon:        三轴传感器广播帧(对应的dataModel是MKBXScanThreeASensorCellModel类型)
 MKBXPTLMBeacon:                 TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 MKBXPUIDBeacon:                 UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 MKBXPURLBeacon:                 URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 如果不是其中的一种，则返回nil
 */
/// @param beacon 扫描到的beacon数据
+ (NSObject *)parseBeaconDatas:(MKBXPBaseBeacon *)beacon;

+ (MKBXScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXPBaseBeacon *)beacon;

/// 新扫描到的数据已经在列表的数据源中存在，则需要将扫描到的数据结合列表数据源中的数据进行处理
/*
 如果beacon是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID、三轴、温湿度中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到exsitModel的广播帧数组(advertiseList)里面去
 */
/// @param exsitModel 列表数据源中已经存在的数据
/// @param beacon 刚扫描到的beacon数据
+ (void)updateInfoCellModel:(MKBXScanInfoCellModel *)exsitModel beaconData:(MKBXPBaseBeacon *)beacon;

@end

NS_ASSUME_NONNULL_END
