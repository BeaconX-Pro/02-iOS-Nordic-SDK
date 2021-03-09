//
//  MKBXPScanInfoCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPScanInfoCellDelegate <NSObject>

- (void)connectPeripheralWithIndex:(NSInteger)index;

@end

@class MKBXPScanBeaconModel;
@interface MKBXPScanInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXPScanBeaconModel *beacon;

@property (nonatomic, weak)id <MKBXPScanInfoCellDelegate>delegate;

+ (MKBXPScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
