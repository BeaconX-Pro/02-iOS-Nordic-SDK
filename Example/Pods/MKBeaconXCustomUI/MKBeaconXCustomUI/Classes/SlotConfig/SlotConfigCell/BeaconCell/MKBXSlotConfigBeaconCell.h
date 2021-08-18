//
//  MKBXSlotConfigBeaconCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotConfigBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@end

@interface MKBXSlotConfigBeaconCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXSlotConfigBeaconCellModel *dataModel;

+ (MKBXSlotConfigBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
