//
//  MKScanInfoCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^connectPeripheralBlock)(NSInteger section);

@class MKScanBeaconModel;
@interface MKScanInfoCell : UITableViewCell

+ (MKScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKScanBeaconModel *beacon;

@property (nonatomic, copy)connectPeripheralBlock connectPeripheralBlock;

@end

NS_ASSUME_NONNULL_END
