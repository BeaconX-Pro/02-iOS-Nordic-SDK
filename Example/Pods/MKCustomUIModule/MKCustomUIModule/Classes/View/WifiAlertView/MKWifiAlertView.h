//
//  MKWifiAlertView.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKWifiAlertView : UIView

- (void)showWithConfirmBlock:(void (^)(NSString *ssid, NSString *password))confirmBlock;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
