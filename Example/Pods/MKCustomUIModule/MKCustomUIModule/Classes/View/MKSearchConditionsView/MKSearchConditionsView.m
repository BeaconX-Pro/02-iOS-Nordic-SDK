//
//  MKSearchConditionsView.m
//  MKTrackerPlus_Example
//
//  Created by aa on 2020/12/25.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKSearchConditionsView.h"

#import "MKMacroDefines.h"
#import "MKSlider.h"

static CGFloat const offset_X = 10.f;
static CGFloat const backViewHeight = 200.f;
static CGFloat const statusBarHeight = 64.f;
static CGFloat const signalIconWidth = 17.f;
static CGFloat const signalIconHeight = 15.f;

@interface MKSearchConditionsView()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UITextField *textField;

@property (nonatomic, strong)UIImageView *signalIcon;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)MKSlider *slider;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UIButton *doneButton;

@property (nonatomic, copy)void (^searchBlock)(NSString *searchKey, NSInteger searchRssi);

@end

@implementation MKSearchConditionsView

- (void)dealloc{
    NSLog(@"MKSearchConditionsView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.1f)];
        [self addSubview:self.backView];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.signalIcon];
        [self.backView addSubview:self.rssiLabel];
        [self.backView addSubview:self.slider];
        [self.backView addSubview:self.rssiValueLabel];
        [self.backView addSubview:self.doneButton];
        [self addTapAction];
    }
    return self;
}

#pragma mark - 父类方法


#pragma mark - 代理方法

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self) {
        return NO;
    }
    return YES;
}

#pragma mark - Private method

- (void)rssiValueChanged{
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%.fdBm",self.slider.value]];
}

- (void)dismiss{
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)doneButtonPressed{
    [self.textField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
        if (self.searchBlock) {
            self.searchBlock(self.textField.text, [value integerValue]);
        }
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)addTapAction{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(dismiss)];
    [singleTap setNumberOfTouchesRequired:1];   //触摸点个数
    [singleTap setNumberOfTapsRequired:1];      //点击次数
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

#pragma mark - public method
+ (void)showSearchKey:(NSString *)searchKey
                 rssi:(NSInteger)rssi
              minRssi:(NSInteger)minRssi
          searchBlock:(void (^)(NSString *searchKey, NSInteger searchRssi))searchBlock {
    MKSearchConditionsView *view = [[MKSearchConditionsView alloc] init];
    [view showViewWithText:searchKey
                 rssiValue:rssi
             minSearchRssi:minRssi
               searchBlock:searchBlock];
}


#pragma mark - private method
/**
 加载页面
 
 @param text 输入框文本
 @param rssiValue 滑竿rssi值
 */
- (void)showViewWithText:(NSString *)searchKey
               rssiValue:(NSInteger)rssiValue
           minSearchRssi:(NSInteger)minSearchRssi
             searchBlock:(void (^)(NSString *searchKey, NSInteger searchRssi))searchBlock {
    [kAppWindow addSubview:self];
    self.searchBlock = searchBlock;
    if (ValidStr(searchKey)) {
        [self.textField setText:searchKey];
    }
    [self.slider setMinimumValue:minSearchRssi];
    [self.slider setValue:rssiValue];
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%lddBm",(long)rssiValue]];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, backViewHeight + statusBarHeight);
    } completion:^(BOOL finished) {
        [self.textField becomeFirstResponder];
    }];
}

#pragma mark - setter & getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(offset_X,
                                                             -backViewHeight,
                                                             kViewWidth - 2 * offset_X,
                                                             backViewHeight)];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _backView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(offset_X,
                                      offset_X,
                                      kViewWidth - 4 * offset_X,
                                      30.f);
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = MKFont(13.f);
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.placeholder = @"Device name or mac address";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.cornerRadius = 4.f;
    }
    return _textField;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.frame = CGRectMake(offset_X,
                                       backViewHeight - 45.f - offset_X,
                                       kViewWidth - 4 * offset_X,
                                       45.f);
        [_doneButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_doneButton setTitle:@"DONE" forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:MKFont(16.f)];
        [_doneButton.layer setMasksToBounds:YES];
        [_doneButton.layer setCornerRadius:4.f];
        [_doneButton addTarget:self
                        action:@selector(doneButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIImageView *)signalIcon{
    if (!_signalIcon) {
        _signalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(offset_X,
                                                                    offset_X * 3 + 30.f,
                                                                    signalIconWidth,
                                                                    signalIconHeight)];
        _signalIcon.image = LOADICON(@"MKCustomUIModule", @"MKSearchConditionsView", @"mk_customUI_wifisignalIcon.png");
    }
    return _signalIcon;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X + signalIconWidth + 5.f,
                                                               offset_X * 3 + 30.f,
                                                               35.f,
                                                               signalIconHeight)];
        _rssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiLabel.textAlignment = NSTextAlignmentLeft;
        _rssiLabel.font = MKFont(12.f);
        _rssiLabel.text = @"RSSI:";
    }
    return _rssiLabel;
}

- (MKSlider *)slider{
    if (!_slider) {
        CGFloat postion_X = offset_X + signalIconWidth + 10.f + 35.f;
        _slider = [[MKSlider alloc] init];
        _slider.frame = CGRectMake(postion_X,
                                   offset_X * 3 + 30.f,
                                   kViewWidth - postion_X - 3 * offset_X - 5.f - 55.f,
                                   signalIconHeight);
        [_slider setMaximumValue:0];
        [_slider setMinimumValue:-100];
        [_slider setValue:-100];
        [_slider addTarget:self action:@selector(rssiValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)rssiValueLabel{
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kViewWidth - 2 * offset_X - 55.f,
                                                                    offset_X * 3 + 30.f,
                                                                    55.f,
                                                                    signalIconHeight)];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(12.f);
        _rssiValueLabel.text = @"-100dBm";
    }
    return _rssiValueLabel;
}

@end
