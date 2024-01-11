//
//  MKFilterBeaconCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKFilterBeaconCellDelegate <NSObject>

- (void)mk_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKFilterBeaconCellDelegate>delegate;

+ (MKFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
