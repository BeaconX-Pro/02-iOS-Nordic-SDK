//
//  MKEddystoneThreeASensorCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKEddystoneThreeASensorCell : MKScanBaseCell

+ (MKEddystoneThreeASensorCell *)initCellWithTable:(UITableView *)tableView;

@property (nonatomic, strong)MKBXPThreeASensorBeacon *beacon;

@end

NS_ASSUME_NONNULL_END
