//
//  MKSlider.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlider.h"

@implementation MKSlider

- (instancetype)init{
    if (self = [super init]) {
        [self setThumbImage:[LOADIMAGE(@"sliderThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateNormal];
        [self setThumbImage:[LOADIMAGE(@"sliderThumbIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                   forState:UIControlStateHighlighted];
        [self setMinimumTrackImage:[LOADIMAGE(@"sliderMinimumTrackIcon", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero]
                          forState:UIControlStateNormal];
        [self setMaximumTrackImage:[LOADIMAGE(@"sliderMaximumTrackImage", @"png") resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    }
    return self;
}

@end
