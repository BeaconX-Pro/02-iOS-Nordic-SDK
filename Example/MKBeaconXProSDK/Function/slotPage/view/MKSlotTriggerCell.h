//
//  MKSlotTriggerCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKSlotTriggerCellDelegate <NSObject>

- (void)triggerSwitchStatusChanged:(BOOL)isOn;

@end

@interface MKSlotTriggerCell : MKSlotBaseCell

+ (MKSlotTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)NSDictionary *dataDic;

@property (nonatomic, weak)id <MKSlotTriggerCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
