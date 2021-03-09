//
//  MKBXPSlotConfigUIDCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXPSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigUIDCellModel : NSObject

@property (nonatomic, copy)NSString *nameSpace;

@property (nonatomic, copy)NSString *instanceID;

@end

@interface MKBXPSlotConfigUIDCell : MKBaseCell<MKBXPSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXPSlotConfigUIDCellModel *dataModel;

+ (MKBXPSlotConfigUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
