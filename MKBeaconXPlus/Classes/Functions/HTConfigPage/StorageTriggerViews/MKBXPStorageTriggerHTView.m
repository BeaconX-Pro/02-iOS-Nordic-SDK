//
//  MKBXPStorageTriggerHTView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPStorageTriggerHTView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPickerView.h"

@interface MKBXPStorageTriggerHTView ()

@property (nonatomic, strong)UILabel *tempLabel;

@property (nonatomic, strong)UIButton *tempButton;

@property (nonatomic, strong)UILabel *tempUnitLabel;

@property (nonatomic, strong)NSMutableArray *tempList;

@property (nonatomic, strong)UILabel *humidityLabel;

@property (nonatomic, strong)UIButton *humidityButton;

@property (nonatomic, strong)UILabel *humidityUnitLabel;

@property (nonatomic, strong)NSMutableArray *humidityList;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKBXPStorageTriggerHTView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tempLabel];
        [self addSubview:self.tempButton];
        [self addSubview:self.tempUnitLabel];
        [self addSubview:self.humidityLabel];
        [self addSubview:self.humidityButton];
        [self addSubview:self.humidityUnitLabel];
        [self addSubview:self.noteLabel];
        [self loadListDatas];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tempLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.tempButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.tempButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.tempUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tempButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(self.tempButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    
    [self.humidityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(85.f);
        make.centerY.mas_equalTo(self.humidityButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.humidityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.humidityLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.tempButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.humidityUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.humidityButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(self.humidityButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 5.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.bottom.mas_equalTo(-5.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - event method
- (void)tempButtonPressed {
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = self.tempList;
    [pickView showPickViewWithIndex:[self getCurrentTempIndex] block:^(NSInteger currentRow) {
        [self.tempButton setTitle:self.tempList[currentRow] forState:UIControlStateNormal];
        [self updateNoteMsg];
    }];
}

- (void)humidityButtonPressed {
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = self.humidityList;
    [pickView showPickViewWithIndex:[self getCurrentHumidityIndex] block:^(NSInteger currentRow) {
        [self.humidityButton setTitle:self.humidityList[currentRow] forState:UIControlStateNormal];
        [self updateNoteMsg];
    }];
}

#pragma mark - public method
- (void)updateTemperature:(NSString *)temperature humidity:(NSString *)humidity {
    if (!ValidStr(temperature) || !ValidStr(humidity)) {
        return;
    }
    [self.tempButton setTitle:temperature forState:UIControlStateNormal];
    [self.humidityButton setTitle:humidity forState:UIControlStateNormal];
    [self updateNoteMsg];
}

- (NSString *)getCurrentTemperature {
    return self.tempButton.titleLabel.text;
}

- (NSString *)getCurrentHumidity {
    return self.humidityButton.titleLabel.text;
}

#pragma mark - private method
- (void)updateNoteMsg {
    self.noteLabel.text = [NSString stringWithFormat:@"*The device stores T&H data when the temperature changed ≥ %@ ℃ or humidity changed ≥ %@%@.",self.tempButton.titleLabel.text,self.humidityButton.titleLabel.text,@"%RH"];
    [self setNeedsLayout];
}

- (NSInteger)getCurrentTempIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.tempList.count; i ++) {
        if ([self.tempButton.titleLabel.text isEqualToString:self.tempList[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

- (NSInteger)getCurrentHumidityIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.humidityList.count; i ++) {
        if ([self.humidityButton.titleLabel.text isEqualToString:self.humidityList[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

- (void)loadListDatas {
    for (NSInteger i = 1; i <= 120; i ++) {
        NSString *value = [NSString stringWithFormat:@"%.1f",(i * 0.5)];
        [self.tempList addObject:value];
    }
    for (NSInteger i = 1; i <= 190; i ++) {
        NSString *value = [NSString stringWithFormat:@"%.1f",(i * 0.5)];
        [self.humidityList addObject:value];
    }
}

#pragma mark - getter
- (UILabel *)tempLabel {
    if (!_tempLabel) {
        _tempLabel = [self loadMsgLabelWithMsg:@"Temperature"];
    }
    return _tempLabel;
}

- (UIButton *)tempButton {
    if (!_tempButton) {
        _tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tempButton setTitle:@"0.5" forState:UIControlStateNormal];
        [_tempButton.titleLabel setFont:MKFont(12.f)];
        [_tempButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_tempButton addTarget:self
                        action:@selector(tempButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
        
        _tempButton.layer.masksToBounds = YES;
        _tempButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _tempButton.layer.borderWidth = 0.5f;
        _tempButton.layer.cornerRadius = 6.f;
    }
    return _tempButton;
}

- (UILabel *)tempUnitLabel {
    if (!_tempUnitLabel) {
        _tempUnitLabel = [self loadMsgLabelWithMsg:@"℃"];
    }
    return _tempUnitLabel;
}

- (NSMutableArray *)tempList {
    if (!_tempList) {
        _tempList = [NSMutableArray array];
    }
    return _tempList;
}

- (UILabel *)humidityLabel {
    if (!_humidityLabel) {
        _humidityLabel = [self loadMsgLabelWithMsg:@"Humidity"];
    }
    return _humidityLabel;
}

- (UIButton *)humidityButton {
    if (!_humidityButton) {
        _humidityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_humidityButton setTitle:@"0.5" forState:UIControlStateNormal];
        [_humidityButton.titleLabel setFont:MKFont(12.f)];
        [_humidityButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_humidityButton addTarget:self
                            action:@selector(humidityButtonPressed)
                  forControlEvents:UIControlEventTouchUpInside];
        
        _humidityButton.layer.masksToBounds = YES;
        _humidityButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _humidityButton.layer.borderWidth = 0.5f;
        _humidityButton.layer.cornerRadius = 6.f;
    }
    return _humidityButton;
}

- (UILabel *)humidityUnitLabel {
    if (!_humidityUnitLabel) {
        _humidityUnitLabel = [self loadMsgLabelWithMsg:@"%RH"];
    }
    return _humidityUnitLabel;
}

- (NSMutableArray *)humidityList {
    if (!_humidityList) {
        _humidityList = [NSMutableArray array];
    }
    return _humidityList;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"*The device stores T&H data when the temperature changed ≥ 0 ℃ or humidity changed ≥ 0%RH.";
    }
    return _noteLabel;
}

- (UILabel *)loadMsgLabelWithMsg:(NSString *)msg {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.font = MKFont(13.f);
    msgLabel.text = msg;
    return msgLabel;
}

@end
