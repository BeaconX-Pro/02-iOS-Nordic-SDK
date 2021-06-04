//
//  MKBXPAccelerationParamsCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPAccelerationParamsCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKPickerView.h"
#import "MKSlider.h"

#import "MKBXPConnectManager.h"

@implementation MKBXPAccelerationParamsCellModel
@end

@interface MKBXPAccelerationParamsCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *scaleLabel;

@property (nonatomic, strong)UIButton *scaleButton;

@property (nonatomic, strong)NSMutableArray *scaleList;

@property (nonatomic, strong)UILabel *sampleRateLabel;

@property (nonatomic, strong)UIButton *sampleRateButton;

@property (nonatomic, strong)NSMutableArray *sampleRateList;

@property (nonatomic, strong)UILabel *sensitivityLabel;

@property (nonatomic, strong)MKSlider *sensitivitySlider;

@property (nonatomic, strong)UILabel *sensitivityValueLabel;

@end

@implementation MKBXPAccelerationParamsCell

+ (MKBXPAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPAccelerationParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPAccelerationParamsCellIdenty"];
    if (!cell) {
        cell = [[MKBXPAccelerationParamsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPAccelerationParamsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.scaleLabel];
        [self.backView addSubview:self.scaleButton];
        [self.backView addSubview:self.sampleRateLabel];
        [self.backView addSubview:self.sampleRateButton];
        [self.backView addSubview:self.sensitivityLabel];
        [self.backView addSubview:self.sensitivitySlider];
        [self.backView addSubview:self.sensitivityValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.scaleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.scaleButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.scaleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scaleLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.sampleRateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.sampleRateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.sampleRateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sampleRateLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.scaleButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.sensitivityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.sampleRateButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.sensitivitySlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.sensitivityValueLabel.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(self.sensitivityLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.sensitivityValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.sensitivitySlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)scaleButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.scaleList.count; i ++) {
        if ([self.scaleButton.titleLabel.text isEqualToString:self.scaleList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.scaleList selectedRow:index block:^(NSInteger currentRow) {
        [self scaleChanged:currentRow];
    }];
}

- (void)sampleRateButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.sampleRateList.count; i ++) {
        if ([self.sampleRateButton.titleLabel.text isEqualToString:self.sampleRateList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.sampleRateList selectedRow:index block:^(NSInteger currentRow) {
        [self.sampleRateButton setTitle:self.sampleRateList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(bxp_accelerationParamsSamplingRateChanged:)]) {
            [self.delegate bxp_accelerationParamsSamplingRateChanged:currentRow];
        }
    }];
}

- (void)sliderValueChanged {
    NSString *tempValue = [NSString stringWithFormat:@"%.f",self.sensitivitySlider.value];
    if ([self.delegate respondsToSelector:@selector(bxp_accelerationParamsSensitivityValueChanged:)]) {
        [self.delegate bxp_accelerationParamsSensitivityValueChanged:[tempValue integerValue]];
    }
    if ([MKBXPConnectManager shared].newVersion) {
        //新版本固件
        self.sensitivityValueLabel.text = [NSString stringWithFormat:@"%.1f%@",[tempValue integerValue] * 0.1,@"g"];
        return;
    }
    //旧版本固件
    self.sensitivityValueLabel.text = tempValue;
}

#pragma mark - setter
- (void)setDataModel:(MKBXPAccelerationParamsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self.scaleButton setTitle:self.scaleList[_dataModel.scale] forState:UIControlStateNormal];
    [self.sampleRateButton setTitle:self.sampleRateList[_dataModel.samplingRate] forState:UIControlStateNormal];
    if ([MKBXPConnectManager shared].newVersion) {
        self.sensitivitySlider.minimumValue = 1;
        if (_dataModel.scale == 0) {
            //±2g
            self.sensitivitySlider.maximumValue = 19;
        }else if (_dataModel.scale == 1) {
            //±4g
            self.sensitivitySlider.maximumValue = 39;
        }else if (_dataModel.scale == 2) {
            //±8g
            self.sensitivitySlider.maximumValue = 79;
        }else if (_dataModel.scale == 3) {
            //±16g
            self.sensitivitySlider.maximumValue = 159;
        }
        self.sensitivityValueLabel.text = [NSString stringWithFormat:@"%.1f%@",_dataModel.sensitivityValue * 0.1,@"g"];
    }else {
        self.sensitivitySlider.minimumValue = 7;
        self.sensitivitySlider.maximumValue = 255;
        self.sensitivityValueLabel.text = [NSString stringWithFormat:@"%ld",(long)_dataModel.sensitivityValue];
    }
    self.sensitivitySlider.value = _dataModel.sensitivityValue;
}

#pragma mark - private method
- (void)scaleChanged:(NSInteger)scale {
    [self.scaleButton setTitle:self.scaleList[scale] forState:UIControlStateNormal];
    if ([MKBXPConnectManager shared].newVersion) {
        self.sensitivitySlider.minimumValue = 1;
        if (scale == 0) {
            //±2g
            self.sensitivitySlider.maximumValue = 19;
        }else if (scale == 1) {
            //±4g
            self.sensitivitySlider.maximumValue = 39;
        }else if (scale == 2) {
            //±8g
            self.sensitivitySlider.maximumValue = 79;
        }else if (scale == 3) {
            //±16g
            self.sensitivitySlider.maximumValue = 159;
        }
        self.sensitivityValueLabel.text = @"0.1g";
        self.sensitivitySlider.value = 1;
    }else {
        self.sensitivitySlider.minimumValue = 7;
        self.sensitivitySlider.maximumValue = 255;
        self.sensitivityValueLabel.text = @"7";
        self.sensitivitySlider.value = 7;
    }
    
    if ([self.delegate respondsToSelector:@selector(bxp_accelerationParamsScaleChanged:)]) {
        [self.delegate bxp_accelerationParamsScaleChanged:scale];
    }
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font= MKFont(15.f);
        _msgLabel.text = @"Sensor parameters";
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

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleButton.titleLabel setFont:MKFont(12.f)];
        [_scaleButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_scaleButton addTarget:self
                         action:@selector(scaleButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
        
        _scaleButton.layer.masksToBounds = YES;
        _scaleButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _scaleButton.layer.borderWidth = 0.5f;
        _scaleButton.layer.cornerRadius = 6.f;
    }
    return _scaleButton;
}

- (NSMutableArray *)scaleList {
    if (!_scaleList) {
        _scaleList = [NSMutableArray arrayWithObjects:@"±2g",@"±4g",@"±8g",@"±16g", nil];
    }
    return _scaleList;
}

- (UILabel *)sampleRateLabel {
    if (!_sampleRateLabel) {
        _sampleRateLabel = [[UILabel alloc] init];
        _sampleRateLabel.textAlignment = NSTextAlignmentLeft;
        _sampleRateLabel.textColor = DEFAULT_TEXT_COLOR;
        _sampleRateLabel.font = MKFont(13.f);
        _sampleRateLabel.text = @"Sampling rate";
    }
    return _sampleRateLabel;
}

- (UIButton *)sampleRateButton {
    if (!_sampleRateButton) {
        _sampleRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sampleRateButton.titleLabel setFont:MKFont(12.f)];
        [_sampleRateButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_sampleRateButton addTarget:self
                              action:@selector(sampleRateButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
        
        _sampleRateButton.layer.masksToBounds = YES;
        _sampleRateButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _sampleRateButton.layer.borderWidth = 0.5f;
        _sampleRateButton.layer.cornerRadius = 6.f;
    }
    return _sampleRateButton;
}

- (NSMutableArray *)sampleRateList {
    if (!_sampleRateList) {
        _sampleRateList = [NSMutableArray arrayWithObjects:@"1hz",@"10hz",@"25hz",@"50hz",@"100hz", nil];
    }
    return _sampleRateList;
}

- (UILabel *)sensitivityLabel {
    if (!_sensitivityLabel) {
        _sensitivityLabel = [[UILabel alloc] init];
        _sensitivityLabel.textAlignment = NSTextAlignmentLeft;
        _sensitivityLabel.textColor = DEFAULT_TEXT_COLOR;
        _sensitivityLabel.font = MKFont(13.f);
        _sensitivityLabel.text = @"Motion sensitivity";
    }
    return _sensitivityLabel;
}

- (MKSlider *)sensitivitySlider {
    if (!_sensitivitySlider) {
        _sensitivitySlider = [[MKSlider alloc] init];
        _sensitivitySlider.maximumValue = 255;
        _sensitivitySlider.minimumValue = 7;
        [_sensitivitySlider addTarget:self
                               action:@selector(sliderValueChanged)
                     forControlEvents:UIControlEventValueChanged];
    }
    return _sensitivitySlider;
}

- (UILabel *)sensitivityValueLabel {
    if (!_sensitivityValueLabel) {
        _sensitivityValueLabel = [[UILabel alloc] init];
        _sensitivityValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _sensitivityValueLabel.font = MKFont(12.f);
        _sensitivityValueLabel.textAlignment = NSTextAlignmentLeft;
        _sensitivityValueLabel.text = @"0.1g";
    }
    return _sensitivityValueLabel;
}

@end
