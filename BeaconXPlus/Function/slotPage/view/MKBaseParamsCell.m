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

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiUnitLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerUnitLabel;

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
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    CGFloat postion_Y = ([self needHiddenRssiInfo] ? 2 * offset_Y : offset_Y);
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(postion_Y);
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
    if ([self needHiddenRssiInfo]) {
        [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset_X);
            make.right.mas_equalTo(-offset_X);
            make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(postion_Y);
            make.height.mas_equalTo(MKFont(15).lineHeight);
        }];
    }else{
        [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset_X);
            make.right.mas_equalTo(-offset_X);
            make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(offset_Y);
            make.height.mas_equalTo(MKFont(15).lineHeight);
        }];
    }
    
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
                     }
             };
}

#pragma mark - Private method

- (void)sliderValueChanged:(UISlider *)slider{
    if (slider == self.rssiSlider){
        self.rssiUnitLabel.text = [NSString stringWithFormat:@"%.fdBm",slider.value];
    }else if (slider == self.txPowerSlider){
        self.txPowerUnitLabel.text = [self getTxPowerUnitWithValue:slider.value];
    }
}

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
//只有UID、URL、iBeacon才有rssi信息
- (BOOL)needHiddenRssiInfo{
    if ([self.baseCellType isEqualToString:MKSlotBaseCellTLMType]) {
        return YES;
    }
    return NO;
}

//iBeacon下面的rssi信息与UID、URL不一样
- (BOOL)isiBeaconType{
    return [self.baseCellType isEqualToString:MKSlotBaseCelliBeaconType];
}

- (UILabel *)functionLabelWithFont:(UIFont *)font{
    UILabel *funcLabel = [[UILabel alloc] init];
    funcLabel.textColor = DEFAULT_TEXT_COLOR;
    funcLabel.textAlignment = NSTextAlignmentLeft;
    funcLabel.font = font;
    return funcLabel;
}


#pragma mark - Public method
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = nil;
    _dataDic = dataDic;
    if ([self isiBeaconType]) {
        _rssiLabel.text = @"RSSI@1M";
    }else{
        _rssiLabel.text = @"RSSI@0M";
    }
    [self.rssiSlider setHidden:[self needHiddenRssiInfo]];
    [self.rssiLabel setHidden:[self needHiddenRssiInfo]];
    [self.rssiUnitLabel setHidden:[self needHiddenRssiInfo]];
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
    [self setNeedsLayout];
}

- (void)setBaseCellType:(NSString *)baseCellType{
    _baseCellType = nil;
    _baseCellType = baseCellType;
    if (!ValidStr(_baseCellType)) {
        return;
    }
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
        _msgLabel.text = @"Base Params";
    }
    return _msgLabel;
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
        _rssiSlider.maximumValue = 0.f;
        _rssiSlider.minimumValue = -127.f;
        _rssiSlider.value = -127.f;
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
