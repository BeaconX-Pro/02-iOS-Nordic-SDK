//
//  MKBXPSlotConfigInfoCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXPSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigInfoCellModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@end

@interface MKBXPSlotConfigInfoCell : MKBaseCell<MKBXPSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXPSlotConfigInfoCellModel *dataModel;

+ (MKBXPSlotConfigInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
