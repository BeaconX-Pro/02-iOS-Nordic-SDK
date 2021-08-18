//
//  MKBXScanInfoCell.h
//  MKBeaconXProTLA_Example
//
//  Created by aa on 2021/8/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXScanInfoCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanInfoCell : MKBaseCell

@property (nonatomic, strong)id <MKBXScanInfoCellProtocol>dataModel;

@property (nonatomic, weak)id <MKBXScanInfoCellDelegate>delegate;

+ (MKBXScanInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
