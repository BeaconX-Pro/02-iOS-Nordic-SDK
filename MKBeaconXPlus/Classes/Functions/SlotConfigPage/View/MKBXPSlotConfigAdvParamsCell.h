//
//  MKBXPSlotConfigAdvParamsCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXPSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigAdvParamsCellModel : NSObject

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, assign)NSInteger rssiValue;

@property (nonatomic, assign)NSInteger txPower;

/// 对于beacon，rssi@1m,其他的都是rssi@0m.
@property (nonatomic, assign)BOOL isBeacon;

@end

@interface MKBXPSlotConfigAdvParamsCell : MKBaseCell<MKBXPSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXPSlotConfigAdvParamsCellModel *dataModel;

+ (MKBXPSlotConfigAdvParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
