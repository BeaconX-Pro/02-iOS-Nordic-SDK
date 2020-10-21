//
//  MKAxisParametersCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAxisParametersCell.h"
#import "MKSlider.h"
#import "MKPickerView.h"

@interface MKAxisParametersCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *scaleLabel;

@property (nonatomic, strong)UILabel *scaleValueLabel;

@property (nonatomic, strong)UILabel *dataRateLabel;

@property (nonatomic, strong)UILabel *dataRateValueLabel;

@property (nonatomic, strong)UILabel *triggerLabel;

@property (nonatomic, strong)MKSlider *sensitivitySlider;

@property (nonatomic, strong)UILabel *sensitivityUnitLabel;

@end

@implementation MKAxisParametersCell

+ (MKAxisParametersCell *)initCellWithTableView:(UITableView *)tableView {
    MKAxisParametersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAxisParametersCellIdenty"];
    if (!cell) {
        cell = [[MKAxisParametersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAxisParametersCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.scaleLabel];
        [self.contentView addSubview:self.scaleValueLabel];
        [self.contentView addSubview:self.dataRateLabel];
        [self.contentView addSubview:self.dataRateValueLabel];
        [self.contentView addSubview:self.triggerLabel];
        [self.contentView addSubview:self.sensitivitySlider];
        [self.contentView addSubview:self.sensitivityUnitLabel];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.scaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.scaleValueLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.scaleValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scaleLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.dataRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.dataRateValueLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(65.f);
        make.centerY.mas_equalTo(self.scaleValueLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.dataRateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.scaleValueLabel.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.triggerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.scaleValueLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.sensitivitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.sensitivityUnitLabel.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(self.triggerLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.sensitivityUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.sensitivitySlider.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

- (NSDictionary *)getContentData {
    threeAxisDataAG scale = threeAxisDataAG0;
    if ([self.scaleValueLabel.text isEqualToString:@"±4g"]) {
        scale = threeAxisDataAG1;
    }else if ([self.scaleValueLabel.text isEqualToString:@"±8g"]) {
        scale = threeAxisDataAG2;
    }else if ([self.scaleValueLabel.text isEqualToString:@"±16g"]) {
        scale = threeAxisDataAG3;
    }
    threeAxisDataRate dataRate = threeAxisDataRate1hz;
    if ([self.dataRateValueLabel.text isEqualToString:@"10hz"]) {
        dataRate = threeAxisDataRate10hz;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"25hz"]) {
        dataRate = threeAxisDataRate25hz;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"50hz"]) {
        dataRate = threeAxisDataRate50hz;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"100hz"]) {
        dataRate = threeAxisDataRate100hz;
    }
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"threeAxis",
                     @"scale":@(scale),
                     @"dataRate":@(dataRate),
                     @"sensitivity":SafeStr(self.sensitivityUnitLabel.text)
                     },
             };
}

#pragma mark - event method
- (void)scaleValueLabelPressed {
    NSArray *dataList = @[@"±2g",@"±4g",@"±8g",@"±16g"];
    NSInteger index = 0;
    if ([self.scaleValueLabel.text isEqualToString:@"±4g"]) {
        index = 1;
    }else if ([self.scaleValueLabel.text isEqualToString:@"±8g"]) {
        index = 2;
    }else if ([self.scaleValueLabel.text isEqualToString:@"±16g"]) {
        index = 3;
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:index block:^(NSInteger currentRow) {
        self.scaleValueLabel.text = dataList[currentRow];
    }];
}

- (void)dataRateValueLabelPressed {
    NSArray *dataList = @[@"1hz",@"10hz",@"25hz",@"50hz",@"100hz"];
    NSInteger index = 0;
    if ([self.dataRateValueLabel.text isEqualToString:@"10hz"]) {
        index = 1;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"25hz"]) {
        index = 2;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"50hz"]) {
        index = 3;
    }else if ([self.dataRateValueLabel.text isEqualToString:@"100hz"]) {
        index = 4;
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:index block:^(NSInteger currentRow) {
        self.dataRateValueLabel.text = dataList[currentRow];
    }];
}

- (void)sliderValueChanged {
    self.sensitivityUnitLabel.text = [NSString stringWithFormat:@"%.f",self.sensitivitySlider.value];
}

#pragma mark -
-(void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = nil;
    _dataDic = dataDic;
    if (!ValidDict(dataDic)) {
        return;
    }
    if ([dataDic[@"samplingRate"] isEqualToString:@"00"]) {
        self.dataRateValueLabel.text = @"1hz";
    }else if ([dataDic[@"samplingRate"] isEqualToString:@"01"]) {
        self.dataRateValueLabel.text = @"10hz";
    }else if ([dataDic[@"samplingRate"] isEqualToString:@"02"]) {
        self.dataRateValueLabel.text = @"25hz";
    }else if ([dataDic[@"samplingRate"] isEqualToString:@"03"]) {
        self.dataRateValueLabel.text = @"50hz";
    }else if ([dataDic[@"samplingRate"] isEqualToString:@"04"]) {
        self.dataRateValueLabel.text = @"100hz";
    }
    if ([dataDic[@"gravityReference"] isEqualToString:@"00"]) {
        self.scaleValueLabel.text = @"±2g";
    }else if ([dataDic[@"gravityReference"] isEqualToString:@"01"]) {
        self.scaleValueLabel.text = @"±4g";
    }else if ([dataDic[@"gravityReference"] isEqualToString:@"02"]) {
        self.scaleValueLabel.text = @"±8g";
    }else if ([dataDic[@"gravityReference"] isEqualToString:@"03"]) {
        self.scaleValueLabel.text = @"±16g";
    }
    if (ValidStr(dataDic[@"sensitivity"])) {
        self.sensitivityUnitLabel.text = dataDic[@"sensitivity"];
        self.sensitivitySlider.value = [dataDic[@"sensitivity"] floatValue];
    }
}

#pragma mark - private method
- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x2F84D0);
    label.font = MKFont(13.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = UIColorFromRGB(0x2F84D0).CGColor;
    label.layer.borderWidth = 0.5f;
    label.layer.cornerRadius = 6.f;
    return label;
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"slot_baseParams", @"png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"3-Axis Parameters";
    }
    return _msgLabel;
}

- (UILabel *)scaleLabel {
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc] init];
        _scaleLabel.textColor = DEFAULT_TEXT_COLOR;
        _scaleLabel.textAlignment = NSTextAlignmentLeft;
        _scaleLabel.font = MKFont(13.f);
        _scaleLabel.text = @"Scale";
    }
    return _scaleLabel;
}

- (UILabel *)scaleValueLabel {
    if (!_scaleValueLabel) {
        _scaleValueLabel = [self createLabel];
        [_scaleValueLabel addTapAction:self selector:@selector(scaleValueLabelPressed)];
    }
    return _scaleValueLabel;
}

- (UILabel *)dataRateLabel {
    if (!_dataRateLabel) {
        _dataRateLabel = [[UILabel alloc] init];
        _dataRateLabel.textColor = DEFAULT_TEXT_COLOR;
        _dataRateLabel.textAlignment = NSTextAlignmentLeft;
        _dataRateLabel.font = MKFont(13.f);
        _dataRateLabel.text = @"Data Rate";
    }
    return _dataRateLabel;
}

- (UILabel *)dataRateValueLabel {
    if (!_dataRateValueLabel) {
        _dataRateValueLabel = [self createLabel];
        [_dataRateValueLabel addTapAction:self selector:@selector(dataRateValueLabelPressed)];
    }
    return _dataRateValueLabel;
}

- (UILabel *)triggerLabel {
    if (!_triggerLabel) {
        _triggerLabel = [[UILabel alloc] init];
        _triggerLabel.textColor = DEFAULT_TEXT_COLOR;
        _triggerLabel.textAlignment = NSTextAlignmentLeft;
        _triggerLabel.font = MKFont(13.f);
        _triggerLabel.text = @"Trigger sensitivity";
    }
    return _triggerLabel;
}

- (MKSlider *)sensitivitySlider {
    if (!_sensitivitySlider) {
        _sensitivitySlider = [[MKSlider alloc] init];
        _sensitivitySlider.maximumValue = 255;
        _sensitivitySlider.minimumValue = 7;
        _sensitivitySlider.value = 7;
        [_sensitivitySlider addTarget:self
                               action:@selector(sliderValueChanged)
                     forControlEvents:UIControlEventValueChanged];
    }
    return _sensitivitySlider;
}

- (UILabel *)sensitivityUnitLabel {
    if (!_sensitivityUnitLabel) {
        _sensitivityUnitLabel = [[UILabel alloc] init];
        _sensitivityUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _sensitivityUnitLabel.textAlignment = NSTextAlignmentLeft;
        _sensitivityUnitLabel.font = MKFont(13.f);
        _sensitivityUnitLabel.text = @"7";
    }
    return _sensitivityUnitLabel;
}

@end
