//
//  MKBXPStorageTriggerTimeView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPStorageTriggerTimeView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPickerView.h"

@interface MKBXPStorageTriggerTimeView ()

@property (nonatomic, strong)UIButton *valueButton;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKBXPStorageTriggerTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.valueButton];
        [self addSubview:self.unitLabel];
        [self addSubview:self.noteLabel];
        [self loadDataList];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.valueButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_centerX).mas_offset(-3.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).mas_offset(2.f);
        make.width.mas_offset(40.f);
        make.centerY.mas_equalTo(self.valueButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    CGSize size = [NSString sizeWithText:self.noteLabel.text
                                 andFont:self.noteLabel.font
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 5.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.bottom.mas_equalTo(-5.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - event method
- (void)valueButtonPressed {
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataList selectedRow:[self getCurrentIndex] block:^(NSInteger currentRow) {
        [self.valueButton setTitle:self.dataList[currentRow] forState:UIControlStateNormal];
        [self processSelectMethod:currentRow];
    }];
}

#pragma mark - public method
- (void)updateTime:(NSString *)time {
    if (!ValidStr(time)) {
        return;
    }
    [self.valueButton setTitle:time forState:UIControlStateNormal];
    [self processSelectMethod:[self getCurrentIndex]];
}

- (NSString *)getCurrentTime {
    return self.valueButton.titleLabel.text;
}

#pragma mark - private method
- (void)processSelectMethod:(NSInteger)index {
    self.noteLabel.text = [NSString stringWithFormat:@"*The device stores T&H data every %@ minutes.",self.dataList[index]];
    [self setNeedsLayout];
}

- (NSInteger)getCurrentIndex {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        if ([self.valueButton.titleLabel.text isEqualToString:self.dataList[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

- (void)loadDataList {
    for (NSInteger i = 1; i <= 255; i ++) {
        NSString *value = [NSString stringWithFormat:@"%ld",i];
        [self.dataList addObject:value];
    }
}

#pragma mark - getter
- (UIButton *)valueButton {
    if (!_valueButton) {
        _valueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_valueButton setTitle:@"1" forState:UIControlStateNormal];
        [_valueButton.titleLabel setFont:MKFont(12.f)];
        [_valueButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_valueButton addTarget:self
                         action:@selector(valueButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
        
        _valueButton.layer.masksToBounds = YES;
        _valueButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _valueButton.layer.borderWidth = 0.5f;
        _valueButton.layer.cornerRadius = 6.f;
    }
    return _valueButton;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.font = MKFont(13.f);
        _unitLabel.text = @"min(s)";
    }
    return _unitLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"*The device stores all sampled T&H data.";
    }
    return _noteLabel;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
