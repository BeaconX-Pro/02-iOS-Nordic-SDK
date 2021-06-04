//
//  MKLoRaSettingCHCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKLoRaSettingCHCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKPickerView.h"

static CGFloat const buttonWidth = 60.f;
static CGFloat const buttonHeight = 30.f;
static CGFloat const offset_X = 15.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const msgLabelWidth = 200.f;

@implementation MKLoRaSettingCHCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.chLowButtonEnable = YES;
        self.chHighButtonEnable = YES;
    }
    return self;
}

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    UIFont *msgFont = (self.msgFont ? self.msgFont : MKFont(15.f));
    CGFloat maxMsgWidth = msgLabelWidth;
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    if (!ValidStr(self.noteMsg)) {
        //没有底部note内容
        return MAX(msgSize.height + 2 * offset_Y, 50.f);
    }
    //存在底部的note
    UIFont *noteFont = (self.noteMsgFont ? self.noteMsgFont : MKFont(12.f));
    CGSize noteSize = [NSString sizeWithText:self.noteMsg
                                     andFont:noteFont
                                  andMaxSize:CGSizeMake(width - 2 * offset_X, MAXFLOAT)];
    return MAX(msgSize.height + 2 * offset_Y, 50.f) + noteSize.height + offset_Y;
}

@end

@interface MKLoRaSettingCHCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *chLowButton;

@property (nonatomic, strong)UIButton *chHighButton;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKLoRaSettingCHCell

+ (MKLoRaSettingCHCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaSettingCHCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoRaSettingCHCellIdenty"];
    if (!cell) {
        cell = [[MKLoRaSettingCHCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoRaSettingCHCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.chLowButton];
        [self.contentView addSubview:self.chHighButton];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat msgLabelHeight = [self msgLabelHeight];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(msgLabelWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(msgLabelHeight);
    }];
    [self.chLowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.chHighButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    [self.chHighButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(buttonWidth);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(buttonHeight);
    }];
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_Y);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)chLowButtonPressed {
    if (!ValidArray(self.dataModel.chLowValueList)) {
        return;
    }
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.chLowValueList.count; i ++) {
        if ([self.chLowButton.titleLabel.text isEqualToString:self.dataModel.chLowValueList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataModel.chLowValueList selectedRow:index block:^(NSInteger currentRow) {
        [self.chLowButton setTitle:self.dataModel.chLowValueList[currentRow] forState:UIControlStateNormal];
        self.dataModel.chLowIndex = currentRow;
        if ([self.delegate respondsToSelector:@selector(mk_loraSetting_chLowValueChanged:chLowIndex:cellIndex:)]) {
            [self.delegate mk_loraSetting_chLowValueChanged:self.dataModel.chLowValueList[currentRow]
                                                 chLowIndex:currentRow
                                                  cellIndex:self.dataModel.index];
        }
    }];
}

- (void)chHighButtonPressed {
    if (!ValidArray(self.dataModel.chHighValueList)) {
        return;
    }
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.chHighValueList.count; i ++) {
        if ([self.chHighButton.titleLabel.text isEqualToString:self.dataModel.chHighValueList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataModel.chHighValueList selectedRow:index block:^(NSInteger currentRow) {
        [self.chHighButton setTitle:self.dataModel.chHighValueList[currentRow] forState:UIControlStateNormal];
        self.dataModel.chHighIndex = currentRow;
        if ([self.delegate respondsToSelector:@selector(mk_loraSetting_chHighValueChanged:chHighIndex:cellIndex:)]) {
            [self.delegate mk_loraSetting_chHighValueChanged:self.dataModel.chHighValueList[currentRow]
                                                 chHighIndex:currentRow
                                                   cellIndex:self.dataModel.index];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKLoRaSettingCHCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKLoRaSettingCHCellModel.class] || !ValidArray(_dataModel.chHighValueList) || !ValidArray(_dataModel.chLowValueList) || _dataModel.chHighIndex >= _dataModel.chHighValueList.count || _dataModel.chLowIndex >= _dataModel.chLowValueList.count) {
        return;
    }
    self.chLowButton.enabled = _dataModel.chLowButtonEnable;
    self.chHighButton.enabled = _dataModel.chHighButtonEnable;
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.msgLabel.font = (_dataModel.msgFont ? _dataModel.msgFont : MKFont(15.f));
    self.msgLabel.textColor = (_dataModel.msgColor ? _dataModel.msgColor : DEFAULT_TEXT_COLOR);
    [self.chHighButton setTitle:_dataModel.chHighValueList[_dataModel.chHighIndex] forState:UIControlStateNormal];
    if (_dataModel.chHighLabelFont) {
        [self.chHighButton.titleLabel setFont:_dataModel.chHighLabelFont];
    }else {
        [self.chHighButton.titleLabel setFont:MKFont(15.f)];
    }
    if (_dataModel.chHighBackColor) {
        [self.chHighButton setBackgroundColor:_dataModel.chHighBackColor];
    }else {
        [self.chHighButton setBackgroundColor:NAVBAR_COLOR_MACROS];
    }
    if (_dataModel.chHighTitleColor) {
        [self.chHighButton setTitleColor:_dataModel.chHighTitleColor forState:UIControlStateNormal];
    }else {
        [self.chHighButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    }
    
    [self.chLowButton setTitle:_dataModel.chLowValueList[_dataModel.chLowIndex] forState:UIControlStateNormal];
    if (_dataModel.chLowLabelFont) {
        [self.chLowButton.titleLabel setFont:_dataModel.chLowLabelFont];
    }else {
        [self.chLowButton.titleLabel setFont:MKFont(15.f)];
    }
    if (_dataModel.chLowBackColor) {
        [self.chLowButton setBackgroundColor:_dataModel.chLowBackColor];
    }else {
        [self.chLowButton setBackgroundColor:NAVBAR_COLOR_MACROS];
    }
    if (_dataModel.chLowTitleColor) {
        [self.chLowButton setTitleColor:_dataModel.chLowTitleColor forState:UIControlStateNormal];
    }else {
        [self.chLowButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
    }
    
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setNeedsLayout];
}

#pragma mark - private method
- (CGFloat)msgLabelHeight {
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(msgLabelWidth , MAXFLOAT)];
    return MAX(msgSize.height, buttonHeight);
}

- (CGSize)noteSize {
    if (!ValidStr(self.noteLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat width = self.contentView.frame.size.width - 2 * offset_X;
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, noteSize.height);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIButton *)chLowButton {
    if (!_chLowButton) {
        _chLowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chLowButton.backgroundColor = NAVBAR_COLOR_MACROS;
        [_chLowButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_chLowButton.layer setMasksToBounds:YES];
        [_chLowButton.layer setCornerRadius:6.f];
        [_chLowButton addTarget:self
                         action:@selector(chLowButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _chLowButton;
}

- (UIButton *)chHighButton {
    if (!_chHighButton) {
        _chHighButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _chHighButton.backgroundColor = NAVBAR_COLOR_MACROS;
        [_chHighButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_chHighButton.layer setMasksToBounds:YES];
        [_chHighButton.layer setCornerRadius:6.f];
        [_chHighButton addTarget:self
                          action:@selector(chHighButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _chHighButton;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = RGBCOLOR(102, 102, 102);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
