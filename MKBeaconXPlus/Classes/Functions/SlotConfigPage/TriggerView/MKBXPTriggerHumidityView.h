//
//  MKBXPTriggerHumidityView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPTriggerHumidityViewModel : NSObject

@property (nonatomic, assign)float sliderValue;

@property (nonatomic, assign)BOOL above;

@property (nonatomic, assign)BOOL start;

@end

@protocol MKBXPTriggerHumidityViewDelegate <NSObject>

- (void)bxp_triggerHumidityStartStatusChanged:(BOOL)start;

- (void)bxp_triggerHumidityThresholdValueChanged:(float)sliderValue;

@end

@interface MKBXPTriggerHumidityView : UIView

@property (nonatomic, weak)id <MKBXPTriggerHumidityViewDelegate>delegate;

@property (nonatomic, strong)MKBXPTriggerHumidityViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
