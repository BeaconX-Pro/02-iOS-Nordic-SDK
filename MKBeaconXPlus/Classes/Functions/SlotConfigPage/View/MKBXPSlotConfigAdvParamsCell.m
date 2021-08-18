//
//  MKBXPSlotConfigAdvParamsCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotConfigAdvParamsCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

@implementation MKBXPSlotConfigAdvParamsCellModel
@end

@interface MKBXPSlotConfigAdvParamsCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *advIntervalLabel;

@property (nonatomic, strong)MKTextField *intervalTextField;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UILabel *rssiMsgLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UILabel *txPowerMsgLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@end

@implementation MKBXPSlotConfigAdvParamsCell

+ (MKBXPSlotConfigAdvParamsCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPSlotConfigAdvParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPSlotConfigAdvParamsCellIdenty"];
    if (!cell) {
        cell = [[MKBXPSlotConfigAdvParamsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPSlotConfigAdvParamsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.advIntervalLabel];
        [self.backView addSubview:self.intervalTextField];
        [self.backView addSubview:self.intervalUnitLabel];
        
        [self.backView addSubview:self.rssiMsgLabel];
        [self.backView addSubview:self.rssiSlider];
        [self.backView addSubview:self.rssiValueLabel];
        
        [self.backView addSubview:self.txPowerMsgLabel];
        [self.backView addSubview:self.txPowerSlider];
        [self.backView addSubview:self.txPowerValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - MKBXSlotConfigCellProtocol
- (NSDictionary *)mk_bx_slotConfigCell_params {
    if (!ValidStr(self.intervalTextField.text) || [self.intervalTextField.text integerValue] < 1 || [self.intervalTextField.text integerValue] > 100) {
        return @{
            @"msg":@"Adv interval Error",
            @"result":@{},
        };
    }
    
    NSString *txPowerValue = [NSString stringWithFormat:@"%.f",self.txPowerSlider.value];
    NSString *rssiValue = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    if ([rssiValue isEqualToString:@"-0"]) {
        rssiValue = @"0";
    }
    return @{
        @"msg":@"",
        @"result":@{
                @"dataType":mk_bx_slotConfig_advParamType,
                @"params":@{
                        @"txPower":txPowerValue,
                        @"rssi":rssiValue,
                        @"interval":self.intervalTextField.text
                }
        }
    };
}

#pragma mark - event method
- (void)rssiSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    if ([value isEqualToString:@"-0"]) {
        value = @"0";
    }
    self.rssiValueLabel.text = [value stringByAppendingString:@"dBm"];
}

- (void)txPowerSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.txPowerSlider.value];
    self.txPowerValueLabel.text = [self txPowerValueText:[value integerValue]];
}

#pragma mark - setter
- (void)setDataModel:(MKBXPSlotConfigAdvParamsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    
    self.txPowerSlider.value = _dataModel.txPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.txPower];
    self.intervalTextField.text = _dataModel.advInterval;
    
    if (self.rssiMsgLabel.superview) {
        [self.rssiMsgLabel removeFromSuperview];
    }
    if (self.rssiSlider.superview) {
        [self.rssiSlider removeFromSuperview];
    }
    if (self.rssiValueLabel.superview) {
        [self.rssiValueLabel removeFromSuperview];
    }
    
    if (self.dataModel.slotType == mk_bx_slotFrameTypeTLM) {
        [self setupTLMUI];
        return;
    }
    [self setupNormalUI];
}

#pragma mark - private method
- (NSString *)txPowerValueText:(NSInteger)value{
    if (value == 0) {
        return @"-40dBm";
    }
    if (value == 1){
        return @"-20dBm";
    }
    if (value == 2){
        return @"-16dBm";
    }
    if (value == 3){
        return @"-12dBm";
    }
    if (value == 4){
        return @"-8dBm";
    }
    if (value == 5){
        return @"-4dBm";
    }
    if (value == 6){
        return @"0dBm";
    }
    if (value == 7) {
        return @"3dBm";
    }
    return @"4dBm";
}

- (void)setupNormalUI {
    [self.backView addSubview:self.rssiMsgLabel];
    [self.backView addSubview:self.rssiSlider];
    [self.backView addSubview:self.rssiValueLabel];
    self.rssiSlider.value = self.dataModel.rssiValue;
    self.rssiValueLabel.text = [NSString stringWithFormat:@"%lddBm",(long)self.dataModel.rssiValue];
    NSString *tempMsg = @"RSSI@0m";
    if (_dataModel.slotType == mk_bx_slotFrameTypeBeacon) {
        tempMsg = @"RSSI@1m";
    }else if (_dataModel.slotType == mk_bx_slotFrameTypeInfo || _dataModel.slotType == mk_bx_slotFrameTypeThreeASensor || _dataModel.slotType == mk_bx_slotFrameTypeTHSensor) {
        tempMsg = @"Measured RSSI";
    }
    self.rssiMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[tempMsg,@"   (-100dBm ~ 0dBm)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    
    [self.advIntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.intervalTextField.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.intervalTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.intervalUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.intervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.rssiMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.intervalTextField.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rssiSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rssiValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.rssiMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.rssiValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.rssiSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

- (void)setupTLMUI {
    [self.advIntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.intervalTextField.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.intervalTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.intervalUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(20.f);
    }];
    [self.intervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.intervalTextField.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPSlotConfigAdvParamsCell", @"bxp_slot_baseParams.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Adv parameters";
    }
    return _typeLabel;
}

- (UILabel *)advIntervalLabel {
    if (!_advIntervalLabel) {
        _advIntervalLabel = [[UILabel alloc] init];
        _advIntervalLabel.textAlignment = NSTextAlignmentLeft;
        _advIntervalLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Adv Interval",@" (1 ~ 100)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _advIntervalLabel;
}

- (MKTextField *)intervalTextField {
    if (!_intervalTextField) {
        _intervalTextField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _intervalTextField.textColor = DEFAULT_TEXT_COLOR;
        _intervalTextField.textAlignment = NSTextAlignmentCenter;
        _intervalTextField.font = MKFont(12.f);
        _intervalTextField.borderStyle = UITextBorderStyleNone;
        _intervalTextField.text = @"10";
        _intervalTextField.maxLength = 3;
        _intervalTextField.placeholder = @"1~100";
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_intervalTextField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _intervalTextField;
}

- (UILabel *)intervalUnitLabel {
    if (!_intervalUnitLabel) {
        _intervalUnitLabel = [[UILabel alloc] init];
        _intervalUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalUnitLabel.font = MKFont(12.f);
        _intervalUnitLabel.textAlignment = NSTextAlignmentLeft;
        _intervalUnitLabel.text = @"x 100ms";
    }
    return _intervalUnitLabel;
}

- (UILabel *)rssiMsgLabel {
    if (!_rssiMsgLabel) {
        _rssiMsgLabel = [[UILabel alloc] init];
        _rssiMsgLabel.textAlignment = NSTextAlignmentLeft;
        _rssiMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"RSSI@1m",@"   (-100dBm ~ 0dBm)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _rssiMsgLabel;
}

- (MKSlider *)rssiSlider {
    if (!_rssiSlider) {
        _rssiSlider = [[MKSlider alloc] init];
        _rssiSlider.maximumValue = 0;
        _rssiSlider.minimumValue = -100;
        _rssiSlider.value = -40;
        [_rssiSlider addTarget:self
                        action:@selector(rssiSliderValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _rssiSlider;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] init];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(11.f);
        _rssiValueLabel.text = @"-40dBm";
    }
    return _rssiValueLabel;
}

- (UILabel *)txPowerMsgLabel {
    if (!_txPowerMsgLabel) {
        _txPowerMsgLabel = [[UILabel alloc] init];
        _txPowerMsgLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tx Power",@"   (-40,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _txPowerMsgLabel;
}

- (MKSlider *)txPowerSlider {
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 9.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(txPowerSliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [[UILabel alloc] init];
        _txPowerValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerValueLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerValueLabel.font = MKFont(11.f);
        _txPowerValueLabel.text = @"-12dBm";
    }
    return _txPowerValueLabel;
}

@end
