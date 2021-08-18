//
//  MKBXScanUIDCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanUIDCellModel : NSObject

//RSSI@0m
@property (nonatomic, copy)NSString *txPower;
@property (nonatomic, copy)NSString *namespaceId;
@property (nonatomic, copy)NSString *instanceId;

@end

@interface MKBXScanUIDCell : MKBaseCell

@property (nonatomic, strong)MKBXScanUIDCellModel *dataModel;

+ (MKBXScanUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
