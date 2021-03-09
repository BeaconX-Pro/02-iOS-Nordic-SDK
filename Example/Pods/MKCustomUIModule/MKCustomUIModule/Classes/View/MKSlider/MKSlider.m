//
//  MKSlider.m
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import "MKSlider.h"

#import "MKDeviceDefine.h"

@implementation MKSlider

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setThumbImage:[LOADICON(@"MKCustomUIModule", @"MKSlider", @"mk_customUI_sliderThumbIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateNormal];
        [self setThumbImage:[LOADICON(@"MKCustomUIModule", @"MKSlider", @"mk_customUI_sliderThumbIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[LOADICON(@"MKCustomUIModule", @"MKSlider", @"mk_customUI_sliderMinimumTrackIcon.png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                          forState:UIControlStateNormal];
        [self setMaximumTrackImage:[ LOADICON(@"MKCustomUIModule", @"MKSlider", @"mk_customUI_sliderMaximumTrackImage.png") resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    }
    return self;
}

@end
