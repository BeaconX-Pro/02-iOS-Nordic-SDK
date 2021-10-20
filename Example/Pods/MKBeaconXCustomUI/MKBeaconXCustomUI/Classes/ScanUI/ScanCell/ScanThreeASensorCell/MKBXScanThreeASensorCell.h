//
//  MKBXScanThreeASensorCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanThreeASensorCellModel : NSObject

//RSSI@0m
@property (nonatomic, copy)NSString *rssi0M;
@property (nonatomic, copy)NSString *txPower;
//Broadcast interval, Unit: 100ms
@property (nonatomic, copy)NSString *interval;
/**
 Sampling rate,@"00":1Hz,@"01":10Hz,@"02":25Hz,@"03":50Hz,@"04":100Hz,
 @"05":200Hz,@"06":400Hz,@"07":1344Hz,@"08":1620Hz,@"09":5376Hz
 */
@property (nonatomic, copy)NSString *samplingRate;
/**
 3-axis accelerometer scale,@"00":±2g,@"01"":±4g,@"02":±8g,@"03":±16g
 */
@property (nonatomic, copy)NSString *accelerationOfGravity;
//3-axis accelerometer sensitivity
@property (nonatomic, copy)NSString *sensitivity;

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

/// 是否解析三轴数据，对于广播数据不包含mac地址的认为是旧固件，不需要解析转换成mg。
@property (nonatomic, assign)BOOL needParse;

@end

@interface MKBXScanThreeASensorCell : MKBaseCell

@property (nonatomic, strong)MKBXScanThreeASensorCellModel *dataModel;

+ (MKBXScanThreeASensorCell *)initCellWithTable:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
