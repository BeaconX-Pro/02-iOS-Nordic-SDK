//
//  MKBXScanHTCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanHTCellModel : NSObject

@property (nonatomic, copy)NSString *txPower;
//RSSI@0m
@property (nonatomic, copy)NSString *rssi0M;
//Broadcast interval,Unit:100ms
@property (nonatomic, copy) NSString *interval;
//Temperature
@property (nonatomic, copy) NSString *temperature;
//Humidity
@property (nonatomic, copy) NSString *humidity;

@end

@interface MKBXScanHTCell : MKBaseCell

@property (nonatomic, strong)MKBXScanHTCellModel *dataModel;

+ (MKBXScanHTCell *)initCellWithTable:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
