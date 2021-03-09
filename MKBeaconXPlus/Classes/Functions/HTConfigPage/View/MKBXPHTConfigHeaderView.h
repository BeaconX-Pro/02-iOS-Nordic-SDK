//
//  MKBXPHTConfigHeaderView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPHTConfigHeaderView : UIView

- (void)updateTemperature:(NSString *)temperature humidity:(NSString *)humidity;

- (void)updateSamplingInterval:(NSString *)interval;

- (NSString *)getSamplingInterval;

@end

NS_ASSUME_NONNULL_END
