//
//  MKBXTriggerTapView.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTriggerTapView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

@implementation MKBXTriggerTapViewModel

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)setStartValue:(NSString *)startValue {
    _startValue = nil;
    _startValue = startValue;
}

- (void)setStopValue:(NSString *)stopValue {
    _stopValue = nil;
    _stopValue = stopValue;
}

@end

@interface MKBXTriggerTapView ()

@property (nonatomic, strong)UIImageView *icon1;

@property (nonatomic, strong)UIImageView *icon2;

@property (nonatomic, strong)UIImageView *icon4;

@property (nonatomic, strong)UILabel *msgLabel1;

@property (nonatomic, strong)UILabel *msgLabel2;

@property (nonatomic, strong)UILabel *msgLabel4;

@property (nonatomic, strong)UILabel *unitLabel1;

@property (nonatomic, strong)UILabel *unitLabel2;

@property (nonatomic, strong)MKTextField *startField;

@property (nonatomic, strong)MKTextField *stopField;

@property (nonatomic, strong)UILabel *noteMsgLabel;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKBXTriggerTapView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon1];
        [self addSubview:self.icon2];
        [self addSubview:self.icon4];
        [self addSubview:self.msgLabel1];
        [self addSubview:self.msgLabel2];
        [self addSubview:self.msgLabel4];
        [self addSubview:self.unitLabel1];
        [self addSubview:self.unitLabel2];
        [self addSubview:self.startField];
        [self addSubview:self.stopField];
        [self addSubview:self.noteMsgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat textFieldWidth = 65.f;
    CGFloat unitLabelWidth = 75.f;
    CGFloat msgLabelWidth = self.frame.size.width - textFieldWidth - unitLabelWidth - 15.f - 10.f;
    CGFloat msgLabelDefaultHeight = 25.f;
    
    CGSize msgSize1 = [NSString sizeWithText:self.msgLabel1.text
                                     andFont:self.msgLabel1.font
                                  andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon1.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MAX(msgLabelDefaultHeight, msgSize1.height));
    }];
    [self.icon1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.msgLabel1.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    
    CGSize msgSize2 = [NSString sizeWithText:self.msgLabel2.text
                                     andFont:self.msgLabel2.font
                                  andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon2.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.msgLabel1.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MAX(msgLabelDefaultHeight, msgSize2.height));
    }];
    [self.icon2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.msgLabel2.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    
    [self.startField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel1.mas_left).mas_offset(-1.f);
        make.width.mas_equalTo(textFieldWidth);
        make.centerY.mas_equalTo(self.msgLabel2.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.unitLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.msgLabel2.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    
    CGSize msgSize4 = [NSString sizeWithText:self.msgLabel4.text
                                     andFont:self.msgLabel4.font
                                  andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon4.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.msgLabel2.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MAX(msgLabelDefaultHeight, msgSize4.height));
    }];
    [self.icon4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.msgLabel4.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    
    [self.stopField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.unitLabel2.mas_left).mas_offset(-1.f);
        make.width.mas_equalTo(textFieldWidth);
        make.centerY.mas_equalTo(self.msgLabel4.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.unitLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.msgLabel4.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.noteMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.stopField.mas_bottom).mas_offset(5.f);
        make.bottom.mas_equalTo(-10.f);
    }];
}

#pragma mark - event method
- (void)msgLabel1Pressed {
    if (self.index == 0) {
        return;
    }
    self.index = 0;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate mk_bx_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)msgLabel2Pressed {
    if (self.index == 1) {
        return;
    }
    self.index = 1;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate mk_bx_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)msgLabel4Pressed {
    if (self.index == 2) {
        return;
    }
    self.index = 2;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate mk_bx_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)startTextFieldValueChanged:(NSString *)text {
    if (self.index != 1) {
        return;
    }
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTapViewStartValueChanged:viewType:)]) {
        [self.delegate mk_bx_triggerTapViewStartValueChanged:text viewType:self.dataModel.viewType];
    }
}

- (void)stopTextFieldValueChanged:(NSString *)text {
    if (self.index != 2) {
        return;
    }
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerTapViewStopValueChanged:viewType:)]) {
        [self.delegate mk_bx_triggerTapViewStopValueChanged:text viewType:self.dataModel.viewType];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTriggerTapViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.index = _dataModel.index;
    self.startField.text = _dataModel.startValue;
    self.stopField.text = _dataModel.stopValue;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if (_dataModel.viewType == MKBXTriggerTapViewDeviceMoves) {
        self.msgLabel2.text = @"Start advertising after device keep static for";
        self.msgLabel4.text = @"Stop advertising after device keep static for";
    }else if (_dataModel.viewType == MKBXTriggerTapViewAmbientLightDetected) {
        self.msgLabel2.text = @"Start advertising after ambient light continuously detected for";
        self.msgLabel4.text = @"Stop advertising after ambient light continuously detected for";
    }else {
        self.msgLabel2.text = @"Start advertising for";
        self.msgLabel4.text = @"Stop advertising for";
    }
    [self setNeedsLayout];
}

#pragma mark - private method
- (void)updateNoteMsg {
    if (self.dataModel.viewType == MKBXTriggerTapViewDeviceMoves) {
        if (self.index == 0) {
            self.noteMsgLabel.text = @"*The Beacon will start and keep advertising once a movement occurred.";
            return;
        }
        if (self.index == 1) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising after device keep static for %@s and it stops broadcasting again once a movement occurred.",self.startField.text];
        }
        if (self.index == 2) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will stop advertising after device keep static for %@s and it starts advertising again once a movement occurred.",self.stopField.text];
        }
        [self setNeedsLayout];
        return;
    }
    if (self.dataModel.viewType == MKBXTriggerTapViewAmbientLightDetected) {
        //光感
        if (self.index == 0) {
            self.noteMsgLabel.text = @"*The Beacon will start and keep advertising after ambient light detected.";
            return;
        }
        if (self.index == 1) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising after device detected ambient light continuously for %@s.",self.startField.text];
        }
        if (self.index == 2) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will stop advertising after device detected ambient light continuously for %@s.",self.stopField.text];
        }
        [self setNeedsLayout];
        return;
    }
    NSString *typeString = (self.dataModel.viewType == MKBXTriggerTapViewTriple) ? @"three times" : @"twice";
    if (self.index == 0) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start and keep advertising after press the button %@.",typeString];
        [self setNeedsLayout];
        return;
    }
    if (self.index == 1) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising for %@s after press the button %@.",self.startField.text,typeString];
        [self setNeedsLayout];
        return;
    }
    if (self.index == 2) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will stop advertising for %@s after press the button %@.",self.stopField.text,typeString];
        [self setNeedsLayout];
        return;
    }
}

- (void)updateSelectedIcon {
    self.icon1.image = (self.index == 0) ? LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigUnselectedIcon.png");
    self.icon2.image = (self.index == 1) ? LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigUnselectedIcon.png");
    self.icon4.image = (self.index == 2) ? LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigUnselectedIcon.png");
}

#pragma mark - setter & getter

- (UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc] init];
        _icon1.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigSelectedIcon.png");
    }
    return _icon1;
}

- (UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc] init];
        _icon2.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigUnselectedIcon.png");
    }
    return _icon2;
}

- (UIImageView *)icon4 {
    if (!_icon4) {
        _icon4 = [[UIImageView alloc] init];
        _icon4.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXTriggerTapView", @"mk_bx_slotConfigUnselectedIcon.png");
    }
    return _icon4;
}

- (UILabel *)msgLabel1 {
    if (!_msgLabel1) {
        _msgLabel1 = [self createMsgLabel:MKFont(11.f)];
        _msgLabel1.text = @"Start and keep advertising";
        [_msgLabel1 addTapAction:self selector:@selector(msgLabel1Pressed)];
    }
    return _msgLabel1;
}

- (UILabel *)msgLabel2 {
    if (!_msgLabel2) {
        _msgLabel2 = [self createMsgLabel:MKFont(11.f)];
        [_msgLabel2 addTapAction:self selector:@selector(msgLabel2Pressed)];
    }
    return _msgLabel2;
}

- (UILabel *)msgLabel4 {
    if (!_msgLabel4) {
        _msgLabel4 = [self createMsgLabel:MKFont(11.f)];
        [_msgLabel4 addTapAction:self selector:@selector(msgLabel4Pressed)];
    }
    return _msgLabel4;
}

- (MKTextField *)startField {
    if (!_startField) {
        @weakify(self);
        _startField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _startField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self startTextFieldValueChanged:text];
        };
        _startField.textColor = DEFAULT_TEXT_COLOR;
        _startField.textAlignment = NSTextAlignmentCenter;
        _startField.font = MKFont(12.f);
        _startField.borderStyle = UITextBorderStyleNone;
        _startField.text = @"30";
        _startField.maxLength = 5;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_startField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _startField;
}

- (MKTextField *)stopField {
    if (!_stopField) {
        @weakify(self);
        _stopField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
        _stopField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self stopTextFieldValueChanged:text];
        };
        _stopField.textColor = DEFAULT_TEXT_COLOR;
        _stopField.textAlignment = NSTextAlignmentCenter;
        _stopField.font = MKFont(12.f);
        _stopField.borderStyle = UITextBorderStyleNone;
        _stopField.text = @"30";
        _stopField.maxLength = 5;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_stopField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _stopField;
}

- (UILabel *)unitLabel1 {
    if (!_unitLabel1) {
        _unitLabel1 = [[UILabel alloc] init];
        _unitLabel1.textAlignment = NSTextAlignmentLeft;
        _unitLabel1.attributedText = [MKCustomUIAdopter attributedString:@[@"s",@"  (1~65535)"] fonts:@[MKFont(11.f),MKFont(10.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _unitLabel1;
}

- (UILabel *)unitLabel2 {
    if (!_unitLabel2) {
        _unitLabel2 = [[UILabel alloc] init];
        _unitLabel2.textAlignment = NSTextAlignmentLeft;
        _unitLabel2.attributedText = [MKCustomUIAdopter attributedString:@[@"s",@"  (1~65535)"] fonts:@[MKFont(11.f),MKFont(10.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _unitLabel2;
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
    label.numberOfLines = 0;
    return label;
}

@end
