//
//  MKHTDataCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKHTDataCell.h"

@interface MKHTDataCell ()

@property (nonatomic, strong)UIImageView *temperIcon;

@property (nonatomic, strong)UILabel *temperLabel;

@property (nonatomic, strong)UILabel *temperValueLabel;

@property (nonatomic, strong)UILabel *temperUnitLabel;

@property (nonatomic, strong)UIImageView *humiIcon;

@property (nonatomic, strong)UILabel *humiLabel;

@property (nonatomic, strong)UILabel *humiValueLabel;

@property (nonatomic, strong)UILabel *humiUnitLabel;

@property (nonatomic, strong)UILabel *periodLabel;

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UILabel *periodUnitLabel;

@end

@implementation MKHTDataCell

+ (MKHTDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKHTDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKHTDataCellIdenty"];
    if (!cell) {
        cell = [[MKHTDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKHTDataCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.temperIcon];
        [self.contentView addSubview:self.temperLabel];
        [self.contentView addSubview:self.temperValueLabel];
        [self.contentView addSubview:self.temperUnitLabel];
        [self.contentView addSubview:self.humiIcon];
        [self.contentView addSubview:self.humiLabel];
        [self.contentView addSubview:self.humiValueLabel];
        [self.contentView addSubview:self.humiUnitLabel];
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.periodUnitLabel];
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.temperIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.temperLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.temperIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.temperValueLabel.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.temperIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.temperValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.temperUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.temperIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(28.f).lineHeight);
    }];
    [self.temperUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.temperIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.humiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.temperIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.humiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.humiIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(self.temperLabel.mas_width);
        make.centerY.mas_equalTo(self.humiIcon.mas_centerY);
        make.height.mas_equalTo(self.temperLabel.mas_height);
    }];
    [self.humiValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.humiUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.humiIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(28.f).lineHeight);
    }];
    [self.humiUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.humiIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.humiIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.periodLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.humiIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.periodUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark -
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if (!ValidDict(_dataDic)) {
        return;
    }
    self.temperValueLabel.text = dataDic[@"temperature"];
    self.humiValueLabel.text = dataDic[@"humidity"];
}

#pragma mark - setter & getter
- (UIImageView *)temperIcon {
    if (!_temperIcon) {
        _temperIcon = [[UIImageView alloc] init];
        _temperIcon.image = LOADIMAGE(@"slot_config_temperatureIcon", @"png");
    }
    return _temperIcon;
}

- (UILabel *)temperLabel {
    if (!_temperLabel) {
        _temperLabel = [[UILabel alloc] init];
        _temperLabel.textColor = DEFAULT_TEXT_COLOR;
        _temperLabel.textAlignment = NSTextAlignmentLeft;
        _temperLabel.font = MKFont(15.f);
        _temperLabel.text = @"Temperature";
    }
    return _temperLabel;
}

- (UILabel *)temperValueLabel {
    if (!_temperValueLabel) {
        _temperValueLabel = [[UILabel alloc] init];
        _temperValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _temperValueLabel.textAlignment = NSTextAlignmentLeft;
        _temperValueLabel.font = MKFont(28.f);
        _temperValueLabel.text = @"0.0";
    }
    return _temperValueLabel;
}

- (UILabel *)temperUnitLabel {
    if (!_temperUnitLabel) {
        _temperUnitLabel = [[UILabel alloc] init];
        _temperUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _temperUnitLabel.textAlignment = NSTextAlignmentLeft;
        _temperUnitLabel.font = MKFont(12.f);
        _temperUnitLabel.text = @"℃";
    }
    return _temperUnitLabel;
}

- (UIImageView *)humiIcon {
    if (!_humiIcon) {
        _humiIcon = [[UIImageView alloc] init];
        _humiIcon.image = LOADIMAGE(@"slot_config_humidityIcon", @"png");
    }
    return _humiIcon;
}

- (UILabel *)humiLabel {
    if (!_humiLabel) {
        _humiLabel = [[UILabel alloc] init];
        _humiLabel.textColor = DEFAULT_TEXT_COLOR;
        _humiLabel.textAlignment = NSTextAlignmentLeft;
        _humiLabel.font = MKFont(15.f);
        _humiLabel.text = @"Humidity";
    }
    return _humiLabel;
}

- (UILabel *)humiValueLabel {
    if (!_humiValueLabel) {
        _humiValueLabel = [[UILabel alloc] init];
        _humiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _humiValueLabel.textAlignment = NSTextAlignmentLeft;
        _humiValueLabel.font = MKFont(28.f);
        _humiValueLabel.text = @"0.0";
    }
    return _humiValueLabel;
}

- (UILabel *)humiUnitLabel {
    if (!_humiUnitLabel) {
        _humiUnitLabel = [[UILabel alloc] init];
        _humiUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _humiUnitLabel.textAlignment = NSTextAlignmentLeft;
        _humiUnitLabel.font = MKFont(12.f);
        _humiUnitLabel.text = @"%";
    }
    return _humiUnitLabel;
}

- (UILabel *)periodLabel {
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.textColor = DEFAULT_TEXT_COLOR;
        _periodLabel.textAlignment = NSTextAlignmentLeft;
        _periodLabel.font = MKFont(13.f);
        _periodLabel.text = @"Sampling Period";
    }
    return _periodLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.font = MKFont(12.f);
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.text = @"10";
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_textField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _textField;
}

- (UILabel *)periodUnitLabel {
    if (!_periodUnitLabel) {
        _periodUnitLabel = [[UILabel alloc] init];
        _periodUnitLabel.textAlignment = NSTextAlignmentLeft;
        _periodUnitLabel.attributedText = [MKAttributedString getAttributedString:@[@"sec(s)",@"   (1~65535)"] fonts:@[MKFont(12.f),MKFont(10.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _periodUnitLabel;
}

@end
