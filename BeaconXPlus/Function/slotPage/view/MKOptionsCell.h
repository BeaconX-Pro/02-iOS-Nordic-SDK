//
//  MKOptionsCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKSlotDataTypeModel;
@interface MKOptionsCell : UITableViewCell

+ (MKOptionsCell *)initCellWithTabelView:(UITableView *)tableView;

@property (nonatomic, strong)MKSlotDataTypeModel *dataModel;

@property (nonatomic, copy)void (^configSlotDataBlock)(MKSlotDataTypeModel *dataModel);

@end

NS_ASSUME_NONNULL_END
