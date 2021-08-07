//
//  MKFilterConditionCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/7/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterConditionCellModel : NSObject

@property (nonatomic, assign)NSInteger conditionIndex;

/// 当前按钮是否可用
@property (nonatomic, assign)BOOL enable;

@end

@protocol MKFilterConditionCellDelegate <NSObject>

/// 关于发生改变
/// @param conditionIndex 0:And,1:Or
- (void)mk_filterConditionsChanged:(NSInteger)conditionIndex;

@end

@interface MKFilterConditionCell : MKBaseCell

@property (nonatomic, strong)MKFilterConditionCellModel *dataModel;

@property (nonatomic, weak)id <MKFilterConditionCellDelegate>delegate;

+ (MKFilterConditionCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
