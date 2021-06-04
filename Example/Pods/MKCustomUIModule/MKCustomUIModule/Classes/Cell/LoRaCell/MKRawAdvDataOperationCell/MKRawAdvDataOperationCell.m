/*
 当前cell高度80.f
 */

#import "MKRawAdvDataOperationCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const offset_X = 15.f;
static CGFloat const offset_Y = 10.f;

static CGFloat const switchButtonWidth = 40.f;
static CGFloat const switchButtonHeight = 30.f;

@implementation MKRawAdvDataOperationCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.enabled = YES;
        self.switchEnable = YES;
    }
    return self;
}

@end

@interface MKRawAdvDataOperationCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UIButton *subButton;

@property (nonatomic, strong)UIButton *addButton;

@property (nonatomic, strong)UIImageView *selectedIcon;

@property (nonatomic, strong)UILabel *buttonMsgLabel;

@property (nonatomic, strong)UIControl *listButton;

@end

@implementation MKRawAdvDataOperationCell

+ (MKRawAdvDataOperationCell *)initCellWithTableView:(UITableView *)tableView {
    MKRawAdvDataOperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKRawAdvDataOperationCellIdenty"];
    if (!cell) {
        cell = [[MKRawAdvDataOperationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKRawAdvDataOperationCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.subButton];
        [self.contentView addSubview:self.addButton];
        [self.contentView addSubview:self.listButton];
        [self.listButton addSubview:self.selectedIcon];
        [self.listButton addSubview:self.buttonMsgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(switchButtonWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(switchButtonHeight);
    }];
    [self.subButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(switchButtonWidth);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(switchButtonHeight);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.subButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(switchButtonWidth);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(switchButtonHeight);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(self.addButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
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
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    [self updateSubViews];
    if ([self.delegate respondsToSelector:@selector(mk_rawAdvDataOperation_switchStatusChanged:)]) {
        [self.delegate mk_rawAdvDataOperation_switchStatusChanged:self.switchButton.isSelected];
    }
}

- (void)addButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_rawAdvDataOperation_addMethod)]) {
        [self.delegate mk_rawAdvDataOperation_addMethod];
    }
}

- (void)subButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_rawAdvDataOperation_subMethod)]) {
        [self.delegate mk_rawAdvDataOperation_subMethod];
    }
}

- (void)listButtonMethod {
    self.listButton.selected = !self.listButton.selected;
    UIImage *image = LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_listButtonUnselectedIcon.png");
    if (self.listButton.isSelected) {
        image = LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_listButtonSelectedIcon.png");
    }
    self.selectedIcon.image = image;
    if ([self.delegate respondsToSelector:@selector(mk_rawAdvDataOperation_whiteListButtonSelected:)]) {
        [self.delegate mk_rawAdvDataOperation_whiteListButtonSelected:self.listButton.isSelected];
    }
}

- (void)setDataModel:(MKRawAdvDataOperationCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKRawAdvDataOperationCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.switchButton.enabled = _dataModel.switchEnable;
    self.switchButton.selected = _dataModel.isOn;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    self.listButton.selected = _dataModel.selected;
    self.listButton.enabled = _dataModel.enabled;
    UIImage *image = LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_listButtonUnselectedIcon.png");
    if (self.listButton.isSelected) {
        image = LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_listButtonSelectedIcon.png");
    }
    self.selectedIcon.image = image;
    [self updateSubViews];
}

#pragma mark - private method
- (void)updateSubViews {
    //当开关关闭的时候，隐藏三个按钮
    self.subButton.hidden = !self.switchButton.selected;
    self.addButton.hidden = !self.switchButton.selected;
    self.listButton.hidden = !self.switchButton.selected;
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
        [_switchButton setImage:LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_addIcon.png") forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(addButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)subButton {
    if (!_subButton) {
        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subButton setImage:LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_subIcon.png") forState:UIControlStateNormal];
        [_subButton addTarget:self
                       action:@selector(subButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _subButton;
}

- (UIImageView *)selectedIcon {
    if (!_selectedIcon) {
        _selectedIcon = [[UIImageView alloc] init];
        _selectedIcon.image = LOADICON(@"MKCustomUIModule", @"MKRawAdvDataOperationCell", @"mk_customUI_listButtonUnselectedIcon.png");
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

- (UIControl *)listButton {
    if (!_listButton) {
        _listButton = [[UIControl alloc] init];
        [_listButton addTarget:self
                        action:@selector(listButtonMethod)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _listButton;
}

@end
