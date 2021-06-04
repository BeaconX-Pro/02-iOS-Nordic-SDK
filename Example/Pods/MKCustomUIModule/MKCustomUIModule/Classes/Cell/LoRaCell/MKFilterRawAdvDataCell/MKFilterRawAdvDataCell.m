//
/*
 参数校验规则:
 1、dataType 参考https://www.bluetooth.com/specifications/assigned-numbers/generic-access-profile/
 2、minTextField如果填写为0，maxTextField可以不填写任何数字,也可以填写为0.minTextField如果大于0，maxTextField必须不小于minTextField，并且2者都在1~29之间
 3、rawDataField
 如果minTextField为0，则rawDataField必须填写最大长度不超过58个字符的偶数个字符，该字符必须为16进制字符，
 如果minTextField填写的数字跟maxTextField填写的一样且不为0，则rawDataField填写的字符长度应该为(maxTextField - minTextField + 1) * 2，
 如果minTextField填写的数字小于maxTextField填写的数字，则rawDataField填写的字符长度应该为(maxTextField - minTextField + 1) * 2;
 */
//

/*
 当前cell高度为95.f
 */

#import "MKFilterRawAdvDataCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"

@implementation MKFilterRawAdvDataCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.rawDataMaxBytes = 29;
    }
    return self;
}

- (BOOL)validParamsSuccess {
    if (!ValidStr(self.dataType) || self.dataType.length != 2) {
        return NO;
    }
    NSArray *typeList = [self dataTypeList];
    if (![typeList containsObject:[self.dataType uppercaseString]]) {
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

- (NSArray *)dataTypeList {
    return @[@"01",@"02",@"03",@"04",@"05",
             @"06",@"07",@"08",@"09",@"0A",
             @"0D",@"0E",@"0F",@"10",@"11",
             @"12",@"14",@"15",@"16",@"17",
             @"18",@"19",@"1A",@"1B",@"1C",
             @"1D",@"1E",@"1F",@"20",@"21",
             @"22",@"23",@"24",@"25",@"26",
             @"27",@"28",@"29",@"2A",@"2B",
             @"2C",@"2D",@"3D",@"FF"];
}

@end

@interface MKFilterRawAdvDataCell ()

@property (nonatomic, strong)MKTextField *typeTextField;

@property (nonatomic, strong)MKTextField *minTextField;

@property (nonatomic, strong)MKTextField *maxTextField;

@property (nonatomic, strong)UILabel *characterLabel;

@property (nonatomic, strong)UILabel *unitLabel;

@property (nonatomic, strong)MKTextField *rawDataField;

@end

@implementation MKFilterRawAdvDataCell

+ (MKFilterRawAdvDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterRawAdvDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterRawAdvDataCellIdenty"];
    if (!cell) {
        cell = [[MKFilterRawAdvDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterRawAdvDataCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.typeTextField];
        [self.contentView addSubview:self.minTextField];
        [self.contentView addSubview:self.maxTextField];
        [self.contentView addSubview:self.characterLabel];
        [self.contentView addSubview:self.unitLabel];
        [self.contentView addSubview:self.rawDataField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.typeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(70.f);
        make.top.mas_equalTo(5.f);
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

#pragma mark -
- (void)textFieldValueChanged:(NSString *)text textType:(mk_filterRawAdvDataTextType)type {
    if ([self.delegate respondsToSelector:@selector(rawFilterDataChanged:index:textValue:)]) {
        [self.delegate rawFilterDataChanged:type index:self.dataModel.index textValue:text];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKFilterRawAdvDataCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKFilterRawAdvDataCellModel.class]) {
        return;
    }
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

#pragma mark -
- (MKTextField *)typeTextField {
    if (!_typeTextField) {
        _typeTextField = [self loadTextWithTextType:mk_hexCharOnly];
        _typeTextField.maxLength = 2;
        WS(weakSelf);
        _typeTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text textType:mk_filterRawAdvDataTextTypeDataType];
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
            [sself textFieldValueChanged:text textType:mk_filterRawAdvDataTextTypeMinIndex];
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
            [sself textFieldValueChanged:text textType:mk_filterRawAdvDataTextTypeMaxIndex];
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
            [sself textFieldValueChanged:text textType:mk_filterRawAdvDataTextTypeRawDataType];
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
