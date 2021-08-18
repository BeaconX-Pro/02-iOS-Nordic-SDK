//
//  MKBXPSlotConfigAdvParamsCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXEnumerateDefine.h"

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigAdvParamsCellModel : NSObject

@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, assign)NSInteger rssiValue;

@property (nonatomic, assign)NSInteger txPower;

@property (nonatomic, assign)mk_bx_slotFrameType slotType;

@end

@interface MKBXPSlotConfigAdvParamsCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXPSlotConfigAdvParamsCellModel *dataModel;

+ (MKBXPSlotConfigAdvParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
