//
//  MKAdvContentDeviceCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvContentBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvContentDeviceCell : MKAdvContentBaseCell

@property (nonatomic, strong)NSDictionary *dataDic;

+ (MKAdvContentDeviceCell *)initCellWithTable:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
