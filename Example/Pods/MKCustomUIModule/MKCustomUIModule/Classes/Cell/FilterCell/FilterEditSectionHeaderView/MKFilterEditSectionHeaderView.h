//
//  MKFilterEditSectionHeaderView.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterEditSectionHeaderViewModel : NSObject

/// sectionHeader所在index
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKFilterEditSectionHeaderViewDelegate <NSObject>

/// 加号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_addButtonPressed:(NSInteger)index;

/// 减号点击事件
/// @param index 所在index
- (void)mk_filterEditSectionHeaderView_subButtonPressed:(NSInteger)index;

@end

@interface MKFilterEditSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong)MKFilterEditSectionHeaderViewModel *dataModel;

@property (nonatomic, weak)id <MKFilterEditSectionHeaderViewDelegate>delegate;

+ (MKFilterEditSectionHeaderView *)initHeaderViewWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
