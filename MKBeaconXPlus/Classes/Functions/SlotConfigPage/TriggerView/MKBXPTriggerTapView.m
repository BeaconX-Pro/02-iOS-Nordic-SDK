//
//  MKBXPTriggerTapView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPTriggerTapView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKTextField.h"

@implementation MKBXPTriggerTapViewModel

- (void)dealloc {
    NSLog(@"++++++++++MKBXPTriggerTapViewModel销毁");
}

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

@interface MKBXPTriggerTapView ()

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

@implementation MKBXPTriggerTapView

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
    if ([self.delegate respondsToSelector:@selector(bxp_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate bxp_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)msgLabel2Pressed {
    if (self.index == 1) {
        return;
    }
    self.index = 1;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate bxp_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)msgLabel4Pressed {
    if (self.index == 2) {
        return;
    }
    self.index = 2;
    [self updateSelectedIcon];
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerTapViewIndexChanged:viewType:)]) {
        [self.delegate bxp_triggerTapViewIndexChanged:self.index viewType:self.dataModel.viewType];
    }
}

- (void)startTextFieldValueChanged:(NSString *)text {
    if (self.index != 1) {
        return;
    }
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerTapViewStartValueChanged:viewType:)]) {
        [self.delegate bxp_triggerTapViewStartValueChanged:text viewType:self.dataModel.viewType];
    }
}

- (void)stopTextFieldValueChanged:(NSString *)text {
    if (self.index != 2) {
        return;
    }
    [self updateNoteMsg];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerTapViewStopValueChanged:viewType:)]) {
        [self.delegate bxp_triggerTapViewStopValueChanged:text viewType:self.dataModel.viewType];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXPTriggerTapViewModel *)dataModel {
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
    self.msgLabel2.text = (_dataModel.viewType == MKBXPTriggerTapViewDeviceMoves) ? @"Stop advertising after a static period of time" : @"Start advertising for a while";
    self.msgLabel4.text = (_dataModel.viewType == MKBXPTriggerTapViewDeviceMoves) ? @"Start advertising after a static period of time" : @"Stop advertising for a while";
}

#pragma mark - private method
- (void)updateNoteMsg {
    if (self.dataModel.viewType == MKBXPTriggerTapViewDeviceMoves) {
        if (self.index == 0) {
            self.noteMsgLabel.text = @"*The Beacon will always broadcast once a movement occurred.";
            return;
        }
        if (self.index == 1) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will stop broadcasting after a static period of %@s and it starts to broadcast again once a movement occurred.",self.startField.text];
        }
        if (self.index == 2) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start to broadcast after a static period of %@s and it stops broadcasting again once a movement occurred.",self.stopField.text];
        }
        return;
    }
    NSString *typeString = (self.dataModel.viewType == MKBXPTriggerTapViewTriple) ? @"three times" : @"twice";
    if (self.index == 0) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will always broadcast after press the button %@.",typeString];
        return;
    }
    if (self.index == 1) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will start to broadcast for %@s after press button %@.",self.startField.text,typeString];
        return;
    }
    if (self.index == 2) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"*The Beacon will stop broadcasting for %@s after press the button %@.",self.stopField.text,typeString];
        return;
    }
}

- (void)updateSelectedIcon {
    self.icon1.image = (self.index == 0) ? LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_selectedIcon.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_unselectedIcon.png");
    self.icon2.image = (self.index == 1) ? LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_selectedIcon.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_unselectedIcon.png");
    self.icon4.image = (self.index == 2) ? LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_selectedIcon.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_unselectedIcon.png");
}

#pragma mark - setter & getter

- (UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc] init];
        _icon1.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_selectedIcon.png");
    }
    return _icon1;
}

- (UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc] init];
        _icon2.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_unselectedIcon.png");
    }
    return _icon2;
}

- (UIImageView *)icon4 {
    if (!_icon4) {
        _icon4 = [[UIImageView alloc] init];
        _icon4.image = LOADICON(@"MKBeaconXPlus", @"MKBXPTriggerTapView", @"bxp_slot_paramsConfig_unselectedIcon.png");
    }
    return _icon4;
}

- (UILabel *)msgLabel1 {
    if (!_msgLabel1) {
        _msgLabel1 = [self createMsgLabel:MKFont(11.f)];
        _msgLabel1.text = @"Always advertise";
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
