//
//  MKBXTriggerTemperatureView.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTriggerTemperatureViewModel : NSObject

@property (nonatomic, assign)float sliderValue;

@property (nonatomic, assign)BOOL above;

@property (nonatomic, assign)BOOL start;

@end

@protocol MKBXTriggerTemperatureViewDelegate <NSObject>

- (void)mk_bx_triggerTemperatureStartStatusChanged:(BOOL)start;

- (void)mk_bx_triggerTemperatureThresholdValueChanged:(float)sliderValue;

@end

@interface MKBXTriggerTemperatureView : UIView

@property (nonatomic, weak)id <MKBXTriggerTemperatureViewDelegate>delegate;

@property (nonatomic, strong)MKBXTriggerTemperatureViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
