//
//  MKMQTTUserCredentialsView.m
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMQTTUserCredentialsView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

@implementation MKMQTTUserCredentialsViewModel
@end

@interface MKMQTTUserCredentialsView ()

@property (nonatomic, strong)UILabel *userNameLabel;

@property (nonatomic, strong)MKTextField *userNameTextField;

@property (nonatomic, strong)UILabel *passwordLabel;

@property(nonatomic, strong)MKTextField *passwordTextField;

@end

@implementation MKMQTTUserCredentialsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.userNameLabel];
        [self addSubview:self.userNameTextField];
        [self addSubview:self.passwordLabel];
        [self addSubview:self.passwordTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.userNameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.userNameLabel.mas_centerY);
        make.height.mas_equalTo(self.userNameLabel.mas_height);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.passwordTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userNameLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.passwordLabel.mas_centerY);
        make.height.mas_equalTo(self.passwordLabel.mas_height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKMQTTUserCredentialsViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKMQTTUserCredentialsViewModel.class]) {
        return;
    }
    self.userNameTextField.text = _dataModel.userName;
    self.passwordTextField.text = _dataModel.password;
}

#pragma mark - getter
- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = MKFont(14.f);
        _userNameLabel.text = @"Username";
    }
    return _userNameLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.textColor = DEFAULT_TEXT_COLOR;
        _passwordLabel.textAlignment = NSTextAlignmentLeft;
        _passwordLabel.font = MKFont(14.f);
        _passwordLabel.text = @"Password";
    }
    return _passwordLabel;
}

- (MKTextField *)userNameTextField {
    if (!_userNameTextField) {
        _userNameTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        @weakify(self);
        _userNameTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(mk_mqtt_userCredentials_userNameChanged:)]) {
                [self.delegate mk_mqtt_userCredentials_userNameChanged:text];
            }
        };
        _userNameTextField.maxLength = 256;
        _userNameTextField.placeholder = @"0-256 Characters";
        _userNameTextField.borderStyle = UITextBorderStyleNone;
        _userNameTextField.font = MKFont(13.f);
        _userNameTextField.textColor = DEFAULT_TEXT_COLOR;
        
        _userNameTextField.backgroundColor = COLOR_WHITE_MACROS;
        _userNameTextField.layer.masksToBounds = YES;
        _userNameTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _userNameTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _userNameTextField.layer.cornerRadius = 6.f;
    }
    return _userNameTextField;
}

- (MKTextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        @weakify(self);
        _passwordTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(mk_mqtt_userCredentials_passwordChanged:)]) {
                [self.delegate mk_mqtt_userCredentials_passwordChanged:text];
            }
        };
        _passwordTextField.maxLength = 256;
        _passwordTextField.placeholder = @"0-256 Characters";
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.font = MKFont(13.f);
        _passwordTextField.textColor = DEFAULT_TEXT_COLOR;
        
        _passwordTextField.backgroundColor = COLOR_WHITE_MACROS;
        _passwordTextField.layer.masksToBounds = YES;
        _passwordTextField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _passwordTextField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _passwordTextField.layer.cornerRadius = 6.f;
    }
    return _passwordTextField;
}

@end
