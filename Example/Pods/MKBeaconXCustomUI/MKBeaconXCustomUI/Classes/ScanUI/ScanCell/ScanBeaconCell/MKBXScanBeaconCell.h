//
//  MKBXScanBeaconCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanBeaconCellModel : NSObject

//RSSI@1m
@property (nonatomic, copy)NSString *rssi1M;
@property (nonatomic, copy)NSString *txPower;
//Advetising Interval
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

/**
 rssi
 */
@property (nonatomic, copy)NSString *rssi;

@end

@interface MKBXScanBeaconCell : MKBaseCell

@property (nonatomic, strong)MKBXScanBeaconCellModel *dataModel;

+ (MKBXScanBeaconCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeightWithUUID:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
