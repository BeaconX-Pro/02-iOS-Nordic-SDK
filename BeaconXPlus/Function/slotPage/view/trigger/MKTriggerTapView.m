//
//  MKTriggerTapView.m
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKTriggerTapView.h"

@interface MKTriggerTapView ()

@property (nonatomic, strong)UIImageView *icon1;

@property (nonatomic, strong)UIImageView *icon2;

@property (nonatomic, strong)UIImageView *icon3;

@property (nonatomic, strong)UIImageView *icon4;

@property (nonatomic, strong)UILabel *msgLabel1;

@property (nonatomic, strong)UILabel *msgLabel2;

@property (nonatomic, strong)UILabel *msgLabel3;

@property (nonatomic, strong)UILabel *msgLabel4;

@property (nonatomic, strong)UILabel *unitLabel1;

@property (nonatomic, strong)UILabel *unitLabel2;

@property (nonatomic, strong)UITextField *startField;

@property (nonatomic, strong)UITextField *stopField;

@property (nonatomic, strong)UILabel *noteMsgLabel;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)MKTriggerTapViewType viewType;

@end

@implementation MKTriggerTapView

- (instancetype)initWithType:(MKTriggerTapViewType)type {
    self = [self init];
    if (self) {
        _viewType = type;
        self.msgLabel2.text = (_viewType == MKTriggerTapViewDeviceMoves) ? @"Stop advertising after a static period of time" : @"Start advertising for a while";
        self.msgLabel4.text = (_viewType == MKTriggerTapViewDeviceMoves) ? @"Start advertising after a static period of time" : @"Stop advertising for a while";
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon1];
        [self addSubview:self.icon2];
        [self addSubview:self.icon3];
        [self addSubview:self.icon4];
        [self addSubview:self.msgLabel1];
        [self addSubview:self.msgLabel2];
        [self addSubview:self.msgLabel3];
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
    
    CGSize msgSize1 = [NSString sizeWithText:self.msgLabel1.text andFont:self.msgLabel1.font andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
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
    
    CGSize msgSize2 = [NSString sizeWithText:self.msgLabel2.text andFont:self.msgLabel2.font andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
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
    
    CGSize msgSize3 = [NSString sizeWithText:self.msgLabel3.text andFont:self.msgLabel3.font andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon3.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.msgLabel2.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MAX(msgLabelDefaultHeight, msgSize3.height));
    }];
    [self.icon3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.msgLabel3.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    
    CGSize msgSize4 = [NSString sizeWithText:self.msgLabel4.text andFont:self.msgLabel4.font andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon4.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(self.msgLabel3.mas_bottom).mas_offset(10.f);
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
}

- (void)msgLabel2Pressed {
    if (self.index == 1) {
        return;
    }
    self.index = 1;
    [self updateSelectedIcon];
    [self updateNoteMsg];
}

- (void)msgLabel3Pressed {
    if (self.index == 2) {
        return;
    }
    self.index = 2;
    [self updateSelectedIcon];
    [self updateNoteMsg];
}

- (void)msgLabel4Pressed {
    if (self.index == 3) {
        return;
    }
    self.index = 3;
    [self updateSelectedIcon];
    [self updateNoteMsg];
}

- (void)startTextFieldValueChanged {
    if (self.index != 1) {
        return;
    }
    [self updateNoteMsg];
}

- (void)stopTextFieldValueChanged {
    if (self.index != 3) {
        return;
    }
    [self updateNoteMsg];
}

#pragma mark - public method
- (void)updateIndex:(NSInteger)index timeValue:(NSString *)time {
    self.index = index;
    if (self.index == 1) {
        self.startField.text = time;
    }
    if (self.index == 3) {
        self.stopField.text = time;
    }
    [self updateSelectedIcon];
    [self updateNoteMsg];
}

#pragma mark - private method
- (void)updateNoteMsg {
    if (self.viewType == MKTriggerTapViewDeviceMoves) {
        if (self.index == 0) {
            self.noteMsgLabel.text = @"The device will always advertise if the device moves.";
            return;
        }
        if (self.index == 1) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will stop advertising after a static period of %@s and it starts advertising again if the device moves.",self.startField.text];
        }
        if (self.index == 2) {
            self.noteMsgLabel.text = @"The device will always stop advertising if the device moves.";
            return;
        }
        if (self.index == 3) {
            self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will start advertising after a static period of %@s and it starts advertising again if the device moves.",self.stopField.text];
        }
        return;
    }
    NSString *typeString = (self.viewType == MKTriggerTapViewTriple) ? @"triple" : @"double";
    if (self.index == 0) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will always advertise if the button %@ tapped.",typeString];
        return;
    }
    if (self.index == 1) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will start advertising for %@s if the button %@ tapped.",self.startField.text,typeString];
        return;
    }
    if (self.index == 2) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will always stop advertising if the button %@ tapped.",typeString];
        return;
    }
    if (self.index == 3) {
        self.noteMsgLabel.text = [NSString stringWithFormat:@"The device will stop advertising for %@s if the button %@ tapped.",self.stopField.text,typeString];
        return;
    }
}

- (void)updateSelectedIcon {
    self.icon1.image = (self.index == 0) ? LOADIMAGE(@"slot_paramsConfig_selectedIcon", @"png") : LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
    self.icon2.image = (self.index == 1) ? LOADIMAGE(@"slot_paramsConfig_selectedIcon", @"png") : LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
    self.icon3.image = (self.index == 2) ? LOADIMAGE(@"slot_paramsConfig_selectedIcon", @"png") : LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
    self.icon4.image = (self.index == 3) ? LOADIMAGE(@"slot_paramsConfig_selectedIcon", @"png") : LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
}

#pragma mark - setter & getter

- (UIImageView *)icon1 {
    if (!_icon1) {
        _icon1 = [[UIImageView alloc] init];
        _icon1.image = LOADIMAGE(@"slot_paramsConfig_selectedIcon", @"png");
    }
    return _icon1;
}

- (UIImageView *)icon2 {
    if (!_icon2) {
        _icon2 = [[UIImageView alloc] init];
        _icon2.image = LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
    }
    return _icon2;
}

- (UIImageView *)icon3 {
    if (!_icon3) {
        _icon3 = [[UIImageView alloc] init];
        _icon3.image = LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
    }
    return _icon3;
}

- (UIImageView *)icon4 {
    if (!_icon4) {
        _icon4 = [[UIImageView alloc] init];
        _icon4.image = LOADIMAGE(@"slot_paramsConfig_unselectedIcon", @"png");
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

- (UILabel *)msgLabel3 {
    if (!_msgLabel3) {
        _msgLabel3 = [self createMsgLabel:MKFont(11.f)];
        _msgLabel3.text = @"Always stop advertising";
        [_msgLabel3 addTapAction:self selector:@selector(msgLabel3Pressed)];
    }
    return _msgLabel3;
}

- (UILabel *)msgLabel4 {
    if (!_msgLabel4) {
        _msgLabel4 = [self createMsgLabel:MKFont(11.f)];
        [_msgLabel4 addTapAction:self selector:@selector(msgLabel4Pressed)];
    }
    return _msgLabel4;
}

- (UITextField *)startField {
    if (!_startField) {
        _startField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _startField.textColor = DEFAULT_TEXT_COLOR;
        _startField.textAlignment = NSTextAlignmentCenter;
        _startField.font = MKFont(12.f);
        _startField.borderStyle = UITextBorderStyleNone;
        _startField.text = @"30";
        [_startField addTarget:self
                        action:@selector(startTextFieldValueChanged)
              forControlEvents:UIControlEventEditingChanged];
        
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

- (UITextField *)stopField {
    if (!_stopField) {
        _stopField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _stopField.textColor = DEFAULT_TEXT_COLOR;
        _stopField.textAlignment = NSTextAlignmentCenter;
        _stopField.font = MKFont(12.f);
        _stopField.borderStyle = UITextBorderStyleNone;
        _stopField.text = @"30";
        [_stopField addTarget:self
                       action:@selector(stopTextFieldValueChanged)
             forControlEvents:UIControlEventEditingChanged];
        
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
        _unitLabel1.attributedText = [MKAttributedString getAttributedString:@[@"s",@"  (1~65535)"] fonts:@[MKFont(11.f),MKFont(10.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _unitLabel1;
}

- (UILabel *)unitLabel2 {
    if (!_unitLabel2) {
        _unitLabel2 = [[UILabel alloc] init];
        _unitLabel2.textAlignment = NSTextAlignmentLeft;
        _unitLabel2.attributedText = [MKAttributedString getAttributedString:@[@"s",@"  (1~65535)"] fonts:@[MKFont(11.f),MKFont(10.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
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
