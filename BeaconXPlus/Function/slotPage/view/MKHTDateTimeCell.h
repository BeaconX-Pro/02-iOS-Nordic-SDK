//
//  MKHTDateTimeCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/31.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKHTDateTimeCellDelegate <NSObject>

- (void)bxpUpdateDeviceTime;

@end

@interface MKHTDateTimeCell : MKSlotBaseCell

+ (MKHTDateTimeCell *)initCellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong, readonly)UILabel *timeLabel;
@property (nonatomic, weak)id <MKHTDateTimeCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
