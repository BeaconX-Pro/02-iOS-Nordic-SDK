//
//  MKTriggerTemperatureView.h
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKSlider;
@interface MKTriggerTemperatureView : UIView

@property (nonatomic, strong, readonly)MKSlider *temperSlider;

@property (nonatomic, strong, readonly)UILabel *sliderValueLabel;;

@property (nonatomic, assign, readonly)BOOL above;

@property (nonatomic, assign, readonly)BOOL start;

- (void)updateAbove:(BOOL)above start:(BOOL)start;

@end

NS_ASSUME_NONNULL_END
