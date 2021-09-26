//
//  MKMQTTSSLCertificateView.m
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMQTTSSLCertificateView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKMQTTSSLCertificateViewModel
@end

@interface MKMQTTSSLCertificateView ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *certificateLabel;

@property (nonatomic, strong)UIButton *certificateButton;

@end

@implementation MKMQTTSSLCertificateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.msgLabel];
        [self addSubview:self.certificateLabel];
        [self addSubview:self.certificateButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = [NSString sizeWithText:self.certificateLabel.text
                                 andFont:self.certificateLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 15.f - 120.f -  2 * 10.f - 40.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    [self.certificateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.certificateButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(size.height);
    }];
    [self.certificateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)certificateButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_fileSelectedButtonPressed:)]) {
        [self.delegate mk_fileSelectedButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKMQTTSSLCertificateViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKMQTTSSLCertificateViewModel.class]) {
        return;
    }
    self.msgLabel.text = _dataModel.msg;
    self.certificateLabel.text = _dataModel.fileName;
    [self setNeedsLayout];
}

#pragma mark - getter

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(14.f);
    }
    return _msgLabel;
}

- (UILabel *)certificateLabel {
    if (!_certificateLabel) {
        _certificateLabel = [[UILabel alloc] init];
        _certificateLabel.textColor = DEFAULT_TEXT_COLOR;
        _certificateLabel.textAlignment = NSTextAlignmentLeft;
        _certificateLabel.font = MKFont(13.f);
        _certificateLabel.numberOfLines = 0;
    }
    return _certificateLabel;
}

- (UIButton *)certificateButton {
    if (!_certificateButton) {
        _certificateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certificateButton setImage:LOADICON(@"MKCustomUIModule", @"MKMQTTSSLCertificateView", @"mk_customUI_config_certAddIcon.png") forState:UIControlStateNormal];
        [_certificateButton addTarget:self
                               action:@selector(certificateButtonPressed)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _certificateButton;
}

@end
