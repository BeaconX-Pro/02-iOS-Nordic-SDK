//
//  MKBXPStorageTriggerHumidityView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPStorageTriggerHumidityView : UIView

- (void)updateHumidityValue:(NSString *)humidity;

- (NSString *)getCurrentHumidity;

@end

NS_ASSUME_NONNULL_END
