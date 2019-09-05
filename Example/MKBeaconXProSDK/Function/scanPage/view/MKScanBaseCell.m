//
//  MKScanBaseCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanBaseCell.h"

@interface MKScanBaseCell()

/**
 顶部细线
 */
@property (nonatomic, strong)UIView *topLine;

@end

@implementation MKScanBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.topLine];
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _topLine;
}

+ (CGFloat)getCellHeight{
    return 44.0f;
}

@end
