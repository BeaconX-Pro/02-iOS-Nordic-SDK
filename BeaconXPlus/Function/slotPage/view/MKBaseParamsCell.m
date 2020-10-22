//
//  MKBaseParamsCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseParamsCell.h"
#import "MKSlider.h"

static NSString *const MKBaseParamsCellIdenty = @"MKBaseParamsCellIdenty";
static CGFloat const iconWidth = 22.f;
static CGFloat const iconHeight = 22.f;
static CGFloat const offset_X = 15.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const sliderHeight = 10.f;
static CGFloat const unitLabelWidth = 60.f;

@interface MKBaseParamsCell()

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *advIntervalLabel;

@property (nonatomic, strong)UILabel *advNoteLabel;

@property (nonatomic, strong)UITextField *intervalTextField;

@property (nonatomic, strong)UILabel *advIntervalUnitLabel;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiUnitLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerUnitLabel;

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation MKBaseParamsCell

+ (MKBaseParamsCell *)initCellWithTableView:(UITableView *)tableView{
    MKBaseParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:MKBaseParamsCellIdenty];
    if (!cell) {
        cell = [[MKBaseParamsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKBaseParamsCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.advIntervalLabel];
        [self.contentView addSubview:self.advNoteLabel];
        [self.contentView addSubview:self.intervalTextField];
        [self.contentView addSubview:self.advIntervalUnitLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.rssiSlider];
        [self.contentView addSubview:self.rssiUnitLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.txPowerSlider];
        [self.contentView addSubview:self.txPowerUnitLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(iconHeight);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.switchView.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.advIntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.advNoteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(140);
        make.top.mas_equalTo(self.advIntervalLabel.mas_bottom).mas_offset(3.f);
        make.height.mas_equalTo(MKFont(11).lineHeight);
    }];
    [self.intervalTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.advNoteLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(20.f);
    }];
    [self.advIntervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.intervalTextField.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.intervalTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.advNoteLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.rssiSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.rssiUnitLabel.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(sliderHeight);
    }];
    [self.rssiUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.rssiSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.txPowerUnitLabel.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(offset_Y);
        make.height.mas_equalTo(sliderHeight);
    }];
    [self.txPowerUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    NSString *interval = [self.intervalTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!ValidStr(interval)) {
        return [self errorDic:@"advInterval error"];
    }
    //rssi
    NSString *rssi = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    //tx power
    NSString *txPower = self.txPowerUnitLabel.text;
    
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"baseParam",
                     @"advTxPower":rssi,
                     @"txPower":txPower,
                     @"advInterval":interval,
                     }
             };
}

/**
 生成错误的dic
 
 @param errorMsg 错误内容
 @return dic
 */
- (NSDictionary *)errorDic:(NSString *)errorMsg{
    return @{
             @"code":@"2",
             @"msg":SafeStr(errorMsg),
             };
}

#pragma mark - event method
- (void)sliderValueChanged:(UISlider *)slider{
    if (slider == self.rssiSlider){
        NSString *unitValue = [NSString stringWithFormat:@"%.fdBm",slider.value];
        if ([unitValue isEqualToString:@"-0dBm"]) {
            unitValue = @"0dBm";
        }
        self.rssiUnitLabel.text = unitValue;
    }else if (slider == self.txPowerSlider){
        self.txPowerUnitLabel.text = [self getTxPowerUnitWithValue:slider.value];
    }
}

- (void)switchViewValueChanged {
    [self reloadSubViews:!self.switchView.isOn];
    if ([self.delegate respondsToSelector:@selector(advertisingStatusChanged:)]) {
        [self.delegate advertisingStatusChanged:self.switchView.isOn];
    }
}

#pragma mark - Private method

- (NSString *)getTxPowerUnitWithValue:(float)value{
    if (value >=0 && value < 11.1) {
        return @"-40dBm";
    }else if (value >= 11.1 && value < 22.2){
        return @"-20dBm";
    }else if (value >= 22.2 && value < 33.3){
        return @"-16dBm";
    }else if (value >= 33.3 && value < 44.4){
        return @"-12dBm";
    }else if (value >= 44.4 && value < 55.5){
        return @"-8dBm";
    }else if (value >= 55.5 && value < 66.6){
        return @"-4dBm";
    }else if (value >= 66.6 && value < 77.7){
        return @"0dBm";
    }else if (value >= 77.7 && value < 88.8){
        return @"3dBm";
    }else if (value >= 88.8 && value <= 100){
        return @"4dBm";
    }
    return nil;
}

- (float)getTxpowerSliderValue:(NSString *)txPower{
    if (!ValidStr(txPower)) {
        return 0.f;
    }
    if ([txPower isEqualToString:@"-40dBm"]) {
        return 0.0f;
    }else if ([txPower isEqualToString:@"-20dBm"]){
        return 11.1;
    }else if ([txPower isEqualToString:@"-16dBm"]){
        return 22.2;
    }else if ([txPower isEqualToString:@"-12dBm"]){
        return 33.3;
    }else if ([txPower isEqualToString:@"-8dBm"]){
        return 44.4;
    }else if ([txPower isEqualToString:@"-4dBm"]){
        return 55.5;
    }else if ([txPower isEqualToString:@"0dBm"]){
        return 66.6;
    }else if ([txPower isEqualToString:@"3dBm"]){
        return 77.7;
    }else if ([txPower isEqualToString:@"4dBm"]){
        return 88.8;
    }
    return 0.f;
}

//iBeacon下面的rssi信息与UID、URL不一样
- (BOOL)isiBeaconType{
    return [self.baseCellType isEqualToString:MKSlotBaseCelliBeaconType];
}

- (BOOL)isThreeAsixType {
    return [self.baseCellType isEqualToString:MKSlotBaseCellAxisAcceDataType];
}

- (BOOL)isTHDataType {
    return [self.baseCellType isEqualToString:MKSlotBaseCellTHDataType];
}

- (UILabel *)functionLabelWithFont:(UIFont *)font{
    UILabel *funcLabel = [[UILabel alloc] init];
    funcLabel.textColor = DEFAULT_TEXT_COLOR;
    funcLabel.textAlignment = NSTextAlignmentLeft;
    funcLabel.font = font;
    return funcLabel;
}

- (void)reloadSubViews:(BOOL)hidden {
    self.advIntervalLabel.hidden = hidden;
    self.advNoteLabel.hidden = hidden;
    self.intervalTextField.hidden = hidden;
    self.advIntervalUnitLabel.hidden = hidden;
    self.rssiLabel.hidden = hidden;
    self.rssiSlider.hidden = hidden;
    self.rssiUnitLabel.hidden = hidden;
    self.txPowerLabel.hidden = hidden;
    self.txPowerSlider.hidden = hidden;
    self.txPowerUnitLabel.hidden = hidden;
}

#pragma mark - Public method
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    if ([self isiBeaconType]) {
        _rssiLabel.attributedText = [MKAttributedString getAttributedString:@[@"RSSI@1M",@"    (-100dBm~+20dBm)"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }else{
        _rssiLabel.attributedText = [MKAttributedString getAttributedString:@[@"RSSI@0M",@"    (-100dBm~+20dBm)"] fonts:@[MKFont(15.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
//    if ([self isThreeAsixType] || [self isTHDataType]) {
//        self.icon.image = LOADIMAGE(@"slot_baseParams_advertising", @"png");
//        self.switchView.hidden = NO;
//        [self.switchView setOn:[dataDic[@"advertisingIsOn"] boolValue]];
//        [self reloadSubViews:!self.switchView.isOn];
//    }else {
//        self.icon.image = LOADIMAGE(@"slot_baseParams", @"png");
//        self.switchView.hidden = YES;
//        [self reloadSubViews:NO];
//    }
    self.icon.image = LOADIMAGE(@"slot_baseParams", @"png");
    self.switchView.hidden = YES;
    [self reloadSubViews:NO];
    if (!ValidDict(_dataDic)) {
        if ([self isiBeaconType]) {
            [self.rssiSlider setValue:-59];
            [self.rssiUnitLabel setText:@"-59dBm"];
        }else{
            [self.rssiSlider setValue:0];
            [self.rssiUnitLabel setText:@"0dBm"];
        }
        //txPower
        [self.txPowerSlider setValue:66.6];
        [self.txPowerUnitLabel setText:@"0dBm"];
        [self setNeedsLayout];
        return;
    }
    if (ValidStr(_dataDic[@"advTxPower"])) {
        //RSSI@1m
        [self.rssiSlider setValue:[_dataDic[@"advTxPower"] floatValue]];
        [self.rssiUnitLabel setText:[_dataDic[@"advTxPower"] stringByAppendingString:@"dBm"]];
    }else{
        if ([self isiBeaconType]) {
            [self.rssiSlider setValue:-59];
            [self.rssiUnitLabel setText:@"-59dBm"];
        }else{
            [self.rssiSlider setValue:0];
            [self.rssiUnitLabel setText:@"0dBm"];
        }
    }
    if (ValidStr(_dataDic[@"radioTxPower"])) {
        //txPower
        [self.txPowerSlider setValue:[self getTxpowerSliderValue:_dataDic[@"radioTxPower"]]];
        [self.txPowerUnitLabel setText:_dataDic[@"radioTxPower"]];
    }else{
        [self.txPowerSlider setValue:66.6];
        [self.txPowerUnitLabel setText:@"0dBm"];
    }
    if (ValidStr(_dataDic[@"advInterval"])) {
        self.intervalTextField.text = [NSString stringWithFormat:@"%ld",(long)([_dataDic[@"advInterval"] integerValue] / 100)];
    }
    [self setNeedsLayout];
}

#pragma mark - setter & getter
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADIMAGE(@"slot_baseParams", @"png");
    }
    return _icon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Adv Parameters";
    }
    return _msgLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UILabel *)advIntervalLabel {
    if (!_advIntervalLabel) {
        _advIntervalLabel = [self functionLabelWithFont:MKFont(15.f)];
        _advIntervalLabel.text = @"Adv Interval";
    }
    return _advIntervalLabel;
}

- (UILabel *)advNoteLabel {
    if (!_advNoteLabel) {
        _advNoteLabel = [[UILabel alloc] init];
        _advNoteLabel.textColor = RGBCOLOR(223, 223, 223);
        _advNoteLabel.textAlignment = NSTextAlignmentLeft;
        _advNoteLabel.font = MKFont(11.f);
        _advNoteLabel.text = @"Min:100ms Max:10000ms";
    }
    return _advNoteLabel;
}

- (UITextField *)intervalTextField {
    if (!_intervalTextField) {
        _intervalTextField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _intervalTextField.textColor = DEFAULT_TEXT_COLOR;
        _intervalTextField.textAlignment = NSTextAlignmentCenter;
        _intervalTextField.font = MKFont(12.f);
        _intervalTextField.borderStyle = UITextBorderStyleNone;
        _intervalTextField.text = @"10";
        
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

- (UILabel *)advIntervalUnitLabel {
    if (!_advIntervalUnitLabel) {
        _advIntervalUnitLabel = [[UILabel alloc] init];
        _advIntervalUnitLabel.textAlignment = NSTextAlignmentLeft;
        NSAttributedString *att = [MKAttributedString getAttributedString:@[@" x 100ms",@"    (1~100)"] fonts:@[MKFont(12.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
        _advIntervalUnitLabel.attributedText = att;
    }
    return _advIntervalUnitLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self functionLabelWithFont:MKFont(15.f)];
    }
    return _rssiLabel;
}

- (MKSlider *)rssiSlider{
    if (!_rssiSlider) {
        _rssiSlider = [[MKSlider alloc] init];
        _rssiSlider.maximumValue = 20;
        _rssiSlider.minimumValue = -100;
        _rssiSlider.value = -100;
        [_rssiSlider addTarget:self
                        action:@selector(sliderValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    }
    return _rssiSlider;
}

- (UILabel *)rssiUnitLabel{
    if (!_rssiUnitLabel) {
        _rssiUnitLabel = [self functionLabelWithFont:MKFont(12.f)];
        _rssiUnitLabel.text = @"-120dBm";
    }
    return _rssiUnitLabel;
}

- (UILabel *)txPowerLabel{
    if (!_txPowerLabel) {
        _txPowerLabel = [self functionLabelWithFont:MKFont(15)];
        _txPowerLabel.text = @"Tx Power";
    }
    return _txPowerLabel;
}

- (MKSlider *)txPowerSlider{
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 100.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(sliderValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerUnitLabel{
    if (!_txPowerUnitLabel) {
        _txPowerUnitLabel = [self functionLabelWithFont:MKFont(12.f)];
        _txPowerUnitLabel.text = @"-40dBm";
    }
    return _txPowerUnitLabel;
}

@end
