//
//  MKSearchButton.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/25.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSearchButtonDataModel : NSObject

/// 显示的标题
@property (nonatomic, copy)NSString *placeholder;

/// 显示的搜索关键字(设备名称、MAC地址的一部分或者全部字段)
@property (nonatomic, copy)NSString *searchKey;

/// 过滤的RSSI值
@property (nonatomic, assign)NSInteger searchRssi;

/// 过滤的最小RSSI值，当searchRssi == minSearchRssi时，不显示searchRssi搜索条件
@property (nonatomic, assign)NSInteger minSearchRssi;

@end

@protocol MKSearchButtonDelegate <NSObject>

/// 搜索按钮点击事件
- (void)mk_scanSearchButtonMethod;

/// 搜索按钮右侧清除按钮点击事件
- (void)mk_scanSearchButtonClearMethod;

@end

@interface MKSearchButton : UIControl

@property (nonatomic, strong)MKSearchButtonDataModel *dataModel;

@property (nonatomic, weak)id <MKSearchButtonDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
