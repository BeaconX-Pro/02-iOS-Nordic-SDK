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
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
