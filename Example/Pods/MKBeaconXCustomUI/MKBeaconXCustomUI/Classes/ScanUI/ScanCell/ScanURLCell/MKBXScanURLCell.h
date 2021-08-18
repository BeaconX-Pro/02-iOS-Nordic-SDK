//
//  MKBXScanURLCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanURLCellModel : NSObject

//RSSI@0m
@property (nonatomic, copy)NSString *txPower;
//URL Content
@property (nonatomic, copy)NSString *shortUrl;

@end

@interface MKBXScanURLCell : MKBaseCell

@property (nonatomic, strong)MKBXScanURLCellModel *dataModel;

+ (MKBXScanURLCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
