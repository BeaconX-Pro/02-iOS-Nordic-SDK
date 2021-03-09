//
//  MKHexKeyboard.m
//  FitPolo
//
//  Created by aa on 2018/3/22.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKHexKeyboard.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

static CGFloat const keyboardHeight = 275.f;
static NSTimeInterval const animationDuration = .3f;
static CGFloat const buttonSpace = 3.f;
static CGFloat const buttonSpace_X = 20.f;

@interface MKHexKeyboard()

@property (nonatomic, strong)UIView *topView;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, copy)MKHexKeyboardKeyPressedBlock keyboardBlock;

@property (nonatomic, copy)MKHexKeyboardDeletePressedBlock deleteBlock;

@property (nonatomic, copy)MKHexKeyboardDonePressedBlock doneBlock;

@end

@implementation MKHexKeyboard

- (void)dealloc{
    NSLog(@"键盘销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = COLOR_CLEAR_MACROS;
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        [self.topView addTapAction:self selector:@selector(dismiss)];
    }
    return self;
}

#pragma mark - event method

- (void)dismiss
{
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

- (void)buttonPressed:(UIButton *)sender{
    if (self.keyboardBlock) {
        self.keyboardBlock(sender.titleLabel.text);
    }
}

- (void)deleteButtonPressed{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)doneButtonPressed{
    if (self.doneBlock) {
        self.doneBlock();
    }
    [self dismiss];
}

#pragma mark - Public method
- (void)showHexKeyboardBlock:(MKHexKeyboardKeyPressedBlock)keyBlock
                 deleteBlock:(MKHexKeyboardDeletePressedBlock)deleteBlock
                   doneBlock:(MKHexKeyboardDonePressedBlock)doneBlock{
    [kAppWindow addSubview:self];
    [self loadKeyButtons];
    self.keyboardBlock = keyBlock;
    self.doneBlock = doneBlock;
    self.deleteBlock = deleteBlock;
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

#pragma mark - Private method

- (UIButton *)hexButton:(NSString *)title titleColor:(UIColor *)color{
    UIButton *hexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hexBtn setBackgroundColor:COLOR_WHITE_MACROS];
    [hexBtn setTitle:title forState:UIControlStateNormal];
    [hexBtn setTitleColor:color forState:UIControlStateNormal];
    [hexBtn.titleLabel setFont:MKFont(18.f)];
    [hexBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return hexBtn;
}

- (void)loadKeyButtons{
    CGFloat buttonWidth = ([UIScreen mainScreen].bounds.size.width - 2 * buttonSpace_X - 2 * buttonSpace) / 3;
    CGFloat buttonHeight = (keyboardHeight - 7 * buttonSpace) / 6;
    
    UIButton *DBtn = [self hexButton:@"D" titleColor:UIColorFromRGB(0x0099ff)];
    DBtn.frame = CGRectMake(buttonSpace_X, buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:DBtn];
    
    UIButton *EBtn = [self hexButton:@"E" titleColor:UIColorFromRGB(0x0099ff)];
    EBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:EBtn];
    
    UIButton *FBtn = [self hexButton:@"F" titleColor:UIColorFromRGB(0x0099ff)];
    FBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:FBtn];
    
    UIButton *ABtn = [self hexButton:@"A" titleColor:UIColorFromRGB(0x0099ff)];
    ABtn.frame = CGRectMake(buttonSpace_X, buttonHeight + 2 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:ABtn];
    
    UIButton *BBtn = [self hexButton:@"B" titleColor:UIColorFromRGB(0x0099ff)];
    BBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, buttonHeight + 2 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:BBtn];
    
    UIButton *CBtn = [self hexButton:@"C" titleColor:UIColorFromRGB(0x0099ff)];
    CBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, buttonHeight + 2 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:CBtn];
    
    UIButton *sevBtn = [self hexButton:@"7" titleColor:UIColorFromRGB(0x333333)];
    sevBtn.frame = CGRectMake(buttonSpace_X, 2 * buttonHeight + 3 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:sevBtn];
    
    UIButton *eightBtn = [self hexButton:@"8" titleColor:UIColorFromRGB(0x333333)];
    eightBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, 2 * buttonHeight + 3 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:eightBtn];
    
    UIButton *nineBtn = [self hexButton:@"9" titleColor:UIColorFromRGB(0x333333)];
    nineBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, 2 * buttonHeight + 3 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:nineBtn];
    
    UIButton *fourBtn = [self hexButton:@"4" titleColor:UIColorFromRGB(0x333333)];
    fourBtn.frame = CGRectMake(buttonSpace_X, 3 * buttonHeight + 4 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:fourBtn];
    
    UIButton *fiveBtn = [self hexButton:@"5" titleColor:UIColorFromRGB(0x333333)];
    fiveBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, 3 * buttonHeight + 4 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:fiveBtn];
    
    UIButton *sixBtn = [self hexButton:@"6" titleColor:UIColorFromRGB(0x333333)];
    sixBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, 3 * buttonHeight + 4 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:sixBtn];
    
    UIButton *oneBtn = [self hexButton:@"1" titleColor:UIColorFromRGB(0x333333)];
    oneBtn.frame = CGRectMake(buttonSpace_X, 4 * buttonHeight + 5 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:oneBtn];
    
    UIButton *twoBtn = [self hexButton:@"2" titleColor:UIColorFromRGB(0x333333)];
    twoBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, 4 * buttonHeight + 5 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:twoBtn];
    
    UIButton *threeBtn = [self hexButton:@"3" titleColor:UIColorFromRGB(0x333333)];
    threeBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, 4 * buttonHeight + 5 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:threeBtn];
    
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(buttonSpace_X, 5 * buttonHeight + 6 * buttonSpace, buttonWidth, buttonHeight);
    [delBtn setBackgroundColor:UIColorFromRGB(0x999999)];
    
    [delBtn setImage:LOADICON(@"MKCustomUIModule", @"MKHexKeyboard", @"mk_customUI_keyboardDelIcon.png")
            forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:delBtn];
    
    UIButton *zeroBtn = [self hexButton:@"0" titleColor:UIColorFromRGB(0x333333)];
    zeroBtn.frame = CGRectMake(buttonSpace_X + buttonWidth + buttonSpace, 5 * buttonHeight + 6 * buttonSpace, buttonWidth, buttonHeight);
    [self.bottomView addSubview:zeroBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(buttonSpace_X + 2 * buttonWidth + 2 * buttonSpace, 5 * buttonHeight + 6 * buttonSpace, buttonWidth, buttonHeight);
    [doneBtn setBackgroundColor:UIColorFromRGB(0x999999)];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:MKFont(20.f)];
    [doneBtn addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:doneBtn];
}

#pragma mark - setter & getter
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               [UIScreen mainScreen].bounds.size.height,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               keyboardHeight)];
        _bottomView.backgroundColor = UIColorFromRGB(0xd9d9d9);
    }
    return _bottomView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            [UIScreen mainScreen].bounds.size.width,
                                                            [UIScreen mainScreen].bounds.size.height - keyboardHeight)];
        _topView.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _topView;
}

@end
