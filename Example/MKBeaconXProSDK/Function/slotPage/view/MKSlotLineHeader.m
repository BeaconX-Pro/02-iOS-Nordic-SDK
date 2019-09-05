//
//  MKSlotLineHeader.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotLineHeader.h"

static NSString *const MKSlotLineHeaderIdenty = @"MKSlotLineHeaderIdenty";

@implementation MKSlotLineHeader

+ (MKSlotLineHeader *)initHeaderViewWithTableView:(UITableView *)tableView{
    MKSlotLineHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MKSlotLineHeaderIdenty];
    if (!view) {
        view = [[MKSlotLineHeader alloc] initWithReuseIdentifier:MKSlotLineHeaderIdenty];
    }
    return view;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:RGBCOLOR(242, 242, 242)];
    }
    return self;
}

@end
