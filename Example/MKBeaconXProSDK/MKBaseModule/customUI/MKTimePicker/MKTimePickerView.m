//
//  MKTimePickerView.m
//  FitPolo
//
//  Created by aa on 17/5/9.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKTimePickerView.h"
#import <YYKit/YYKit.h>
#import "MKMacroDefines.h"
#import "MKCategoryModule.h"

static float const animationDuration = .3f;
static CGFloat const kDatePickerH = 270;

@implementation MKTimerPickerModel
@end

@interface MKTimePickerView ()

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) MKTimePickViewBlock dateBlock;

@end

@implementation MKTimePickerView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.datePicker];
        [self addTapAction:self selector:@selector(dismiss)];
    }
    return self;
}

#pragma mark - Private Method

/**
 取消选择
 */
- (void)cancelButtonPressed{
    [self dismiss];
}

/**
 确认选择
 */
- (void)confirmButtonPressed{
    NSDate* date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.timeModel.dateFormat;
    self.timeModel.time = [formatter stringFromDate:date];
    if (self.dateBlock) {
        self.dateBlock(self.timeModel);
    }
    [self dismiss];
}

- (void)dismiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - Public Method
- (void)showTimePickViewBlock:(MKTimePickViewBlock)Block{
    if (!self.timeModel) {
        return;
    }
    [kAppWindow addSubview:self];
    self.dateBlock = Block;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.timeModel.dateFormat;
    [self.datePicker setDate:[formatter dateFromString:self.timeModel.time]];
    [self.datePicker setDatePickerMode:self.timeModel.datePickerMode];
    if (ValidStr(self.timeModel.maxTime)) {
        //设置日期选择器的最大时间
        NSArray *timeArray = [self.timeModel.maxTime componentsSeparatedByString:@"-"];
        if (ValidArray(timeArray) && timeArray.count == 3) {
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            [comp setYear:[timeArray[0] integerValue]];
            [comp setMonth:[timeArray[1] integerValue]];
            [comp setDay:[timeArray[2] integerValue]];
            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            self.datePicker.maximumDate = [calendar dateFromComponents:comp];
        }
    }
    if (ValidStr(self.timeModel.minTime)) {
        //设置日期选择器的最小时间
        NSArray *timeArray = [self.timeModel.minTime componentsSeparatedByString:@"-"];
        if (ValidArray(timeArray) && timeArray.count == 3) {
            NSDateComponents *comp = [[NSDateComponents alloc]init];
            [comp setYear:[timeArray[0] integerValue]];
            [comp setMonth:[timeArray[1] integerValue]];
            [comp setDay:[timeArray[2] integerValue]];
            NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            self.datePicker.minimumDate = [calendar dateFromComponents:comp];
        }
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -kDatePickerH);
    }];
}

#pragma mark - setter & getter
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kDatePickerH)];
        _bottomView.backgroundColor = RGBCOLOR(244, 244, 244);
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        topView.backgroundColor = COLOR_WHITE_MACROS;
        [_bottomView addSubview:topView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 10, 60, 30);
        [cancelButton setBackgroundColor:COLOR_CLEAR_MACROS];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:MKFont(16)];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake(kScreenWidth - 10 - 60, 10, 60, 30);
        [confirmBtn setBackgroundColor:COLOR_CLEAR_MACROS];
        [confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [confirmBtn.titleLabel setFont:MKFont(16)];
        [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:confirmBtn];
    }
    return _bottomView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(10, kDatePickerH - 216, self.frame.size.width - 2 * 10, 216)];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        _datePicker.backgroundColor = COLOR_CLEAR_MACROS;
        _datePicker.maximumDate = [NSDate date];
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        [comp setMonth:01];
        [comp setDay:01];
        [comp setYear:1900];
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _datePicker.minimumDate = [calendar dateFromComponents:comp];
    }
    return _datePicker;
}

@end
