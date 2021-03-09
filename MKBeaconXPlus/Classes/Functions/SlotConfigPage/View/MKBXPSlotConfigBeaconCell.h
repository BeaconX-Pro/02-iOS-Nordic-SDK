//
//  MKBXPSlotConfigBeaconCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXPSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@end

@interface MKBXPSlotConfigBeaconCell : MKBaseCell<MKBXPSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXPSlotConfigBeaconCellModel *dataModel;

+ (MKBXPSlotConfigBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
