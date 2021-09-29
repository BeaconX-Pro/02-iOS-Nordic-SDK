//
//  MKBXScanFilterView.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXScanFilterView.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKSlider.h"
#import "MKTextField.h"

static CGFloat const offset_X = 10.f;
static CGFloat const backViewHeight = 400.f;
static CGFloat const signalIconWidth = 17.f;
static CGFloat const signalIconHeight = 15.f;

static NSString *const noteMsg1 = @"* RSSI filtering is the highest priority filtering condition. BLE Name and MAC Address filtering must first meet the RSSI filtering condition.";
static NSString *const noteMsg2 = @"* There is an “OR“ relationship between the BLE Name filtering and the MAC Address filtering.";

@interface MKBXScanFilterView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)MKTextField *nameTextField;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)MKTextField *macTextField;

@property (nonatomic, strong)UILabel *minRssiLabel;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UIImageView *signalIcon;

@property (nonatomic, strong)UIImageView *graySignalIcon;

@property (nonatomic, strong)UILabel *minLabel;

@property (nonatomic, strong)UILabel *maxLabel;

@property (nonatomic, strong)MKSlider *slider;

@property (nonatomic, strong)UILabel *noteLabel1;

@property (nonatomic, strong)UILabel *noteLabel2;

@property (nonatomic, strong)UIButton *doneButton;

@property (nonatomic, copy)void (^searchBlock)(NSString *searchName, NSString *searchMac, NSInteger searchRssi);

@end

@implementation MKBXScanFilterView

- (void)dealloc{
    NSLog(@"MKBXScanFilterView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        [self setBackgroundColor:RGBACOLOR(0, 0, 0, 0.1f)];
        [self addSubview:self.backView];
        
        [self.backView addSubview:self.nameLabel];
        [self.backView addSubview:self.nameTextField];
        [self.backView addSubview:self.macLabel];
        [self.backView addSubview:self.macTextField];
        [self.backView addSubview:self.minRssiLabel];
        [self.backView addSubview:self.rssiValueLabel];
        [self.backView addSubview:self.signalIcon];
        [self.backView addSubview:self.graySignalIcon];
        [self.backView addSubview:self.slider];
        [self.backView addSubview:self.minLabel];
        [self.backView addSubview:self.maxLabel];
        [self.backView addSubview:self.noteLabel1];
        [self.backView addSubview:self.noteLabel2];
        [self.backView addSubview:self.doneButton];
        
        [self addTapAction];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self) {
        return NO;
    }
    return YES;
}

#pragma mark - Private method

- (void)rssiValueChanged{
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%.fdBm",(-100 - self.slider.value)]];
}

- (void)dismiss{
    [self.nameTextField resignFirstResponder];
    [self.macTextField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)doneButtonPressed{
    [self.nameTextField resignFirstResponder];
    [self.macTextField resignFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, -backViewHeight);
    } completion:^(BOOL finished) {
        NSString *value = [NSString stringWithFormat:@"%.f",self.slider.value];
        if (self.searchBlock) {
            self.searchBlock(SafeStr(self.nameTextField.text), SafeStr(self.macTextField.text),(-100 - [value integerValue]));
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
+ (void)showSearchName:(NSString *)name
            macAddress:(NSString *)macAddress
                  rssi:(NSInteger)rssi
           searchBlock:(void (^)(NSString *searchName, NSString *searchMacAddress, NSInteger searchRssi))searchBlock {
    MKBXScanFilterView *view = [[MKBXScanFilterView alloc] init];
    [view showSearchName:name
              macAddress:macAddress
                    rssi:rssi
             searchBlock:searchBlock];
}


#pragma mark - private method

- (void)showSearchName:(NSString *)name
            macAddress:(NSString *)macAddress
                  rssi:(NSInteger)rssi
           searchBlock:(void (^)(NSString *searchName, NSString *searchMacAddress, NSInteger searchRssi))searchBlock {
    [kAppWindow addSubview:self];
    self.searchBlock = searchBlock;
    self.nameTextField.text = SafeStr(name);
    self.macTextField.text = SafeStr(macAddress);
    [self.slider setValue:(-100 - rssi)];
    [self.rssiValueLabel setText:[NSString stringWithFormat:@"%lddBm",(long)rssi]];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.transform = CGAffineTransformMakeTranslation(0, backViewHeight + defaultTopInset);
    } completion:^(BOOL finished) {
        [self.nameTextField becomeFirstResponder];
    }];
}

#pragma mark - getter
#define backViewWidth (kViewWidth - 2 * offset_X)
#define textFieldPostion_X (offset_X + 100.f + 5.f)
#define textFieldWidth (backViewWidth - textFieldPostion_X - offset_X)
#define nameLabelPostion_Y (10.f)
#define textSpaceY (30.f + 10.f)
#define singalIconPostion_Y (nameLabelPostion_Y + 2 * textSpaceY + 25.f + 30.f)

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(offset_X,
                                                             -backViewHeight,
                                                             backViewWidth,
                                                             backViewHeight)];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _backView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X,nameLabelPostion_Y , 100.f, 30.f)];
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = MKFont(14.f);
        _nameLabel.text = @"BLE Name";
    }
    return _nameLabel;
}

- (MKTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _nameTextField.frame  = CGRectMake(textFieldPostion_X,
                                           nameLabelPostion_Y,
                                           textFieldWidth,
                                           30.f);
        _nameTextField.maxLength = 20;
        _nameTextField.textColor = DEFAULT_TEXT_COLOR;
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.font = MKFont(13.f);
        _nameTextField.textColor = DEFAULT_TEXT_COLOR;
        _nameTextField.placeholder = @"1-20 characters";
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _nameTextField.layer.borderWidth = 0.5f;
        _nameTextField.layer.cornerRadius = 4.f;
    }
    return _nameTextField;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X, nameLabelPostion_Y + textSpaceY, 100.f, 30.f)];
        _macLabel.textColor = DEFAULT_TEXT_COLOR;
        _macLabel.textAlignment = NSTextAlignmentLeft;
        _macLabel.font = MKFont(14.f);
        _macLabel.text = @"MAC Addr";
    }
    return _macLabel;
}

- (MKTextField *)macTextField {
    if (!_macTextField) {
        _macTextField = [[MKTextField alloc] initWithTextFieldType:mk_hexCharOnly];
        _macTextField.frame  = CGRectMake(textFieldPostion_X,
                                          nameLabelPostion_Y + textSpaceY,
                                          textFieldWidth,
                                           30.f);
        _macTextField.maxLength = 12;
        _macTextField.textColor = DEFAULT_TEXT_COLOR;
        _macTextField.borderStyle = UITextBorderStyleNone;
        _macTextField.font = MKFont(13.f);
        _macTextField.textColor = DEFAULT_TEXT_COLOR;
        _macTextField.placeholder = @"1-6bytes HEX";
        _macTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _macTextField.layer.masksToBounds = YES;
        _macTextField.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _macTextField.layer.borderWidth = 0.5f;
        _macTextField.layer.cornerRadius = 4.f;
    }
    return _macTextField;
}

- (UILabel *)minRssiLabel {
    if (!_minRssiLabel) {
        _minRssiLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X, nameLabelPostion_Y + 2 * textSpaceY, 100.f, 25.f)];
        _minRssiLabel.textColor = DEFAULT_TEXT_COLOR;
        _minRssiLabel.textAlignment = NSTextAlignmentLeft;
        _minRssiLabel.font = MKFont(14.f);
        _minRssiLabel.text = @"Min. RSSI";
    }
    return _minRssiLabel;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(textFieldPostion_X,
                                                                    nameLabelPostion_Y + 2 * textSpaceY,
                                                                    textFieldWidth,
                                                                    25.f)];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(14.f);
        _rssiValueLabel.text = @"-100dBm";
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5f, textFieldWidth, 0.5f)];
        lineView.backgroundColor = DEFAULT_TEXT_COLOR;
        [_rssiValueLabel addSubview:lineView];
    }
    return _rssiValueLabel;
}

- (UIImageView *)signalIcon{
    if (!_signalIcon) {
        _signalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(offset_X,
                                                                    singalIconPostion_Y,
                                                                    signalIconWidth,
                                                                    signalIconHeight)];
        _signalIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanFilterView", @"mk_bx_wifiSignalIcon.png");
    }
    return _signalIcon;
}

- (MKSlider *)slider{
    if (!_slider) {
        CGFloat postion_X = (offset_X + signalIconWidth + 10.f);
        _slider = [[MKSlider alloc] init];
        _slider.frame = CGRectMake(postion_X,
                                   singalIconPostion_Y,
                                   backViewWidth - 2 * postion_X ,
                                   signalIconHeight);
        [_slider setMaximumValue:0];
        [_slider setMinimumValue:-100];
        [_slider setValue:-100];
        [_slider addTarget:self
                    action:@selector(rssiValueChanged)
          forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UIImageView *)graySignalIcon {
    if (!_graySignalIcon) {
        _graySignalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(backViewWidth - offset_X - signalIconWidth,
                                                                        singalIconPostion_Y,
                                                                    signalIconWidth,
                                                                    signalIconHeight)];
        _graySignalIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanFilterView", @"mk_bx_wifiGraySignalIcon.png");
    }
    return _graySignalIcon;
}

- (UILabel *)maxLabel {
    if (!_maxLabel) {
        _maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_X, singalIconPostion_Y + signalIconHeight + 2.f, 50.f, MKFont(11.f).lineHeight)];
        _maxLabel.textColor = RGBCOLOR(15, 131, 255);
        _maxLabel.textAlignment = NSTextAlignmentLeft;
        _maxLabel.font = MKFont(11);
        _maxLabel.text = @"0dBm";
    }
    return _maxLabel;
}

- (UILabel *)minLabel {
    if (!_minLabel) {
        _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(backViewWidth - offset_X - 50.f, singalIconPostion_Y + signalIconHeight + 2.f, 50.f, MKFont(11.f).lineHeight)];
        _minLabel.textColor = [UIColor grayColor];
        _minLabel.textAlignment = NSTextAlignmentLeft;
        _minLabel.font = MKFont(11);
        _minLabel.text = @"-100dBm";
    }
    return _minLabel;
}

- (UILabel *)noteLabel1 {
    if (!_noteLabel1) {
        _noteLabel1 = [[UILabel alloc] init];
        _noteLabel1.textColor = [UIColor orangeColor];
        _noteLabel1.font = MKFont(11.f);
        _noteLabel1.numberOfLines = 0;
        _noteLabel1.textAlignment = NSTextAlignmentLeft;
        _noteLabel1.text = noteMsg1;
        CGSize size = [NSString sizeWithText:noteMsg1
                                     andFont:MKFont(11.f)
                                  andMaxSize:CGSizeMake(backViewWidth - 2 * offset_X, MAXFLOAT)];
        _noteLabel1.frame = CGRectMake(offset_X, singalIconPostion_Y + signalIconHeight + offset_X + 20.f, backViewWidth - 2 * offset_X, size.height);
    }
    return _noteLabel1;
}

- (UILabel *)noteLabel2 {
    if (!_noteLabel2) {
        _noteLabel2 = [[UILabel alloc] init];
        _noteLabel2.textColor = [UIColor orangeColor];
        _noteLabel2.font = MKFont(11.f);
        _noteLabel2.numberOfLines = 0;
        _noteLabel2.textAlignment = NSTextAlignmentLeft;
        _noteLabel2.text = noteMsg2;
        CGSize size1 = [NSString sizeWithText:noteMsg1
                                     andFont:MKFont(11.f)
                                  andMaxSize:CGSizeMake(backViewWidth - 2 * offset_X, MAXFLOAT)];
        CGSize size2 = [NSString sizeWithText:noteMsg2
                                     andFont:MKFont(11.f)
                                  andMaxSize:CGSizeMake(backViewWidth - 2 * offset_X, MAXFLOAT)];
        _noteLabel2.frame = CGRectMake(offset_X, singalIconPostion_Y + signalIconHeight + offset_X + size1.height + 22.f, backViewWidth - 2 * offset_X, size2.height);
    }
    return _noteLabel2;
}

- (UIButton *)doneButton{
    if (!_doneButton) {
        _doneButton = [MKCustomUIAdopter customButtonWithTitle:@"Apply"
                                                    titleColor:COLOR_WHITE_MACROS
                                               backgroundColor:NAVBAR_COLOR_MACROS
                                                        target:self action:@selector(doneButtonPressed)];
        _doneButton.frame = CGRectMake(offset_X, backViewHeight - 40.f - 45.f, backViewWidth - 2 * offset_X, 45.f);
    }
    return _doneButton;
}

@end
