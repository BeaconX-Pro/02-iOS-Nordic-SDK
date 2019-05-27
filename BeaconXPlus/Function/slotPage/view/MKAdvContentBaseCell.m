//
//  MKAdvContentBaseCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvContentBaseCell.h"

static CGFloat const iconWidth = 22.f;
static CGFloat const iconHeight = 22.f;
static CGFloat const offset_X = 15.f;

@interface MKAdvContentBaseCell()

@property (nonatomic, strong)UIImageView *icon;
@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKAdvContentBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(iconHeight);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark -
- (CGFloat)minTopOffset{
    return 35.f;
}

- (CGFloat)minOffset_X{
    return offset_X;
}

#pragma mark - setter & getter
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADIMAGE(@"slot_advContent", @"png");
    }
    return _icon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Adv Content";
    }
    return _msgLabel;
}

@end
