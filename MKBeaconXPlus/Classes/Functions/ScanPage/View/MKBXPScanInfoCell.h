//
//  MKBXPScanInfoCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2025/9/28.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@class MKBXPScanInfoCellModel;


@protocol MKBXPScanInfoCellDelegate <NSObject>

- (void)mk_bxp_connectPeripheral:(MKBXPScanInfoCellModel *)deviceModel;

@end

@interface MKBXPScanInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXPScanInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXPScanInfoCellDelegate>delegate;

+ (MKBXPScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
