//
//  MKEddystoneHTCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKEddystoneHTCell.h"

static CGFloat const msgLabelWidth = 60.f;
static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;

#define msgFont MKFont(12.f)

@interface MKEddystoneHTCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,T&H
 */
@property (nonatomic, strong)UILabel *typeLabel;

/**
 RSSI@0m
 */
@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *rssiValueLabel;

/**
 发射功率
 */
@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UILabel *tempLabel;

@property (nonatomic, strong)UILabel *tempValueLabel;

@property (nonatomic, strong)UILabel *humidityLabel;

@property (nonatomic, strong)UILabel *humidityValueLabel;

@end

@implementation MKEddystoneHTCell

+ (MKEddystoneHTCell *)initCellWithTable:(UITableView *)tableView {
    MKEddystoneHTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKEddystoneHTCellIdenty"];
    if (!cell) {
        cell = [[MKEddystoneHTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKEddystoneHTCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.rssiValueLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.txPowerValueLabel];
        [self.contentView addSubview:self.tempLabel];
        [self.contentView addSubview:self.tempValueLabel];
        [self.contentView addSubview:self.humidityLabel];
        [self.contentView addSubview:self.humidityValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.rssiValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.tempValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.tempLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.humidityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.tempLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.humidityValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.humidityLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark -
- (void)setBeacon:(MKBXPTHSensorBeacon *)beacon {
    _beacon = nil;
    _beacon = beacon;
    if (!_beacon) {
        return;
    }
    self.rssiValueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)[beacon.rssi0M integerValue],@"dBm"];
    self.txPowerValueLabel.text = [NSString stringWithFormat:@"%ld %@",(long)[beacon.rssi integerValue],@"dBm"];
    self.tempValueLabel.text = [beacon.temperature stringByAppendingString:@"℃"];
    self.humidityValueLabel.text = [beacon.humidity stringByAppendingString:@"%"];
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"littleBluePoint", @"png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.text = @"T&H";
    }
    return _typeLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:msgFont];
        _rssiLabel.text = @"RSSI@0m:";
    }
    return _rssiLabel;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [self createLabelWithFont:msgFont];
    }
    return _rssiValueLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:msgFont];
        _txPowerLabel.textColor = RGBCOLOR(153, 153, 153);
        _txPowerLabel.text = @"Tx Power";
    }
    return _txPowerLabel;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [self createLabelWithFont:msgFont];
    }
    return _txPowerValueLabel;
}

- (UILabel *)tempLabel {
    if (!_tempLabel) {
        _tempLabel = [self createLabelWithFont:msgFont];
        _tempLabel.textColor = RGBCOLOR(153, 153, 153);
        _tempLabel.text = @"Temperature";
    }
    return _tempLabel;
}

- (UILabel *)tempValueLabel {
    if (!_tempValueLabel) {
        _tempValueLabel = [self createLabelWithFont:msgFont];
    }
    return _tempValueLabel;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [self createLabelWithFont:msgFont];
        _humidityLabel.textColor = RGBCOLOR(153, 153, 153);
        _humidityLabel.text = @"Humidity";
    }
    return _humidityLabel;
}

- (UILabel *)humidityValueLabel {
    if (!_humidityValueLabel) {
        _humidityValueLabel = [self createLabelWithFont:msgFont];
    }
    return _humidityValueLabel;
}

@end
