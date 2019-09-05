//
//  MKConnectDeviceProgressView.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKConnectDeviceProgressView : UIView

- (void)showConnectAlertViewWithTitle:(NSString *)title;

- (void)setProgress:(CGFloat)progress;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
