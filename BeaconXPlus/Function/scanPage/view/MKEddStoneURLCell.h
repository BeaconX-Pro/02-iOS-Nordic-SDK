//
//  MKEddStoneURLCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKEddStoneURLCell : MKScanBaseCell

+ (MKEddStoneURLCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKBXPURLBeacon *beacon;

@end

NS_ASSUME_NONNULL_END
