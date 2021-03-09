//
//  MKBXPScanTLMCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPScanTLMCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKBXPBaseBeacon.h"

static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;

#define msgFont MKFont(12.f)

@interface MKBXPScanTLMCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 TLM
 */
@property (nonatomic, strong)UILabel *typeLabel;

/**
 Battery Voltage
 */
@property (nonatomic, strong)UILabel *batteryMsgLabel;

/**
 电池电量
 */
@property (nonatomic, strong)UILabel *batteryLabel;

/**
 Temperature
 */
@property (nonatomic, strong)UILabel *temperMsgLabel;

/**
 温度值
 */
@property (nonatomic, strong)UILabel *temperatureLabel;

/**
 ADV Count
 */
@property (nonatomic, strong)UILabel *advLabel;

/**
 ADV值
 */
@property (nonatomic, strong)UILabel *advValueLabel;

/**
 Time Since
 */
@property (nonatomic, strong)UILabel *timeSinceLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@end

@implementation MKBXPScanTLMCell

+ (MKBXPScanTLMCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXPScanTLMCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPScanTLMCellIdenty"];
    if (!cell) {
        cell = [[MKBXPScanTLMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPScanTLMCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.batteryMsgLabel];
        [self.contentView addSubview:self.batteryLabel];
        [self.contentView addSubview:self.temperMsgLabel];
        [self.contentView addSubview:self.temperatureLabel];
        [self.contentView addSubview:self.advLabel];
        [self.contentView addSubview:self.advValueLabel];
        [self.contentView addSubview:self.timeSinceLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.batteryMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(120.f);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.batteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryMsgLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.batteryMsgLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.temperMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryMsgLabel.mas_left);
        make.width.mas_equalTo(self.batteryMsgLabel.mas_width);
        make.top.mas_equalTo(self.batteryMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.temperMsgLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.advLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryMsgLabel.mas_left);
        make.width.mas_equalTo(self.batteryMsgLabel.mas_width);
        make.top.mas_equalTo(self.temperMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.advValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.advLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.timeSinceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryMsgLabel.mas_left);
        make.width.mas_equalTo(self.batteryMsgLabel.mas_width);
        make.top.mas_equalTo(self.advLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.batteryLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.timeSinceLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark - setter

- (void)setBeacon:(MKBXPTLMBeacon *)beacon {
    _beacon = beacon;
    if (!_beacon) {
        return;
    }
    if (ValidNum(_beacon.mvPerbit)) {
        [self.batteryLabel setText:[NSString stringWithFormat:@"%@mV",[NSString stringWithFormat:@"%ld",(long)[_beacon.mvPerbit integerValue]]]];
    }
    if (ValidNum(_beacon.temperature)) {
        NSString *temperature = [NSString stringWithFormat:@"%ld",(long)[_beacon.temperature integerValue]];
        [self.temperatureLabel setText:[NSString stringWithFormat:@"%@°C",temperature]];
    }
    if (ValidNum(_beacon.advertiseCount)) {
        [self.advValueLabel setText:[NSString stringWithFormat:@"%ld",(long)[_beacon.advertiseCount integerValue]]];
    }
    if (ValidNum(_beacon.deciSecondsSinceBoot)) {
        [self.timeLabel setText:[self getTimeWithSec:[NSString stringWithFormat:@"%ld",(long)[_beacon.deciSecondsSinceBoot integerValue]]]];
    }
}

#pragma mark - private method

- (NSString *)getTimeWithSec:(NSString *)second{
    NSInteger minutes = floor([second integerValue] / 60);
    NSInteger sec = trunc([second integerValue] - minutes * 60);
    NSInteger hours1 = floor([second integerValue] / (60 * 60));
    minutes = minutes - hours1 * 60;
    NSInteger day = floor(hours1 / 24);
    hours1 = hours1 - 24 * day;
    NSString *time = [NSString stringWithFormat:@"%@D%@h%@m%@s",[NSString stringWithFormat:@"%ld",(long)day],[NSString stringWithFormat:@"%ld",(long)hours1],[NSString stringWithFormat:@"%ld",(long)minutes],[NSString stringWithFormat:@"%ld",(long)sec]];
    return time;
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPScanTLMCell", @"bxp_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"TLM";
    }
    return _typeLabel;
}

- (UILabel *)batteryMsgLabel{
    if (!_batteryMsgLabel) {
        _batteryMsgLabel = [self createLabelWithFont:msgFont];
        _batteryMsgLabel.text = @"Battery Voltage";
    }
    return _batteryMsgLabel;
}

- (UILabel *)batteryLabel{
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:msgFont];
        _batteryLabel.text = @"0mV";
    }
    return _batteryLabel;
}

- (UILabel *)temperMsgLabel{
    if (!_temperMsgLabel) {
        _temperMsgLabel = [self createLabelWithFont:msgFont];
        _temperMsgLabel.text = @"Chip Temperature";
    }
    return _temperMsgLabel;
}

- (UILabel *)temperatureLabel{
    if (!_temperatureLabel) {
        _temperatureLabel = [self createLabelWithFont:msgFont];
        _temperatureLabel.text = @"0°C";
    }
    return _temperatureLabel;
}

- (UILabel *)advLabel{
    if (!_advLabel) {
        _advLabel = [self createLabelWithFont:msgFont];
        _advLabel.text = @"ADV Count";
    }
    return _advLabel;
}

- (UILabel *)advValueLabel{
    if (!_advValueLabel) {
        _advValueLabel = [self createLabelWithFont:msgFont];
        _advValueLabel.text = @"0";
    }
    return _advValueLabel;
}

- (UILabel *)timeSinceLabel{
    if (!_timeSinceLabel) {
        _timeSinceLabel = [self createLabelWithFont:msgFont];
        _timeSinceLabel.text = @"Running time";
    }
    return _timeSinceLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:msgFont];
        _timeLabel.text = @"0s";
    }
    return _timeLabel;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
