//
//  MKBXPScanBeaconCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKBXPiBeacon;
@interface MKBXPScanBeaconCell : MKBaseCell

@property (nonatomic, strong)MKBXPiBeacon *beacon;

+ (MKBXPScanBeaconCell *)initCellWithTableView:(UITableView *)tableView;

+ (CGFloat)getCellHeightWithUUID:(NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
