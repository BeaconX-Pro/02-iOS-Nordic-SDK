//
//  MKWifiAlertView.m
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKWifiAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"

static CGFloat const alertViewHeight = 230.f;

@interface MKWifiAlertView ()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *ssidLabel;

@property (nonatomic, strong)MKTextField *ssidField;

@property (nonatomic, strong)UILabel *passwordLabel;

@property (nonatomic, strong)MKTextField *passwordField;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)UIView *verticalLine;

@property (nonatomic, strong)UIButton *cancelButton;

@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic, copy)void (^confirmAction)(NSString *ssid, NSString *password);

@end

@implementation MKWifiAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBCOLOR(102, 102, 102)];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.ssidLabel];
        [self.alertView addSubview:self.ssidField];
        [self.alertView addSubview:self.passwordLabel];
        [self.alertView addSubview:self.passwordField];
        [self.alertView addSubview:self.horizontalLine];
        [self.alertView addSubview:self.verticalLine];
        [self.alertView addSubview:self.cancelButton];
        [self.alertView addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).mas_offset(37.f);
        make.width.mas_equalTo(self.frame.size.width - 2 * 37.f);
        make.top.mas_equalTo(150.f);
        make.height.mas_equalTo(alertViewHeight);
    }];
    CGFloat width = self.frame.size.width - 2 * 37.f;
    CGSize titleSize = [NSString sizeWithText:self.titleLabel.text
                                      andFont:self.titleLabel.font
                                   andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.ssidLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.ssidField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.ssidField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ssidLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.passwordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.passwordField.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.passwordField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.passwordLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.ssidField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45.f);
        make.height.mas_equalTo(0.5f);
    }];
    [self.verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.width.mas_equalTo(0.5f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.verticalLine.mas_left);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.verticalLine.mas_right);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45.f);
    }];
}

#pragma mark - event method
- (void)cancelButtonPressed {
    [self dismiss];
}

- (void)confirmButtonPressed {
    if (self.confirmAction) {
        self.confirmAction(self.ssidField.text,self.passwordField.text);
    }
    [self dismiss];
}

#pragma mark - public method
- (void)showWithConfirmBlock:(void (^)(NSString *ssid, NSString *password))confirmBlock {
    [kAppWindow addSubview:self];
    self.confirmAction = nil;
    self.confirmAction = confirmBlock;
    [UIView animateWithDuration:.3f animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(-kViewWidth, 0);
    }];
}

#pragma mark - private method
- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - getter
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        [_alertView setBackgroundColor:COLOR_WHITE_MACROS];
        [_alertView.layer setMasksToBounds:YES];
        [_alertView.layer setBorderColor:CUTTING_LINE_COLOR.CGColor];
        [_alertView.layer setBorderWidth:0.5f];
        [_alertView.layer setCornerRadius:5.f];
    }
    return _alertView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.font = MKFont(18.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"Please enter Wi-Fi information";
    }
    return _titleLabel;
}

- (UILabel *)ssidLabel {
    if (!_ssidLabel) {
        _ssidLabel = [[UILabel alloc] init];
        _ssidLabel.textColor = DEFAULT_TEXT_COLOR;
        _ssidLabel.font = MKFont(14.f);
        _ssidLabel.textAlignment = NSTextAlignmentLeft;
        _ssidLabel.text = @"SSID";
    }
    return _ssidLabel;
}

- (MKTextField *)ssidField {
    if (!_ssidField) {
        _ssidField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _ssidField.maxLength = 32;
        _ssidField.placeholder = @"1-32 Characters";
        _ssidField.borderStyle = UITextBorderStyleNone;
        _ssidField.font = MKFont(13.f);
        _ssidField.textColor = DEFAULT_TEXT_COLOR;
        
        _ssidField.backgroundColor = COLOR_WHITE_MACROS;
        _ssidField.layer.masksToBounds = YES;
        _ssidField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _ssidField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _ssidField.layer.cornerRadius = 6.f;
    }
    return _ssidField;
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

- (MKTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _passwordField.maxLength = 64;
        _passwordField.placeholder = @"0-64 Characters";
        _passwordField.borderStyle = UITextBorderStyleNone;
        _passwordField.font = MKFont(13.f);
        _passwordField.textColor = DEFAULT_TEXT_COLOR;
        
        _passwordField.backgroundColor = COLOR_WHITE_MACROS;
        _passwordField.layer.masksToBounds = YES;
        _passwordField.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _passwordField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _passwordField.layer.cornerRadius = 6.f;
    }
    return _passwordField;
}

- (UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
    }
    return _horizontalLine;
}

- (UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = UIColorFromRGB(0xd9d9d9);
    }
    return _verticalLine;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton.titleLabel setFont:MKFont(18.f)];
        [_cancelButton setTitleColor:UIColorFromRGB(0x0188cc) forState:UIControlStateNormal];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTapAction:self selector:@selector(cancelButtonPressed)];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton.titleLabel setFont:MKFont(18.f)];
        [_confirmButton setTitleColor:UIColorFromRGB(0x0188cc) forState:UIControlStateNormal];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton addTapAction:self selector:@selector(confirmButtonPressed)];
    }
    return _confirmButton;
}

@end
