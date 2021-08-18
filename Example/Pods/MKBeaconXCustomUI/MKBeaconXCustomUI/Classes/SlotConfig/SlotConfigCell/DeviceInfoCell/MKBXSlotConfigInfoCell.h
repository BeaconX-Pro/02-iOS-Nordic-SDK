//
//  MKBXSlotConfigInfoCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotConfigInfoCellModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

/// 广播名称最小长度，默认1个字符长度
@property (nonatomic, assign)NSInteger nameMinLen;

/// 广播名称最大长度，默认20个字符
@property (nonatomic, assign)NSInteger nameMaxLen;

@end

@interface MKBXSlotConfigInfoCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXSlotConfigInfoCellModel *dataModel;

+ (MKBXSlotConfigInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
