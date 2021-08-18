//
//  MKBXScanPageAdopter.h
//  MKBeaconXProTLA
//
//  Created by aa on 2021/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanPageAdopter : NSObject

/// 根据不同的dataModel加载cell
/*
 目前支持
 MKBXScanBeaconCell:        iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 MKBXScanHTCell:            温湿度广播帧(对应的dataModel是MKBXScanHTCellModel类型)
 MKBXScanThreeASensorCell:  三轴传感器广播帧(对应的dataModel是MKBXScanThreeASensorCellModel类型)
 MKBXScanTLMCell:           TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 MKBXScanUIDCell:           UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 MKBXScanURLCell:           URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 如果不是其中的一种，则返回一个初始化的UITableViewCell
 */
/// @param tableView tableView
/// @param dataModel dataModel
+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel;

/// 根据不同的dataModel返回cell的高度
/*
 目前支持
 根据UUID动态计算:        iBeacon广播帧(对应的dataModel是MKBXScanBeaconCellModel类型)
 105.f:                 温湿度广播帧(对应的dataModel是MKBXScanHTCellModel类型)
 140.f:                 三轴传感器广播帧(对应的dataModel是MKBXScanThreeASensorCellModel类型)
 110.f:                 TLM广播帧(对应的dataModel是MKBXScanTLMCellModel类型)
 85.f:                  UID广播帧(对应的dataModel是MKBXScanUIDCellModel类型)
 70.f:                  URL广播帧(对应的dataModel是MKBXScanURLCellModel类型)
 如果不是其中的一种，则返回0
 */
/// @param indexPath indexPath
+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel;

/// 根据传进来的model确定在设备信息帧的dataArray里面的排序号
/*
 0:         MKBXScanUIDCellModel
 1:         MKBXScanURLCellModel
 2:         MKBXScanTLMCellModel
 3:         MKBXScanBeaconCellModel
 4:         MKBXScanThreeASensorCellModel
 5:         MKBXScanHTCellModel
 否则返回6，排在最后面
 */
/// @param dataModel dataModel
+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel;

@end

NS_ASSUME_NONNULL_END
