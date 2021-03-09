//
//  MKSearchConditionsView.h
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/25.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSearchConditionsView : UIView

/// 显示搜索条件设置页面
/// @param searchKey 当前搜索的关键字
/// @param rssi 当前搜索的rssi值
/// @param minRssi 当前搜索的最小rssi
/// @param searchBlock 用户点击了DONE按钮回调事件
+ (void)showSearchKey:(NSString *)searchKey
                 rssi:(NSInteger)rssi
              minRssi:(NSInteger)minRssi
          searchBlock:(void (^)(NSString *searchKey, NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
