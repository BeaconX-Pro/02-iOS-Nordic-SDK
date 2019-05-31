//
//  MKHTDateTimeCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/31.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKHTDateTimeCell.h"

@interface MKHTDateTimeCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIButton *updateButton;

@end

@implementation MKHTDateTimeCell

+ (MKHTDateTimeCell *)initCellWithTableView:(UITableView *)tableView {
    MKHTDateTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKHTDateTimeCellIdenty"];
    if (!cell) {
        cell = [[MKHTDateTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKHTDateTimeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.updateButton];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.updateButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)updateButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxpUpdateDeviceTime)]) {
        [self.delegate bxpUpdateDeviceTime];
    }
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"slot_htUpdateTimeIcon", @"png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Update Date & Time";
    }
    return _msgLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = DEFAULT_TEXT_COLOR;
        _timeLabel.font = MKFont(15.f);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UIButton *)updateButton{
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [_updateButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        [_updateButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_updateButton.titleLabel setFont:MKFont(15.f)];
        [_updateButton.layer setMasksToBounds:YES];
        [_updateButton.layer setCornerRadius:10.f];
        [_updateButton addTapAction:self selector:@selector(updateButtonPressed)];
    }
    return _updateButton;
}

@end
