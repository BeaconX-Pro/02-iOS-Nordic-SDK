//
//  MKFilterByRawDataCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKFilterByRawDataCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

@implementation MKFilterByRawDataCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.rawDataMaxBytes = 29;
    }
    return self;
}

- (BOOL)validParamsSuccess {
    if (!ValidStr(self.dataType) || self.dataType.length != 2 || ![self.dataType regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (!ValidStr(self.minIndex) && !ValidStr(self.maxIndex)) {
        //
        return [self validRawDatas];
    }
    if (!ValidStr(self.minIndex) || self.minIndex.length > 2 || ![self.minIndex regularExpressions:isRealNumbers] || [self.minIndex integerValue] < 0 || [self.minIndex integerValue] > self.rawDataMaxBytes) {
        return NO;
    }
    if ([self.minIndex integerValue] == 0) {
        //可以不填写maxIndex或者maxIndex只能写0
        if ((!ValidStr(self.maxIndex) || [self.maxIndex integerValue] == 0) && [self validRawDatas]) {
            return YES;
        }
        return NO;
    }
    if (!ValidStr(self.maxIndex) || self.maxIndex.length > 2 || ![self.maxIndex regularExpressions:isRealNumbers] || [self.maxIndex integerValue] < 0 || [self.maxIndex integerValue] > self.rawDataMaxBytes) {
        return NO;
    }
    if ([self.maxIndex integerValue] < [self.minIndex integerValue]) {
        return NO;
    }
    if (!ValidStr(self.rawData) || self.rawData.length > (self.rawDataMaxBytes * 2) || ![self.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    NSInteger totalLen = ([self.maxIndex integerValue] - [self.minIndex integerValue] + 1) * 2;
    if (self.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

- (BOOL)validRawDatas {
    if (!ValidStr(self.rawData) || self.rawData.length > (self.rawDataMaxBytes * 2) || ![self.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (self.rawData.length % 2 != 0) {
        return NO;
    }
    return YES;
}

@end

@interface MKFilterByRawDataCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *typeTextField;

@property (nonatomic, strong)MKTextField *minTextField;

@property (nonatomic, strong)MKTextField *maxTextField;

@property (nonatomic, strong)UILabel *characterLabel;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)MKTextField *rawDataField;

@end

@implementation MKFilterByRawDataCell

+ (MKFilterByRawDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterByRawDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterByRawDataCellIdenty"];
    if (!cell) {
        cell = [[MKFilterByRawDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterByRawDataCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.typeTextField];
        [self.contentView addSubview:self.minTextField];
        [self.contentView addSubview:self.maxTextField];
        [self.contentView addSubview:self.characterLabel];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.rawDataField];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldHiddenKeyboard)
                                                     name:@"MKTextFieldNeedHiddenKeyboard"
                                                   object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.typeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.minTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeTextField.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.typeTextField.mas_centerY);
        make.height.mas_equalTo(self.typeTextField.mas_height);
    }];
    [self.characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minTextField.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.typeTextField.mas_centerY);
        make.height.mas_equalTo(self.typeTextField.mas_height);
    }];
    [self.maxTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.characterLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.typeTextField.mas_centerY);
        make.height.mas_equalTo(self.typeTextField.mas_height);
    }];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.maxTextField.mas_right).mas_offset(3.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.typeTextField.mas_centerY);
        make.height.mas_equalTo(self.typeTextField.mas_height);
    }];
    [self.rawDataField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.typeTextField.mas_bottom).mas_offset(15.f);
        make.bottom.mas_equalTo(-5.f);
    }];
}

#pragma mark - note
- (void)textFieldHiddenKeyboard {
    [self.typeTextField resignFirstResponder];
    [self.minTextField resignFirstResponder];
    [self.maxTextField resignFirstResponder];
    [self.rawDataField resignFirstResponder];
}

#pragma mark - event method
- (void)textFieldValueChanged:(NSString *)text textType:(mk_filterByRawDataTextType)type {
    if ([self.delegate respondsToSelector:@selector(mk_rawFilterDataChanged:index:textValue:)]) {
        [self.delegate mk_rawFilterDataChanged:type index:self.dataModel.index textValue:text];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKFilterByRawDataCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKFilterByRawDataCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.typeTextField.text = SafeStr(_dataModel.dataType);
    self.typeTextField.placeholder = SafeStr(_dataModel.dataTypePlaceHolder);
    self.minTextField.text = SafeStr(_dataModel.minIndex);
    self.minTextField.placeholder = SafeStr(_dataModel.minTextFieldPlaceHolder);
    self.maxTextField.text = SafeStr(_dataModel.maxIndex);
    self.maxTextField.placeholder = SafeStr(_dataModel.maxTextFieldPlaceHolder);
    self.rawDataField.text = SafeStr(_dataModel.rawData);
    self.rawDataField.placeholder = SafeStr(_dataModel.rawTextFieldPlaceHolder);
    self.rawDataField.maxLength = _dataModel.rawDataMaxBytes * 2;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (MKTextField *)typeTextField {
    if (!_typeTextField) {
        _typeTextField = [self loadTextWithTextType:mk_hexCharOnly];
        _typeTextField.maxLength = 2;
        WS(weakSelf);
        _typeTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text textType:mk_filterByRawDataTextTypeDataType];
        };
    }
    return _typeTextField;
}

- (MKTextField *)minTextField {
    if (!_minTextField) {
        _minTextField = [self loadTextWithTextType:mk_realNumberOnly];
        _minTextField.maxLength = 2;
        
        WS(weakSelf);
        _minTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text textType:mk_filterByRawDataTextTypeMinIndex];
        };
    }
    return _minTextField;
}

- (MKTextField *)maxTextField {
    if (!_maxTextField) {
        _maxTextField = [self loadTextWithTextType:mk_realNumberOnly];
        _maxTextField.maxLength = 2;
        
        WS(weakSelf);
        _maxTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text textType:mk_filterByRawDataTextTypeMaxIndex];
        };
    }
    return _maxTextField;
}

- (UILabel *)characterLabel {
    if (!_characterLabel) {
        _characterLabel = [[UILabel alloc] init];
        _characterLabel.textAlignment = NSTextAlignmentCenter;
        _characterLabel.textColor = DEFAULT_TEXT_COLOR;
        _characterLabel.font = MKFont(20.f);
        _characterLabel.text = @"~";
    }
    return _characterLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.textAlignment = NSTextAlignmentLeft;
        _unitLabel.textColor = DEFAULT_TEXT_COLOR;
        _unitLabel.font = MKFont(13.f);
        _unitLabel.text = @"Byte";
    }
    return _unitLabel;
}

- (MKTextField *)rawDataField {
    if (!_rawDataField) {
        _rawDataField = [self loadTextWithTextType:mk_hexCharOnly];
        
        WS(weakSelf);
        _rawDataField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text textType:mk_filterByRawDataTextTypeRawDataType];
        };
    }
    return _rawDataField;
}

- (MKTextField *)loadTextWithTextType:(mk_textFieldType)fieldType {
    MKTextField *textField = [[MKTextField alloc] init];
    textField.textType = fieldType;
    textField.backgroundColor = COLOR_WHITE_MACROS;
    textField.font = MKFont(13.f);
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = RGBCOLOR(162, 162, 162).CGColor;
    textField.layer.cornerRadius = 6.f;
    return textField;
}

@end
