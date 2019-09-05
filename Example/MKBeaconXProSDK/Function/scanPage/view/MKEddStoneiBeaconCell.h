//
//  MKEddStoneiBeaconCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKEddStoneiBeaconCell : MKScanBaseCell

+ (MKEddStoneiBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKBXPiBeacon *beacon;

+ (CGFloat)getCellHeightWithUUID:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
