//
//  MKBaseCollectionView.m
//  mokoBaseModule
//
//  Created by aa on 2019/4/11.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseCollectionView.h"

@implementation MKBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

@end
