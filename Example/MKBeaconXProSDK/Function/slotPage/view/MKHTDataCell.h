//
//  MKHTDataCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKHTDataCell : MKSlotBaseCell

+ (MKHTDataCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, strong, readonly)UITextField *textField;

@end

NS_ASSUME_NONNULL_END
