//
//  MKTriggerHumidityView.h
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKSlider;
@interface MKTriggerHumidityView : UIView

@property (nonatomic, assign, readonly)BOOL above;

@property (nonatomic, assign, readonly)BOOL start;

@property (nonatomic, strong, readonly)MKSlider *humiditySlider;

@property (nonatomic, strong, readonly)UILabel *sliderValueLabel;

- (void)updateAbove:(BOOL)above start:(BOOL)start;

@end

NS_ASSUME_NONNULL_END
