//
//  MKScanSearchView.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKScanSearchView : UIView

@property (nonatomic, copy)void (^scanSearchViewDismisBlock)(BOOL update, NSString *text, CGFloat rssi);

/**
 加载页面
 
 @param text 输入框文本
 @param rssiValue 滑竿rssi值
 */
- (void)showWithText:(NSString *)text rssiValue:(NSString *)rssiValue;

@end

NS_ASSUME_NONNULL_END
