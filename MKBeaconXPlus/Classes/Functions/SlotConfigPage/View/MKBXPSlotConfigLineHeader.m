//
//  MKBXPSlotConfigLineHeader.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotConfigLineHeader.h"

#import "MKMacroDefines.h"

@implementation MKBXPSlotConfigLineHeader

+ (MKBXPSlotConfigLineHeader *)initHeaderViewWithTableView:(UITableView *)tableView{
    MKBXPSlotConfigLineHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MKBXPSlotConfigLineHeaderIdenty"];
    if (!view) {
        view = [[MKBXPSlotConfigLineHeader alloc] initWithReuseIdentifier:@"MKBXPSlotConfigLineHeaderIdenty"];
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
