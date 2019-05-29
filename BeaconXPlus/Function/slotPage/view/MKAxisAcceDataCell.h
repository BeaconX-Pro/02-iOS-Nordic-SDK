//
//  MKAxisAcceDataCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKAxisAcceDataCellDelegate <NSObject>

- (void)updateThreeAxisNotifyStatus:(BOOL)notify;

@end

@interface MKAxisAcceDataCell : MKSlotBaseCell

+ (MKAxisAcceDataCell *)initCellWithTableView:(UITableView *)table;

@property (nonatomic, strong)NSDictionary *axisData;

@property (nonatomic, weak)id <MKAxisAcceDataCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
