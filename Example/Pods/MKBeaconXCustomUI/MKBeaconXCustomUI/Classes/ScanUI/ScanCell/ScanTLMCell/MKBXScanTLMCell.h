//
//  MKBXScanTLMCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXScanTLMCellModel : NSObject

@property (nonatomic, copy)NSString *version;
@property (nonatomic, copy)NSString *mvPerbit;
@property (nonatomic, copy)NSString *temperature;
@property (nonatomic, copy)NSString *advertiseCount;
@property (nonatomic, copy)NSString *deciSecondsSinceBoot;

@end

@interface MKBXScanTLMCell : MKBaseCell

@property (nonatomic, strong)MKBXScanTLMCellModel *dataModel;

+ (MKBXScanTLMCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
