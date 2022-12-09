//
//  MKAlertView.m
//  MKNBPlugApp
//
//  Created by aa on 2022/6/15.
//

#import "MKAlertView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"
#import "UITextField+MKAdd.h"

static CGFloat const centerViewOffsetX = 50.f;
static CGFloat const msgLabelOffsetX = 10.f;
static CGFloat const titleLabelOffsetY = 25.f;
static CGFloat const buttonHeight = 45.f;
static CGFloat const textFieldHeight = 30.f;

@interface MKAlertViewAction ()

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)void (^handler)(void);

@end

@implementation MKAlertViewAction

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(void))handler {
    if (self = [self init]) {
        self.title = title;
        self.handler = handler;
    }
    return self;
}

@end

@interface MKAlertViewTextField ()

/// 当前textField的值
@property (nonatomic, copy)NSString *textValue;

/// textField的占位符
@property (nonatomic, copy)NSString *placeholder;

/// 当前textField的输入类型
@property (nonatomic, assign)mk_textFieldType textFieldType;

/// textField的最大输入长度,对于textFieldType == mk_uuidMode无效
@property (nonatomic, assign)NSInteger maxLength;

@property (nonatomic, copy)void (^handler)(NSString *text);

@end

@implementation MKAlertViewTextField

- (instancetype)initWithTextValue:(NSString *)textValue
                      placeholder:(NSString *)placeholder
                    textFieldType:(mk_textFieldType)textFieldType
                        maxLength:(NSInteger)maxLength
                          handler:(void (^)(NSString * _Nonnull))handler {
    if (self = [self init]) {
        self.textValue = textValue;
        self.placeholder = placeholder;
        self.textFieldType = textFieldType;
        self.maxLength = maxLength;
        self.handler = handler;
    }
    return self;
}

@end

@interface MKAlertView ()

@property (nonatomic, strong)UIView *centerView;

@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)UILabel *messageLabel;

@property (nonatomic, strong)UIView *textFieldView;

@property (nonatomic, strong)UIView *horizontalLine;

@property (nonatomic, strong)NSMutableArray *actionList;

@property (nonatomic, strong)NSMutableArray *buttonList;

@property (nonatomic, strong)NSMutableArray *textModelList;

@property (nonatomic, strong)NSMutableArray *textFieldList;

@property (nonatomic, strong)NSMutableArray *asciiStringList;

@end

@implementation MKAlertView

- (void)dealloc {
    NSLog(@"MKAlertView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.centerView];
    }
    return self;
}

#pragma mark - event method
- (void)buttonPressed0 {
    if (self.actionList.count == 0) {
        return;
    }
    MKAlertViewAction *action = self.actionList[0];
    if (action.handler) {
        action.handler();
    }
    [self dismiss];
}

- (void)buttonPressed1 {
    if (self.actionList.count < 2) {
        return;
    }
    MKAlertViewAction *action = self.actionList[1];
    if (action.handler) {
        action.handler();
    }
    [self dismiss];
}

- (void)textFieldValueChanged0 {
    if (self.textFieldList.count == 0) {
        return;
    }
    MKTextField *textField = self.textFieldList[0];
    MKAlertViewTextField *textModel = self.textModelList[0];
    
    NSString *inputValue = textField.text;
    if (!ValidStr(inputValue)) {
        textField.text = @"";
        NSString *tempString = self.asciiStringList[0];
        tempString = @"";
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
        return;
    }
    NSInteger strLen = inputValue.length;
    NSInteger dataLen = [inputValue dataUsingEncoding:NSUTF8StringEncoding].length;
    
    NSString *currentStr = self.asciiStringList[0];
    if (dataLen == strLen) {
        //当前输入是ascii字符
        currentStr = inputValue;
    }
    if (textModel.maxLength > 0 && currentStr.length > textModel.maxLength) {
        textField.text = [currentStr substringToIndex:textModel.maxLength];
        currentStr = [currentStr substringToIndex:textModel.maxLength];
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
    }else {
        textField.text = currentStr;
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
    }
}

- (void)textFieldValueChanged1 {
    if (self.textFieldList.count < 2) {
        return;
    }
    MKTextField *textField = self.textFieldList[1];
    MKAlertViewTextField *textModel = self.textModelList[1];
    
    NSString *inputValue = textField.text;
    if (!ValidStr(inputValue)) {
        textField.text = @"";
        NSString *tempString = self.asciiStringList[1];
        tempString = @"";
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
        return;
    }
    NSInteger strLen = inputValue.length;
    NSInteger dataLen = [inputValue dataUsingEncoding:NSUTF8StringEncoding].length;
    
    NSString *currentStr = self.asciiStringList[1];
    if (dataLen == strLen) {
        //当前输入是ascii字符
        currentStr = inputValue;
    }
    if (textModel.maxLength > 0 && currentStr.length > textModel.maxLength) {
        textField.text = [currentStr substringToIndex:textModel.maxLength];
        currentStr = [currentStr substringToIndex:textModel.maxLength];
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
    }else {
        textField.text = currentStr;
        if (textModel.handler) {
            textModel.handler(textField.text);
        }
    }
}

- (void)dismiss {
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - public method
- (void)addAction:(MKAlertViewAction *)action {
    if (!action || ![action isKindOfClass:MKAlertViewAction.class] || self.actionList.count >= 2) {
        return;
    }
    [self.actionList addObject:action];
}

- (void)addTextField:(MKAlertViewTextField *)textModel {
    if (!textModel || ![textModel isKindOfClass:MKAlertViewTextField.class] || self.textModelList.count >= 2) {
        return;
    }
    [self.textModelList addObject:textModel];
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
          notificationName:(NSString *)notificationName {
    if (self.actionList.count == 0 || self.actionList.count > 2) {
        return;
    }
    [kAppWindow addSubview:self];
    if (ValidStr(notificationName)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:notificationName
                                                   object:nil];
    }
    [self.centerView mk_removeAllSubviews];
    [self.textFieldView mk_removeAllSubviews];
    self.titleLabel.text = SafeStr(title);
    [self.centerView addSubview:self.titleLabel];
    self.messageLabel.text = SafeStr(message);
    [self.centerView addSubview:self.messageLabel];
    [self.centerView addSubview:self.textFieldView];
    [self.centerView addSubview:self.horizontalLine];
    
    [self.buttonList removeAllObjects];
    [self.textFieldList removeAllObjects];
    [self.asciiStringList removeAllObjects];
    
    for (NSInteger i = 0; i < self.actionList.count; i ++) {
        MKAlertViewAction *action = self.actionList[i];
        NSString *selectorName = [@"buttonPressed" stringByAppendingString:[NSString stringWithFormat:@"%@",@(i)]];
        UIButton *actionButton = [self loadButtonWithTitle:action.title selector:NSSelectorFromString(selectorName)];
        [self.centerView addSubview:actionButton];
        [self.buttonList addObject:actionButton];
    }
    
    for (NSInteger i = 0; i < self.textModelList.count; i ++) {
        MKAlertViewTextField *textModel = self.textModelList[0];
        MKTextField *textField = [self loadTextFieldWithTextValue:textModel.textValue
                                                      placeHolder:textModel.placeholder
                                                         textType:textModel.textFieldType];
        textField.prohibitedMethodsList = @[@"cut",@"copy",@"select",@"selectAll",@"paste"];
        textField.maxLength = textModel.maxLength;
        NSString *selectorName = [@"textFieldValueChanged" stringByAppendingString:[NSString stringWithFormat:@"%@",@(i)]];
        [textField addTarget:self
                      action:NSSelectorFromString(selectorName)
            forControlEvents:UIControlEventEditingChanged];
        [self.textFieldView addSubview:textField];
        [self.textFieldList addObject:textField];
        [self.asciiStringList addObject:textModel.textValue];
    }
    [self setupSubViews];
    if (self.textFieldList.count > 0) {
        MKTextField *textField = self.textFieldList[0];
        [textField becomeFirstResponder];
    }
}

#pragma mark - private method
- (UIButton *)loadButtonWithTitle:(NSString *)title selector:(SEL)selector{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:COLOR_BLUE_MARCROS forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [button addTarget:self
               action:selector
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (MKTextField *)loadTextFieldWithTextValue:(NSString *)textValue
                                placeHolder:(NSString *)placeHolder
                                   textType:(mk_textFieldType)textType{
    MKTextField *textField = [[MKTextField alloc] initWithTextFieldType:textType];
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.font = MKFont(13.f);
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = placeHolder;
    textField.text = textValue;
    
    return textField;
}

- (void)setupSubViews {
    CGFloat messageHeight = [self messageLabelHeight];
    CGFloat titleHeight = [self titleHeight];
    CGFloat textViewHeight = [self textFieldViewHeight];
    
    CGFloat centerViewHeight = (titleLabelOffsetY + messageHeight + titleHeight + textViewHeight + CUTTING_LINE_HEIGHT + buttonHeight + 20.f);
    if (self.textFieldList.count > 0) {
        //有输入框
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(centerViewOffsetX);
            make.right.mas_equalTo(-centerViewOffsetX);
            make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-90.f);
            make.height.mas_equalTo(centerViewHeight);
        }];
    }else {
        //无输入框
        [self.centerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(centerViewOffsetX);
            make.right.mas_equalTo(-centerViewOffsetX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(centerViewHeight);
        }];
    }
    if (ValidStr(self.titleLabel.text)) {
        //有标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5.f);
            make.right.mas_equalTo(-5.f);
            make.top.mas_equalTo(titleLabelOffsetY);
            make.height.mas_equalTo(MKFont(18.f).lineHeight);
        }];
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(msgLabelOffsetX);
            make.right.mas_equalTo(-msgLabelOffsetX);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(messageHeight);
        }];
    }else {
        //无标题
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5.f);
            make.right.mas_equalTo(-5.f);
            make.top.mas_equalTo(titleLabelOffsetY);
            make.height.mas_equalTo(0);
        }];
        [self.messageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(msgLabelOffsetX);
            make.right.mas_equalTo(-msgLabelOffsetX);
            make.top.mas_equalTo(titleLabelOffsetY);
            make.height.mas_equalTo(messageHeight);
        }];
    }
    [self.textFieldView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.messageLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(textViewHeight);
    }];
    if (self.textFieldList.count == 1) {
        //有1个输入框
        MKTextField *textField = self.textFieldList[0];
        [textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.textFieldView.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        }];
    }else if (self.textFieldList.count == 2) {
        //有2个输入框
        MKTextField *textField1 = self.textFieldList[0];
        [textField1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(textFieldHeight);
        }];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBCOLOR(53, 53, 53);
        [self.textFieldView addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(textField1.mas_bottom);
            make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        }];
        MKTextField *textField2 = self.textFieldList[1];
        [textField2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.height.mas_equalTo(textFieldHeight);
        }];
        [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.textFieldView.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        }];
    }else {
        //无输入框
        [self.horizontalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.messageLabel.mas_bottom).mas_offset(20.f);
            make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        }];
    }
    
    
    if (self.buttonList.count == 1) {
        //一个按钮
        UIButton *button = self.buttonList[0];
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.horizontalLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        return;
    }
    if (self.buttonList.count == 2) {
        //两个按钮
        UIView *verticalLine = [[UIView alloc] init];
        verticalLine.backgroundColor = RGBCOLOR(53, 53, 53);
        [self.centerView addSubview:verticalLine];
        [verticalLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.centerView.mas_centerX);
            make.width.mas_equalTo(CUTTING_LINE_HEIGHT);
            make.top.mas_equalTo(self.horizontalLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        UIButton *button1 = self.buttonList[0];
        UIButton *button2 = self.buttonList[1];
        [button1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(verticalLine.mas_left);
            make.top.mas_equalTo(self.horizontalLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
        [button2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(verticalLine.mas_right);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.horizontalLine.mas_bottom);
            make.bottom.mas_equalTo(0);
        }];
    }
}

- (CGFloat)titleHeight {
    if (ValidStr(self.titleLabel.text)) {
        //有标题，返回标题高度(14号字)+10.f(到message的间隔)
        return (MKFont(18.f).lineHeight + 10.f);
    }
    return 0;
}

- (CGFloat)textFieldViewHeight {
    if (self.textFieldList.count == 0) {
        //没有输入框
        return 0;
    }
    return (self.textFieldList.count * textFieldHeight);
}

- (CGFloat)messageLabelHeight {
    CGSize msgSize = [NSString sizeWithText:self.messageLabel.text
                                    andFont:self.messageLabel.font
                                 andMaxSize:CGSizeMake(kViewWidth - 2 * (centerViewOffsetX + msgLabelOffsetX) , MAXFLOAT)];
    return msgSize.height;
}

#pragma mark - getter
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = RGBCOLOR(234, 234, 234);
        
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = 8.f;
    }
    return _centerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = DEFAULT_TEXT_COLOR;
        _messageLabel.font = MKFont(14.f);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [[UIView alloc] init];
        _textFieldView.backgroundColor = COLOR_WHITE_MACROS;
        
        _textFieldView.layer.masksToBounds = YES;
        _textFieldView.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _textFieldView.layer.borderColor = RGBCOLOR(53, 53, 53).CGColor;
        _textFieldView.layer.cornerRadius = 6.f;
    }
    return _textFieldView;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = RGBCOLOR(53, 53, 53);
    }
    return _horizontalLine;
}

- (NSMutableArray *)actionList {
    if (!_actionList) {
        _actionList = [NSMutableArray array];
    }
    return _actionList;
}

- (NSMutableArray *)buttonList {
    if (!_buttonList) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}

- (NSMutableArray *)textModelList {
    if (!_textModelList) {
        _textModelList = [NSMutableArray array];
    }
    return _textModelList;
}

- (NSMutableArray *)textFieldList {
    if (!_textFieldList) {
        _textFieldList = [NSMutableArray array];
    }
    return _textFieldList;
}

- (NSMutableArray *)asciiStringList {
    if (!_asciiStringList) {
        _asciiStringList = [NSMutableArray array];
    }
    return _asciiStringList;
}

@end
