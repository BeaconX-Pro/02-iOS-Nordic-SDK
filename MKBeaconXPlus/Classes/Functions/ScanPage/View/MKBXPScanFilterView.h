//
//  MKBXPScanFilterView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/9.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPScanFilterView : UIView

/// 加载扫描过滤页面
/// @param name 过滤的名字
/// @param macAddress 过滤的mac地址
/// @param rssi 过滤的rssi
/// @param searchBlock 回调
+ (void)showSearchName:(NSString *)name
            macAddress:(NSString *)macAddress
                  rssi:(NSInteger)rssi
           searchBlock:(void (^)(NSString *searchName, NSString *searchMacAddress, NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
