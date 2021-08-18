//
//  MKBXTriggerHumidityView.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTriggerHumidityViewModel : NSObject

@property (nonatomic, assign)float sliderValue;

@property (nonatomic, assign)BOOL above;

@property (nonatomic, assign)BOOL start;

@end

@protocol MKBXTriggerHumidityViewDelegate <NSObject>

- (void)mk_bx_triggerHumidityStartStatusChanged:(BOOL)start;

- (void)mk_bx_triggerHumidityThresholdValueChanged:(float)sliderValue;

@end

@interface MKBXTriggerHumidityView : UIView

@property (nonatomic, weak)id <MKBXTriggerHumidityViewDelegate>delegate;

@property (nonatomic, strong)MKBXTriggerHumidityViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
