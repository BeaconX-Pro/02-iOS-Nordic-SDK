//
//  MKSwitchStatusCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKIconInfoCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKSwitchStatusCellDelegate <NSObject>

- (void)needChangedCellSwitchStatus:(BOOL)isOn row:(NSInteger)row;

@end

@interface MKSwitchStatusCell : MKIconInfoCell

+ (MKSwitchStatusCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, weak)id <MKSwitchStatusCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
