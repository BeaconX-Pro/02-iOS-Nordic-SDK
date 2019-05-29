//
//  MKBaseParamsCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const MKSlotBaseCellTLMType = @"MKSlotBaseCellTLMType";
static NSString *const MKSlotBaseCellUIDType = @"MKSlotBaseCellUIDType";
static NSString *const MKSlotBaseCellURLType = @"MKSlotBaseCellURLType";
static NSString *const MKSlotBaseCelliBeaconType = @"MKSlotBaseCelliBeaconType";
static NSString *const MKSlotBaseCellDeviceInfoType = @"MKSlotBaseCellDeviceInfoType";
static NSString *const MKSlotBaseCellAxisAcceDataType = @"MKSlotBaseCellAxisAcceDataType";

@interface MKBaseParamsCell : MKSlotBaseCell

+ (MKBaseParamsCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, copy)NSString *baseCellType;

@end

NS_ASSUME_NONNULL_END
