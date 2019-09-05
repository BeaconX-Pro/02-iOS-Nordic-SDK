//
//  MKConnectDeviceProgressView.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/22.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKConnectDeviceProgressView.h"

static CGFloat const alertViewHeight = 340.f;

@interface MKConnectDeviceProgressView()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)CircleProgressBar *progressView;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKConnectDeviceProgressView

- (void)dealloc{
    NSLog(@"MKConnectDeviceProgressView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBCOLOR(102, 102, 102)];
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.titleLabel];
        [self.alertView addSubview:self.progressView];
        [self.alertView addSubview:self.msgLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).mas_offset(37.f);
        make.width.mas_equalTo(self.frame.size.width - 2 * 37.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(alertViewHeight);
    }];
    CGFloat width = self.frame.size.width - 2 * 37.f;
    CGSize titleSize = [NSString sizeWithText:self.titleLabel.text
                                      andFont:self.titleLabel.font
                                   andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(20.f);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(33.f);
        make.bottom.mas_equalTo(self.msgLabel.mas_top).mas_offset(-33.f);
        make.width.mas_equalTo(self.progressView.mas_height);
    }];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-15.f);
        make.height.mas_equalTo(msgSize.height);
    }];
}

#pragma mark - public method
- (void)showConnectAlertViewWithTitle:(NSString *)title{
    [self dismiss];
    [kAppWindow addSubview:self];
    if (ValidStr(title)) {
        self.titleLabel.text = title;
    }
    [UIView animateWithDuration:.3f animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(-kScreenWidth, 0);
    }];
}

- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)setProgress:(CGFloat)progress{
    [self.progressView setProgress:progress animated:NO];
}

#pragma mark - setter & getter
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        [_alertView setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = MKFont(18.f);
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"Connecting";
    }
    return _titleLabel;
}

- (CircleProgressBar *)progressView{
    if (!_progressView) {
        _progressView = [[CircleProgressBar alloc] init];
        _progressView.backgroundColor = COLOR_CLEAR_MACROS;
        _progressView.progressBarWidth = 7.f;
        _progressView.progressBarProgressColor = UIColorFromRGB(0x0188cc);
        _progressView.progressBarTrackColor = UIColorFromRGB(0xcccccc);
        _progressView.hintViewBackgroundColor = COLOR_CLEAR_MACROS;
        _progressView.hintTextFont = MKFont(18.f);
        _progressView.hintTextColor = DEFAULT_TEXT_COLOR;
        _progressView.startAngle = 270;
    }
    return _progressView;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.numberOfLines = 0.f;
        _msgLabel.text = @"Make sure your phone and device are as close as possible.";
    }
    return _msgLabel;
}

@end
