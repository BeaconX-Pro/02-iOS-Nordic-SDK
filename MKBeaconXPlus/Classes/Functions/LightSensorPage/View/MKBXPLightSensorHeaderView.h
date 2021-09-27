//
//  MKBXPLightSensorHeaderView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPLightSensorHeaderViewDelegate <NSObject>

- (void)bxp_lightSensorSyncTime;

@end

@interface MKBXPLightSensorHeaderView : UIView

@property (nonatomic, weak)id <MKBXPLightSensorHeaderViewDelegate>delegate;

- (void)updateSensorStatus:(BOOL)detected;

- (void)updateCurrentTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
