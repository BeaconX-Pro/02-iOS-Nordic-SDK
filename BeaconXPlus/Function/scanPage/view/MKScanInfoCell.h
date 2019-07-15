//
//  MKScanInfoCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKScanInfoCellDelegate <NSObject>

- (void)connectPeripheralWithIndex:(NSInteger)index;

@end

@class MKScanBeaconModel;
@interface MKScanInfoCell : UITableViewCell

+ (MKScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKScanBeaconModel *beacon;

@property (nonatomic, weak)id <MKScanInfoCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
