//
//  MKProgressView.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKProgressView.h"
#import "CircleProgressBar.h"
#import "Masonry.h"
#import "MKMacroDefines.h"
#import "MKCategoryModule.h"

static CGFloat const defaultProgressViewHeight = 270.f;
static CGFloat const topOffset = 20.f;
static CGFloat const progressViewSpaceHeight = 33.f;

@interface MKProgressView()

@property (nonatomic, strong)UIView *alertView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)CircleProgressBar *progressView;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKProgressView

- (void)dealloc{
    NSLog(@"MKProgressView销毁");
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    if (self = [self init]) {
        if (ValidStr(title)) {
            self.titleLabel.text = title;
        }
        if (ValidStr(message)) {
            self.msgLabel.text = message;
        }
        [self.progressView setProgress:0.0 animated:NO];
    }
    return self;
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
    CGFloat width = self.frame.size.width - 2 * 37.f;
    CGSize titleSize = [NSString sizeWithText:self.titleLabel.text
                                      andFont:self.titleLabel.font
                                   andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    CGSize messageSize = [NSString sizeWithText:self.msgLabel.text
                                        andFont:self.msgLabel.font
                                     andMaxSize:CGSizeMake(width - 2 * 15.f, MAXFLOAT)];
    CGFloat height = defaultProgressViewHeight;
    if (self.progressViewHeight > 50 && self.progressViewHeight < defaultProgressViewHeight) {
        height = self.progressViewHeight;
    }
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(topOffset);
        make.height.mas_equalTo(titleSize.height);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.alertView.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(progressViewSpaceHeight);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(self.progressView.mas_height);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.progressView.mas_bottom).mas_offset(progressViewSpaceHeight);
        make.height.mas_equalTo(messageSize.height);
    }];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_right).mas_offset(37.f);
        make.width.mas_equalTo(self.frame.size.width - 2 * 37.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(titleSize.height + messageSize.height + 2 * topOffset + 2 * progressViewSpaceHeight + height);
    }];
}

#pragma mark - public method
- (void)show{
    [self dismiss];
    [kAppWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.alertView.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
    }];
}

- (void)dismiss{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    if (progress > 1.0) {
        progress = progress * 0.01;
    }
    [self.progressView setProgress:progress animated:animated];
}

- (void)setBackColor:(UIColor *)backColor{
    if (!backColor || ![backColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _backColor = backColor;
    [self setBackgroundColor:backColor];
}

- (void)setAlertColor:(UIColor *)alertColor{
    if (!alertColor || ![alertColor isKindOfClass:[UIColor class]]) {
        return;
    }
    _alertColor = alertColor;
    [self.alertView setBackgroundColor:alertColor];
}

- (void)setCircleWidth:(CGFloat)circleWidth{
    _circleWidth = circleWidth;
    if (_circleWidth == 0 || _circleWidth > 20.f) {
        _circleWidth = 5.f;
    }
    self.progressView.progressBarWidth = _circleWidth;
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
        _titleLabel.text = @"MKProgressView";
    }
    return _titleLabel;
}

- (CircleProgressBar *)progressView{
    if (!_progressView) {
        _progressView = [[CircleProgressBar alloc] init];
        _progressView.backgroundColor = COLOR_CLEAR_MACROS;
        _progressView.progressBarWidth = 5.f;
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
        _msgLabel.text = @"bottomMessage";
    }
    return _msgLabel;
}

@end
