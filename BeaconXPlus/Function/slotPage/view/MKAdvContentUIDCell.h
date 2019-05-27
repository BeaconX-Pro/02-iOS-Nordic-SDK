//
//  MKAdvContentUIDCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvContentBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvContentUIDCell : MKAdvContentBaseCell

+ (MKAdvContentUIDCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
