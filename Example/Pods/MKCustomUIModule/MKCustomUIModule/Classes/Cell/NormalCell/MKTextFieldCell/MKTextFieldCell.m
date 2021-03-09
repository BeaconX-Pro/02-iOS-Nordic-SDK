//
//  MKTextFieldCell.m
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import "MKTextFieldCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const offset_X = 15.f;
static CGFloat const textBorderViewHeight = 35.f;
static CGFloat const unitLabelWidth = 70.f;

@implementation MKTextFieldCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.textEnable = YES;
    }
    return self;
}

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    UIFont *msgFont = (self.msgFont ? self.msgFont : MKFont(15.f));
    CGFloat msgWith = (width - 3 * offset_X) / 2;
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(msgWith, MAXFLOAT)];
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

@interface MKTextFieldCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIView *textBorderView;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKTextFieldCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (MKTextFieldCell *)initCellWithTableView:(UITableView *)tableView {
    MKTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKTextFieldCellIdenty"];
    if (!cell) {
        cell = [[MKTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKTextFieldCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.noteLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(needHiddenKeyboard)
                                                     name:@"MKTextFieldNeedHiddenKeyboard"
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL hasNote = ValidStr(self.noteLabel.text);
    CGSize msgSize = [self msgSize];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(msgSize.width);
        if (hasNote) {
            //底部有note标签
            make.top.mas_equalTo(offset_X);
        }else {
            //底部没有note标签，上下居中
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }
        make.height.mas_equalTo(msgSize.height);
    }];
    if (self.textField && self.textField.superview) {
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5.f);
            make.right.mas_equalTo(-5.f);
            make.top.mas_equalTo(2.f);
            make.bottom.mas_equalTo(0.f);
        }];
    }
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.height.mas_equalTo(self.contentView.mas_height);
    }];
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_X);
        make.height.mas_equalTo(noteSize.height);
    }];
    if (self.textBorderView && self.textBorderView.superview) {
        [self.textBorderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(offset_X);
            if (ValidStr(self.dataModel.unit)) {
                make.right.mas_equalTo(self.unitLabel.mas_left).mas_offset(-5.f);
            }else {
                make.right.mas_equalTo(-offset_X);
            }
            make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
            make.height.mas_equalTo(textBorderViewHeight);
        }];
    }
}

#pragma mark - event method
- (void)textFieldValueChanged:(NSString *)textValue {
    if ([self.delegate respondsToSelector:@selector(mk_deviceTextCellValueChanged:textValue:)]) {
        [self.delegate mk_deviceTextCellValueChanged:self.dataModel.index textValue:SafeStr(textValue)];
    }
}

#pragma mark - note
- (void)needHiddenKeyboard {
    [self.textField resignFirstResponder];
}

#pragma mark - setter
- (void)setDataModel:(MKTextFieldCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.unitLabel.text = SafeStr(_dataModel.unit);
    self.unitLabel.font = (_dataModel.unitFont ? _dataModel.unitFont : MKFont(13.f));
    self.unitLabel.textColor = (_dataModel.unitColor ? _dataModel.unitColor : DEFAULT_TEXT_COLOR);
    self.unitLabel.hidden = !ValidStr(_dataModel.unit);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.msgLabel.font = (_dataModel.msgFont ? _dataModel.msgFont : MKFont(15.f));
    self.msgLabel.textColor = (_dataModel.msgColor ? _dataModel.msgColor : DEFAULT_TEXT_COLOR);
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setupSubViews];
}

#pragma mark - private method
- (void)setupSubViews {
    if (self.textField && self.textField.superview) {
        [self.textField removeFromSuperview];
        self.textField = nil;
    }
    if (self.textBorderView && self.textBorderView.superview) {
        [self.textBorderView removeFromSuperview];
        self.textBorderView = nil;
    }
    WS(weakSelf);
    self.textField = [self textFieldWithPlaceholder:self.dataModel.textPlaceholder
                                              value:self.dataModel.textFieldValue
                                          maxLength:self.dataModel.maxLength
                                               type:self.dataModel.textFieldType
                                      textAlignment:self.dataModel.textAlignment
                                               font:self.dataModel.textFieldTextFont
                                          textColor:self.dataModel.textFieldTextColor
                                           callBack:^(NSString *text) {
        __strong typeof(self) sself = weakSelf;
        [sself textFieldValueChanged:text];
    }];
    self.textField.clearButtonMode = self.dataModel.clearButtonMode;
    self.textField.enabled = self.dataModel.textEnable;
    self.textBorderView = [self loadBorderView];
    if (self.dataModel.cellType == mk_textFieldCell_normalType) {
        self.textBorderView.layer.cornerRadius = 6.f;
        if (self.dataModel.borderColor) {
            self.textBorderView.layer.borderColor = self.dataModel.borderColor.CGColor;
        }
    }else if (self.dataModel.cellType == mk_textFieldCell_topLineType) {
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = CUTTING_LINE_COLOR;
        [self.textBorderView addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(2.f);
        }];
    }
    [self.contentView addSubview:self.textBorderView];
    [self.textBorderView addSubview:self.textField];
    [self setNeedsLayout];
}

- (CGSize)msgSize {
    if (!ValidStr(self.msgLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat maxMsgWidth = (self.contentView.frame.size.width - 3 * offset_X) / 2;
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

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.font = MKFont(13.f);
    }
    return _unitLabel;
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

- (UIView *)loadBorderView {
    UIView *borderView = [[UIView alloc] init];
    borderView.backgroundColor = COLOR_WHITE_MACROS;
    borderView.layer.masksToBounds = YES;
    borderView.layer.borderWidth = CUTTING_LINE_HEIGHT;
    borderView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    return borderView;
}

- (MKTextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                    value:(NSString *)value
                                maxLength:(NSInteger)maxLength
                                     type:(mk_textFieldType)type
                            textAlignment:(NSTextAlignment)textAlignment
                                     font:(UIFont *)font
                                textColor:(UIColor *)textColor
                                 callBack:(void (^)(NSString *text))callBack{
    MKTextField *textField = [[MKTextField alloc] initWithTextFieldType:type textChangedBlock:callBack];
    textField.borderStyle = UITextBorderStyleNone;
    textField.maxLength = maxLength;
    textField.placeholder = placeholder;
    textField.text = value;
    textField.font = (font ? font : MKFont(13.f));
    textField.textColor = (textColor ? textColor : DEFAULT_TEXT_COLOR);
    textField.textAlignment = textAlignment;
    return textField;
}

@end
