//
//  MKBXSlotConfigUIDCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotConfigUIDCellModel : NSObject

@property (nonatomic, copy)NSString *nameSpace;

@property (nonatomic, copy)NSString *instanceID;

@end

@interface MKBXSlotConfigUIDCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXSlotConfigUIDCellModel *dataModel;

+ (MKBXSlotConfigUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
