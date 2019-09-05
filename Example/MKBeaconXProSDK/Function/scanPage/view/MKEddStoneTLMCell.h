//
//  MKEddStoneTLMCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKEddStoneTLMCell : MKScanBaseCell

+ (MKEddStoneTLMCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKBXPTLMBeacon *beacon;

@end

NS_ASSUME_NONNULL_END
