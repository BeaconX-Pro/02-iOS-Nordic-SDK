//
//  MKPageControl.m
//  mokoBaseModule
//
//  Created by aa on 2018/10/15.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKPageControl.h"

@implementation MKPageControl

- (void)updateDots{
    for (NSInteger i = 0; i < [self.subviews count]; i ++) {
        UIView * dot = [self.subviews objectAtIndex:i];
        for (UIView * view in dot.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [view removeFromSuperview];
            }
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:dot.bounds];
        if (self.currentPage == i) {
            if (self.activeImage) {
                imageView.image = self.activeImage;
            }
        }
        else{
            if (self.inactiveImage) {
                imageView.image = self.inactiveImage;
            }
        }
        [dot addSubview:imageView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end
