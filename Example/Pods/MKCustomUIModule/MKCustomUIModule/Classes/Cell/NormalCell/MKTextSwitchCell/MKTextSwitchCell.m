//
//  MKTextSwitchCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTextSwitchCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const offset_X = 15.f;
static CGFloat const switchButtonWidth = 40.f;
static CGFloat const switchButtonHeight = 30.f;

@implementation MKTextSwitchCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.switchEnable = YES;
    }
    return self;
}

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    UIFont *msgFont = (self.msgFont ? self.msgFont : MKFont(15.f));
    CGFloat maxMsgWidth = width - 3 * offset_X - switchButtonWidth;
    if (self.leftIcon) {
        maxMsgWidth = maxMsgWidth - self.leftIcon.size.width - 3.f;
    }
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    if (!ValidStr(self.noteMsg)) {
        //没有底部note内容
        return MAX(msgSize.height + 2 * offset_X, 50.f);
    }
    //存在底部的note
    UIFont *noteFont = (self.noteMsgFont ? self.noteMsgFont : MKFont(12.f));
    CGSize noteSize = [NSString sizeWithText:self.noteMsg
                                     andFont:noteFont
                                  andMaxSize:CGSizeMake(width - 2 * offset_X, MAXFLOAT)];
    return MAX(msgSize.height + 2 * offset_X, 50.f) + noteSize.height + 10.f;
}

@end

@interface MKTextSwitchCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKTextSwitchCell

+ (MKTextSwitchCell *)initCellWithTableView:(UITableView *)tableView {
    MKTextSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTextSwitchCellIdenty"];
    if (!cell) {
        cell = [[MKTextSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTextSwitchCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    
    BOOL hasNote = ValidStr(self.noteLabel.text);
    
    CGSize msgSize = [self msgSize];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.leftIcon) {
            make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(3.f);
        }else{
            make.left.mas_equalTo(offset_X);
        }
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-offset_X);
        if (hasNote) {
            //有底部的note标签内容
            make.top.mas_equalTo(offset_X);
        }else {
            //如果没有，则上下居中
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }
        make.height.mas_equalTo(msgSize.height);
    }];
    if (self.leftIcon) {
        //左侧有图标
        UIImage *image = self.leftIcon.image;
        [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset_X);
            make.width.mas_equalTo(image.size.width);
            make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(switchButtonWidth);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(switchButtonHeight);
    }];
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_X);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed{
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKTextSwitchCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKTextSwitchCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(mk_textSwitchCellStatusChanged:index:)]) {
        [self.delegate mk_textSwitchCellStatusChanged:self.switchButton.isSelected index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKTextSwitchCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKTextSwitchCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.msgLabel.font = (_dataModel.msgFont ? _dataModel.msgFont : MKFont(15.f));
    self.msgLabel.textColor = (_dataModel.msgColor ? _dataModel.msgColor : DEFAULT_TEXT_COLOR);
    self.switchButton.enabled = _dataModel.switchEnable;
    self.switchButton.selected = _dataModel.isOn;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKTextSwitchCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKTextSwitchCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    if (self.leftIcon && self.leftIcon.superview) {
        [self.leftIcon removeFromSuperview];
        self.leftIcon = nil;
    }
    if (_dataModel.leftIcon) {
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = _dataModel.leftIcon;
        [self.contentView addSubview:self.leftIcon];
    }
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setNeedsLayout];
}

#pragma mark - private method
- (CGSize)msgSize {
    if (!ValidStr(self.msgLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat maxMsgWidth = self.contentView.frame.size.width - 3 * offset_X - switchButtonWidth;
    if (self.leftIcon) {
        UIImage *image = self.leftIcon.image;
        maxMsgWidth = maxMsgWidth - image.size.width - 3.f;
    }
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    return CGSizeMake(maxMsgWidth, msgSize.height);
}

- (CGSize)noteSize {
    if (!ValidStr(self.noteLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat width = self.contentView.frame.size.width - 30.f;
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

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKCustomUIModule", @"MKTextSwitchCell", @"mk_customUI_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
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
