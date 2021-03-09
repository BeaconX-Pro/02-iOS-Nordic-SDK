//
//  MKBXPTriggerTemperatureView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPTriggerTemperatureViewModel : NSObject

@property (nonatomic, assign)float sliderValue;

@property (nonatomic, assign)BOOL above;

@property (nonatomic, assign)BOOL start;

@end

@protocol MKBXPTriggerTemperatureViewDelegate <NSObject>

- (void)bxp_triggerTemperatureStartStatusChanged:(BOOL)start;

- (void)bxp_triggerTemperatureThresholdValueChanged:(float)sliderValue;

@end

@interface MKBXPTriggerTemperatureView : UIView

@property (nonatomic, weak)id <MKBXPTriggerTemperatureViewDelegate>delegate;

@property (nonatomic, strong)MKBXPTriggerTemperatureViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
