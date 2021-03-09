/*
 上面是RSSI@1M滑竿，下面是Tx Power滑竿，cell高度用120.f
 */

#import "MKMeasureTxPowerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

#import "MKSlider.h"

@implementation MKMeasureTxPowerCellModel
@end

@interface MKMeasureTxPowerCell ()

@property (nonatomic, strong)UILabel *rssiMsgLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UILabel *txPowerMsgLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UIView *lineView1;

@property (nonatomic, strong)UIView *lineView2;

@end

@implementation MKMeasureTxPowerCell

+ (MKMeasureTxPowerCell *)initCellWithTableView:(UITableView *)tableView {
    MKMeasureTxPowerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMeasureTxPowerCellIdenty"];
    if (!cell) {
        cell = [[MKMeasureTxPowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKMeasureTxPowerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.rssiMsgLabel];
        [self.contentView addSubview:self.rssiSlider];
        [self.contentView addSubview:self.rssiValueLabel];
        [self.contentView addSubview:self.txPowerMsgLabel];
        [self.contentView addSubview:self.txPowerSlider];
        [self.contentView addSubview:self.txPowerValueLabel];
        [self.contentView addSubview:self.lineView1];
        [self.contentView addSubview:self.lineView2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.rssiMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rssiSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rssiValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.rssiMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.rssiValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.rssiSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
    [self.txPowerMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.lineView1.mas_bottom).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerMsgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - event method
- (void)rssiSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    if ([value isEqualToString:@"-0"]) {
        value = @"0";
    }
    self.rssiValueLabel.text = [value stringByAppendingString:@"dBm"];
    if ([self.delegate respondsToSelector:@selector(mk_measureTxPowerCell_measurePowerValueChanged:)]) {
        [self.delegate mk_measureTxPowerCell_measurePowerValueChanged:value];
    }
}

- (void)txPowerSliderValueChanged {
    self.txPowerValueLabel.text = [self txPowerValueText:self.txPowerSlider.value];
    if ([self.delegate respondsToSelector:@selector(mk_measureTxPowerCell_txPowerValueChanged:)]) {
        [self.delegate mk_measureTxPowerCell_txPowerValueChanged:(NSInteger)self.txPowerSlider.value];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKMeasureTxPowerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.rssiSlider.value = _dataModel.measurePower;
    self.rssiValueLabel.text = [NSString stringWithFormat:@"%.fdBm",_dataModel.measurePower];
    self.txPowerSlider.value = _dataModel.txPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.txPower];
}

#pragma mark - private method
- (NSString *)txPowerValueText:(float)sliderValue{
    if (sliderValue >=0 && sliderValue < 1) {
        return @"-40dBm";
    }
    if (sliderValue >= 1 && sliderValue < 2){
        return @"-20dBm";
    }
    if (sliderValue >= 2 && sliderValue < 3){
        return @"-16dBm";
    }
    if (sliderValue >= 3 && sliderValue < 4){
        return @"-12dBm";
    }
    if (sliderValue >= 4 && sliderValue < 5){
        return @"-8dBm";
    }
    if (sliderValue >= 5 && sliderValue < 6){
        return @"-4dBm";
    }
    if (sliderValue >= 6 && sliderValue < 7){
        return @"0dBm";
    }
    if (sliderValue >= 7 && sliderValue < 8) {
        return @"3dBm";
    }
    return @"4dBm";
}

#pragma mark - getter
- (UILabel *)rssiMsgLabel {
    if (!_rssiMsgLabel) {
        _rssiMsgLabel = [[UILabel alloc] init];
        _rssiMsgLabel.textAlignment = NSTextAlignmentLeft;
        _rssiMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"RSSI@1m",@"   (-127dBm ~ 0dBm)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _rssiMsgLabel;
}

- (MKSlider *)rssiSlider {
    if (!_rssiSlider) {
        _rssiSlider = [[MKSlider alloc] init];
        _rssiSlider.maximumValue = 0;
        _rssiSlider.minimumValue = -127;
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
        _txPowerMsgLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tx Power",@"   (-40,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(15.f),MKFont(13.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
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

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView1;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView2;
}

@end
