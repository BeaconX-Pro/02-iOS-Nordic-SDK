//
//  MKNormalSliderCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKNormalSliderCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

static CGFloat const offset_X = 15.f;
static CGFloat const offset_Y = 10.f;

@implementation MKNormalSliderCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.sliderEnable = YES;
        self.sliderMinValue = -127;
        self.sliderMaxValue = 0;
        self.unit = @"dBm";
    }
    return self;
}

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    if ([self.msg isKindOfClass:[NSString class]]) {
        self.msg = [MKCustomUIAdopter attributedString:@[self.msg]
                                                 fonts:@[MKFont(15.f)]
                                                colors:@[DEFAULT_TEXT_COLOR]];
    }
    if (![self.msg isKindOfClass:[NSAttributedString class]]) {
        return 0;
    }
    CGFloat msgHeight = [MKCustomUIAdopter strHeightForAttributeStr:self.msg viewWidth:width];
    CGFloat heightWithoutNote = msgHeight + 3 * offset_Y + 5.f;
    if (!self.changed && !ValidStr(self.noteMsg)) {
        return MAX(heightWithoutNote, 55);
    }
    //存在底部的note
    UIFont *noteFont = (self.noteMsgFont ? self.noteMsgFont : MKFont(12.f));
    NSString *tempNoteMsg = self.noteMsg;
    if (self.changed) {
        tempNoteMsg = [NSString stringWithFormat:@"%@ %@%@ %@",SafeStr(self.leftNoteMsg),[NSString stringWithFormat:@"%ld",(long)self.sliderMaxValue],SafeStr(self.unit),SafeStr(self.rightNoteMsg)];
    }
    CGSize noteSize = [NSString sizeWithText:tempNoteMsg
                                     andFont:noteFont
                                  andMaxSize:CGSizeMake(width - 2 * offset_X, MAXFLOAT)];
    return MAX(heightWithoutNote, 55) + noteSize.height + 15.f;
}

@end

@interface MKNormalSliderCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *sliderValueLabel;

@property (nonatomic, strong)MKSlider *sliderView;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKNormalSliderCell

+ (MKNormalSliderCell *)initCellWithTableView:(UITableView *)tableView {
    MKNormalSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNormalSliderCellIdenty"];
    if (!cell) {
        cell = [[MKNormalSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNormalSliderCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.sliderValueLabel];
        [self.contentView addSubview:self.sliderView];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo([self msgLabelHeight]);
    }];
    [self.sliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.sliderValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(offset_Y);
    }];
    [self.sliderValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.sliderView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    CGSize noteSize = [self noteMsgSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_Y);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)rssiSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.sliderView.value];
    if ([value isEqualToString:@"-0"]) {
        value = @"0";
    }
    self.sliderValueLabel.text = [value stringByAppendingString:self.dataModel.unit];
    
    if (self.dataModel.changed) {
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@ %@",SafeStr(_dataModel.leftNoteMsg),[value stringByAppendingString:self.dataModel.unit],SafeStr(_dataModel.rightNoteMsg)];
    }
    
    if ([self.delegate respondsToSelector:@selector(mk_normalSliderValueChanged:index:)]) {
        [self.delegate mk_normalSliderValueChanged:[value integerValue] index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKNormalSliderCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    if ([_dataModel.msg isKindOfClass:[NSString class]]) {
        self.msgLabel.attributedText = [MKCustomUIAdopter attributedString:@[_dataModel.msg]
                                                                     fonts:@[MKFont(15.f)]
                                                                    colors:@[DEFAULT_TEXT_COLOR]];
    }else if ([_dataModel.msg isKindOfClass:[NSAttributedString class]]) {
        self.msgLabel.attributedText = _dataModel.msg;
    }
    self.sliderView.enabled = _dataModel.sliderEnable;
    self.sliderView.maximumValue = _dataModel.sliderMaxValue;
    self.sliderView.minimumValue = _dataModel.sliderMinValue;
    self.sliderView.value = _dataModel.sliderValue;
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%ld%@",(long)_dataModel.sliderValue,_dataModel.unit];
    self.sliderValueLabel.textColor = (_dataModel.unitColor ? _dataModel.unitColor : DEFAULT_TEXT_COLOR);
    self.sliderValueLabel.font = (_dataModel.unitFont ? _dataModel.unitFont : MKFont(11.f));
    if (_dataModel.changed) {
        //left+value+unit+right
        self.noteLabel.text = [NSString stringWithFormat:@"%@ %@%@ %@",SafeStr(_dataModel.leftNoteMsg),[NSString stringWithFormat:@"%ld",(long)_dataModel.sliderValue],SafeStr(_dataModel.unit),SafeStr(_dataModel.rightNoteMsg)];
    }else {
        self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    }
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setNeedsLayout];
}

#pragma mark - private method
- (CGFloat)msgLabelHeight {
    return [MKCustomUIAdopter strHeightForAttributeStr:self.msgLabel.attributedText
                                             viewWidth:self.contentView.frame.size.width - 30.f];
}

- (CGSize)noteMsgSize {
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
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UILabel *)sliderValueLabel {
    if (!_sliderValueLabel) {
        _sliderValueLabel = [[UILabel alloc] init];
        _sliderValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _sliderValueLabel.textAlignment = NSTextAlignmentLeft;
        _sliderValueLabel.font = MKFont(11.f);
    }
    return _sliderValueLabel;
}

- (MKSlider *)sliderView {
    if (!_sliderView) {
        _sliderView = [[MKSlider alloc] init];
        _sliderView.maximumValue = 0;
        _sliderView.minimumValue = -127;
        [_sliderView addTarget:self
                        action:@selector(rssiSliderValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
