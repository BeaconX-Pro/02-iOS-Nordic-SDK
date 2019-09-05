//
//  MKScanSearchButton.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScanSearchButton : UIControl

/**
 当前搜索条件，如果是nil或者@[]，则认为关闭了搜索条件
 */
@property (nonatomic, strong)NSMutableArray *searchConditions;

/**
 用户点击了清除筛选条件按钮回调
 */
@property (nonatomic, copy)void (^clearSearchConditionsBlock)(void);

/**
 用户点击了搜索按钮回调
 */
@property (nonatomic, copy)void (^searchButtonPressedBlock)(void);

@end

NS_ASSUME_NONNULL_END
