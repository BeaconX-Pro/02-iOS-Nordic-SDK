//
//  MKBXPStorageTriggerCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPStorageTriggerCellModel : NSObject

/// 当前存储的触发条件
/*
 0:温度，1:湿度，2:温湿度，3:时间
 */
@property (nonatomic, assign)NSInteger triggerType;

/// triggerType=0或者triggerType=2才有值
@property (nonatomic, copy)NSString *temperature;

/// triggerType=1或者triggerType=2才有值
@property (nonatomic, copy)NSString *humidity;

/// triggerType=3才有值
@property (nonatomic, copy)NSString *storageTime;

@end

@interface MKBXPStorageTriggerCell : MKBaseCell

@property (nonatomic, strong)MKBXPStorageTriggerCellModel *dataModel;

+ (MKBXPStorageTriggerCell *)initCellWithTableView:(UITableView *)tableView;

- (NSDictionary *)getStorageTriggerConditions;

@end

NS_ASSUME_NONNULL_END
