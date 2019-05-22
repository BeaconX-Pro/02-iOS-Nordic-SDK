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
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

@end
