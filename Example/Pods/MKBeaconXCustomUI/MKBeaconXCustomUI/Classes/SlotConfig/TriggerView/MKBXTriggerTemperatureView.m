//
//  MKBXTriggerTemperatureView.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTriggerTemperatureView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXTriggerTemperatureViewModel
@end

@interface MKBXTriggerTemperatureView ()

@property (nonatomic, strong)UILabel *msgLabe;

@property (nonatomic, strong)MKSlider *temperSlider;

@property (nonatomic, strong)UILabel *sliderValueLabel;

@property (nonatomic, strong)UIImageView *startIcon;

@property (nonatomic, strong)UILabel *startLabel;

@property (nonatomic, strong)UIImageView *stopIcon;

@property (nonatomic, strong)UILabel *stopLabel;

@property (nonatomic, strong)UILabel *noteMsgLabel;

@property (nonatomic, assign)BOOL start;

@end

@implementation MKBXTriggerTemperatureView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.msgLabe];
        [self addSubview:self.temperSlider];
        [self addSubview:self.sliderValueLabel];
        [self addSubview:self.startIcon];
        [self addSubview:self.startLabel];
        [self addSubview:self.stopIcon];
        [self addSubview:self.stopLabel];
        [self addSubview:self.noteMsgLabel];
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.temperSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.sliderValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabe.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.sliderValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.temperSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.startIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.startLabel.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.startIcon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.temperSlider.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.stopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.stopLabel.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.stopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stopIcon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.startLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.noteMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.stopLabel.mas_bottom).mas_offset(5.f);
    }];
}

#pragma mark - event method
- (void)sliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.temperSlider.value];
    self.sliderValueLabel.text = [value stringByAppendingString:@"℃"];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTemperatureThresholdValueChanged:)]) {
        [self.delegate mk_bx_triggerTemperatureThresholdValueChanged:[value floatValue]];
    }
}

- (void)startLabelPressed {
    if (self.start) {
        return;
    }
    self.start = YES;
    [self updateSlectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTemperatureStartStatusChanged:)]) {
        [self.delegate mk_bx_triggerTemperatureStartStatusChanged:YES];
    }
}

- (void)stopLabelPressed {
    if (!self.start) {
        return;
    }
    self.start = NO;
    [self updateSlectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTemperatureStartStatusChanged:)]) {
        [self.delegate mk_bx_triggerTemperatureStartStatusChanged:NO];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTriggerTemperatureViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.start = _dataModel.start;
    NSString *value = [NSString stringWithFormat:@"%.f",_dataModel.sliderValue];
    self.sliderValueLabel.text = [value stringByAppendingString:@"℃"];
    self.temperSlider.value = _dataModel.sliderValue;
    [self updateNoteMsg];
    [self updateSlectedIcon];
}

#pragma mark - private method
- (void)updateNoteMsg {
    NSString *msg = [NSString stringWithFormat:@"*The Beacon will %@ advertising when the temperature is %@ %@",(self.start ? @"start" : @"stop"),(self.dataModel.above ? @"above" : @"below"),self.sliderValueLabel.text];
    self.noteMsgLabel.text = msg;
}

- (void)updateSlectedIcon {
    self.startIcon.image = (self.start ? LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigUnselectedIcon.png"));
    self.stopIcon.image = (self.start ? LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigUnselectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigSelectedIcon.png"));
}

#pragma mark - getter
- (UILabel *)msgLabe {
    if (!_msgLabe) {
        _msgLabe = [[UILabel alloc] init];
        _msgLabe.textColor = DEFAULT_TEXT_COLOR;
        _msgLabe.textAlignment = NSTextAlignmentLeft;
        _msgLabe.attributedText = [MKCustomUIAdopter attributedString:@[@"Temperature threshold",@"   (-20℃~60℃)"] fonts:@[MKFont(13.f),MKFont(11.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _msgLabe;
}

- (MKSlider *)temperSlider {
    if (!_temperSlider) {
        _temperSlider = [[MKSlider alloc] init];
        _temperSlider.maximumValue = 60.f;
        _temperSlider.minimumValue = -20.f;
        _temperSlider.value = 0.f;
        [_temperSlider addTarget:self
                          action:@selector(sliderValueChanged)
                forControlEvents:UIControlEventValueChanged];
    }
    return _temperSlider;
}

- (UILabel *)sliderValueLabel {
    if (!_sliderValueLabel) {
        _sliderValueLabel = [self createMsgLabel:MKFont(12.f)];
        _sliderValueLabel.text = @"0℃";
    }
    return _sliderValueLabel;
}

- (UIImageView *)startIcon {
    if (!_startIcon) {
        _startIcon = [[UIImageView alloc] init];
        _startIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigSelectedIcon.png");
    }
    return _startIcon;
}

- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [self createMsgLabel:MKFont(11.f)];
        _startLabel.text = @"Start advertising";
        [_startLabel addTapAction:self selector:@selector(startLabelPressed)];
    }
    return _startLabel;
}

- (UIImageView *)stopIcon {
    if (!_stopIcon) {
        _stopIcon = [[UIImageView alloc] init];
        _stopIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTemperatureView", @"mk_bx_slotConfigUnselectedIcon.png");
    }
    return _stopIcon;
}

- (UILabel *)stopLabel {
    if (!_stopLabel) {
        _stopLabel = [self createMsgLabel:MKFont(11.f)];
        _stopLabel.text = @"Stop advertising";
        [_stopLabel addTapAction:self selector:@selector(stopLabelPressed)];
    }
    return _stopLabel;
}

- (UILabel *)noteMsgLabel {
    if (!_noteMsgLabel) {
        _noteMsgLabel = [[UILabel alloc] init];
        _noteMsgLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteMsgLabel.textAlignment = NSTextAlignmentLeft;
        _noteMsgLabel.numberOfLines = 0;
        _noteMsgLabel.font = MKFont(11.f);
    }
    return _noteMsgLabel;
}

- (UILabel *)createMsgLabel:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
