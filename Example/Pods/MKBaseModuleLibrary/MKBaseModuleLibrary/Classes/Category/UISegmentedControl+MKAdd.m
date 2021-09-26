//
//  UISegmentedControl+MKAdd.m
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2021/9/6.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "UISegmentedControl+MKAdd.h"

@implementation UISegmentedControl (MKAdd)

- (void)mk_setTintColor:(UIColor *)tintColor {
    // UISegmentedControl has changed in iOS 13 and setting the tint
    // color now has no effect.
    if (@available(iOS 13, *)) {
        UIImage *tintColorImage = [self imageWithColor:tintColor];
        // Must set the background image for normal to something (even clear) else the rest won't work

        [self setBackgroundImage:[self imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[self imageWithColor:[tintColor colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage forState:UIControlStateSelected|UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName: tintColor} forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
        [self setDividerImage:tintColorImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.layer.borderWidth = 1;
        self.layer.borderColor= [tintColor CGColor];
    }else {
        self.tintColor = tintColor;
    }
}

- (UIImage *)imageWithColor: (UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
