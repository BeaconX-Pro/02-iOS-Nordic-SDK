//
//  MKAxisParametersCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAxisParametersCell : MKSlotBaseCell

@property (nonatomic, strong)NSDictionary *dataDic;

+ (MKAxisParametersCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
