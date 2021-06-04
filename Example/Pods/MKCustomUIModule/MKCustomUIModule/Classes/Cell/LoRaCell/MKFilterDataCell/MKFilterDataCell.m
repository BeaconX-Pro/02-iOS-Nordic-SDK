
/*
 开关打开状态下，cell高度145.f，关闭则60.f
 */

#import "MKFilterDataCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKFilterDataCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.switchEnable = YES;
        self.enabled = YES;
    }
    return self;
}

@end

@interface MKFilterNormalTextView : UIView

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UIView *topLineView;

- (instancetype)initWithTextField:(MKTextField *)textField;

@end

@implementation MKFilterNormalTextView

- (instancetype)initWithTextField:(MKTextField *)textField {
    if (self = [super init]) {
        self.textField = textField;
        [self addSubview:self.textField];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topLineView];
        self.backgroundColor = COLOR_WHITE_MACROS;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = CUTTING_LINE_HEIGHT;
        self.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.topLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(2.f);
    }];
    if (self.textField && self.textField.superview) {
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.topLineView.mas_bottom);
            make.bottom.mas_equalTo(0.f);
        }];
    }
}

#pragma mark -
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _topLineView;
}

@end

@interface MKFilterDoubleTextView : UIView

@property (nonatomic, strong)MKFilterNormalTextView *leftTextField;

@property (nonatomic, strong)MKFilterNormalTextView *rightTextField;

@property (nonatomic, strong)UILabel *fromLabel;

@property (nonatomic, strong)UILabel *toLabel;

@property (nonatomic, copy)void (^leftCallback)(NSString *leftText);

@property (nonatomic, copy)void (^rightCallback)(NSString *rightText);

- (instancetype)initWithLeftCallback:(void (^)(NSString *leftText))leftCallback
                       rightCallback:(void (^)(NSString *rightText))rightCallback;

@end

@implementation MKFilterDoubleTextView

- (instancetype)initWithLeftCallback:(void (^)(NSString *leftText))leftCallback
                       rightCallback:(void (^)(NSString *rightText))rightCallback {
    if (self = [self init]) {
        self.leftCallback = leftCallback;
        self.rightCallback = rightCallback;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftTextField];
        [self addSubview:self.rightTextField];
        [self addSubview:self.fromLabel];
        [self addSubview:self.toLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.fromLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.leftTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fromLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(90.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
    }];
    [self.toLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftTextField.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.rightTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.toLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(90.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
    }];
}

#pragma mark - event method
- (void)leftTextFieldValueChanged:(NSString *)text {
    if (self.leftCallback) {
        self.leftCallback(text);
    }
}

- (void)rightTextFieldValueChanged:(NSString *)text {
    if (self.rightCallback) {
        self.rightCallback(text);
    }
}

#pragma mark - getter
- (MKFilterNormalTextView *)leftTextField {
    if (!_leftTextField) {
        WS(weakSelf);
        MKTextField *textField = [self loadTextField];
        textField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself leftTextFieldValueChanged:text];
        };
        _leftTextField = [[MKFilterNormalTextView alloc] initWithTextField:textField];
    }
    return _leftTextField;
}

- (MKFilterNormalTextView *)rightTextField {
    if (!_rightTextField) {
        WS(weakSelf);
        MKTextField *textField = [self loadTextField];
        textField.textChangedBlock = ^(NSString * _Nonnull text) {
            __strong typeof(self) sself = weakSelf;
            [sself rightTextFieldValueChanged:text];
        };
        _rightTextField = [[MKFilterNormalTextView alloc] initWithTextField:textField];
    }
    return _rightTextField;
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = DEFAULT_TEXT_COLOR;
        _fromLabel.font = MKFont(13.f);
        _fromLabel.textAlignment = NSTextAlignmentLeft;
        _fromLabel.text = @"From";
    }
    return _fromLabel;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.textColor = DEFAULT_TEXT_COLOR;
        _toLabel.font = MKFont(13.f);
        _toLabel.textAlignment = NSTextAlignmentLeft;
        _toLabel.text = @"To";
    }
    return _toLabel;
}

- (MKTextField *)loadTextField {
    MKTextField *textField = [[MKTextField alloc] initWithTextFieldType:mk_realNumberOnly];
    textField.borderStyle = UITextBorderStyleNone;
    textField.maxLength = 5;
    textField.placeholder = @"0~65535";
    textField.font = MKFont(13.f);
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    return textField;
}

@end

@interface MKFilterDataCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UIImageView *selectedIcon;

@property (nonatomic, strong)UILabel *buttonMsgLabel;

@property (nonatomic, strong)UIControl *listButton;

@property (nonatomic, strong)MKFilterNormalTextView *normalView;

@property (nonatomic, strong)MKFilterDoubleTextView *doubleTextView;

@end

@implementation MKFilterDataCell

+ (MKFilterDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKFilterDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKFilterDataCellIdenty"];
    if (!cell) {
        cell = [[MKFilterDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKFilterDataCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.listButton];
        [self.listButton addSubview:self.selectedIcon];
        [self.listButton addSubview:self.buttonMsgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(self.switchButton.mas_height);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
        make.width.mas_equalTo(45.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.width.mas_equalTo(120.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.listButton.mas_centerY);
        make.height.mas_equalTo(15.f);
    }];
    [self.buttonMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectedIcon.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(self.listButton.mas_centerY);
        make.height.mas_equalTo(self.listButton.mas_height);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    if (self.normalView) {
        self.normalView.hidden = !self.switchButton.isSelected;
    }
    if (self.doubleTextView) {
        self.doubleTextView.hidden = !self.switchButton.isSelected;
    }
    self.listButton.hidden = !self.switchButton.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(mk_fliterSwitchStatusChanged:index:)]) {
        [self.delegate mk_fliterSwitchStatusChanged:self.switchButton.isSelected index:self.dataModel.index];
    }
}

- (void)listButtonMethod {
    self.listButton.selected = !self.listButton.selected;
    UIImage *image = LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_listButtonUnselectedIcon.png");
    if (self.listButton.isSelected) {
        image = LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_listButtonSelectedIcon.png");
    }
    self.selectedIcon.image = image;
    if ([self.delegate respondsToSelector:@selector(mk_listButtonStateChanged:index:)]) {
        [self.delegate mk_listButtonStateChanged:self.listButton.isSelected index:self.dataModel.index];
    }
}

- (void)leftTextFieldValueChanged:(NSString *)textValue {
    if (self.dataModel.cellType != mk_filterDataCellType_double || !self.doubleTextView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mk_leftFilterTextFieldValueChanged:index:)]) {
        [self.delegate mk_leftFilterTextFieldValueChanged:textValue index:self.dataModel.index];
    }
}

- (void)rightTextFieldValueChanged:(NSString *)textValue {
    if (self.dataModel.cellType != mk_filterDataCellType_double || !self.doubleTextView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mk_rightFilterTextFieldValueChanged:index:)]) {
        [self.delegate mk_rightFilterTextFieldValueChanged:textValue index:self.dataModel.index];
    }
}

- (void)textFieldValueChanged:(NSString *)textValue {
    if (self.dataModel.cellType != mk_filterDataCellType_normal || !self.normalView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mk_filterTextFieldValueChanged:index:)]) {
        [self.delegate mk_filterTextFieldValueChanged:textValue index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKFilterDataCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKFilterDataCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.switchButton.enabled = _dataModel.switchEnable;
    self.switchButton.selected = _dataModel.isOn;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    self.listButton.selected = _dataModel.selected;
    self.listButton.enabled = _dataModel.enabled;
    UIImage *image = LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_listButtonUnselectedIcon.png");
    if (self.listButton.isSelected) {
        image = LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_listButtonSelectedIcon.png");
    }
    self.selectedIcon.image = image;
    
    if (self.normalView && self.normalView.superview) {
        [self.normalView removeFromSuperview];
        self.normalView = nil;
    }
    if (self.doubleTextView && self.doubleTextView.superview) {
        [self.doubleTextView removeFromSuperview];
        self.doubleTextView = nil;
    }
    if (_dataModel.cellType == mk_filterDataCellType_double) {
        WS(weakSelf);
        self.doubleTextView = [[MKFilterDoubleTextView alloc] initWithLeftCallback:^(NSString *leftText) {
            __strong typeof(self) sself = weakSelf;
            [sself leftTextFieldValueChanged:leftText];
        } rightCallback:^(NSString *rightText) {
            __strong typeof(self) sself = weakSelf;
            [sself rightTextFieldValueChanged:rightText];
        }];
        self.doubleTextView.leftTextField.textField.text = _dataModel.leftTextFieldValue;
        self.doubleTextView.rightTextField.textField.text = _dataModel.rightTextFieldValue;
        [self.contentView addSubview:self.doubleTextView];
        [self.doubleTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.listButton.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(35.f);
        }];
    }else {
        //mk_filterDataCellType_normal
        WS(weakSelf);
        UITextField *textField = [self textFieldWithPlaceholder:_dataModel.textFieldPlaceholder
                                                          value:_dataModel.textFieldValue
                                                      maxLength:_dataModel.maxLength
                                                           type:_dataModel.textFieldType
                                                       callBack:^(NSString *text) {
            __strong typeof(self) sself = weakSelf;
            [sself textFieldValueChanged:text];
        }];
        self.normalView = [[MKFilterNormalTextView alloc] initWithTextField:textField];
        [self.contentView addSubview:self.normalView];
        [self.normalView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.listButton.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(35.f);
        }];
    }
    
    if (self.normalView) {
        self.normalView.hidden = !self.switchButton.isSelected;
    }
    if (self.doubleTextView) {
        self.doubleTextView.hidden = !self.switchButton.isSelected;
    }
    self.listButton.hidden = !self.switchButton.isSelected;
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
    }
    return _msgLabel;
}

- (UIImageView *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.image = LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_listButtonUnselectedIcon.png");
    }
    return _selectedIcon;
}

- (UILabel *)buttonMsgLabel {
    if (!_buttonMsgLabel) {
        _buttonMsgLabel = [[UILabel alloc] init];
        _buttonMsgLabel.textAlignment = NSTextAlignmentLeft;
        _buttonMsgLabel.font = MKFont(13.f);
        _buttonMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _buttonMsgLabel.text = @"Whitelist";
    }
    return _buttonMsgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKCustomUIModule", @"MKFilterDataCell", @"mk_customUI_switchUnselectedIcon") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIControl *)listButton {
    if (!_listButton) {
        _listButton = [[UIControl alloc] init];
        [_listButton addTarget:self
                        action:@selector(listButtonMethod)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _listButton;
}

- (MKTextField *)textFieldWithPlaceholder:(NSString *)placeholder
                                    value:(NSString *)value
                                maxLength:(NSInteger)maxLength
                                     type:(mk_textFieldType)type
                                 callBack:(void (^)(NSString *text))callBack{
    MKTextField *textField = [[MKTextField alloc] init];
    textField.textType = type;
    textField.textChangedBlock = callBack;
    textField.borderStyle = UITextBorderStyleNone;
    textField.maxLength = maxLength;
    textField.placeholder = placeholder;
    textField.text = value;
    textField.font = MKFont(13.f);
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    return textField;
}

@end
