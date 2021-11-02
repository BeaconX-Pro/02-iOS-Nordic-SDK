//
//  MKBaseTableView.m
//  mokoBaseModule
//
//  Created by aa on 2019/4/11.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseTableView.h"

@implementation MKBaseTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        if (@available(iOS 15.0, tvOS 15, *)) {
            self.sectionHeaderTopPadding = 0;
        }
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
