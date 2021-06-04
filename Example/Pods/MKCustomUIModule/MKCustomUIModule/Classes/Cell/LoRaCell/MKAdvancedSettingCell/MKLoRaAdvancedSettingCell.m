/*
 cell高度设为80.f即可
 */

#import "MKLoRaAdvancedSettingCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKLoRaAdvancedSettingCellModel

- (instancetype)init {
    if (self = [super init]) {
        self.switchEnable = YES;
    }
    return self;
}

@end

@interface MKLoRaAdvancedSettingCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)UIButton *switchButton;

@end

@implementation MKLoRaAdvancedSettingCell

+ (MKLoRaAdvancedSettingCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoRaAdvancedSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoRaAdvancedSettingCellIdenty"];
    if (!cell) {
        cell = [[MKLoRaAdvancedSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoRaAdvancedSettingCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.noteLabel];
        [self.contentView addSubview:self.switchButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(18.f).lineHeight);
    }];
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f - 55.f, MAXFLOAT)];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method

- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKLoRaAdvancedSettingCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKLoRaAdvancedSettingCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(mk_loraSetting_advanceCell_switchStatusChanged:)]) {
        [self.delegate mk_loraSetting_advanceCell_switchStatusChanged:self.switchButton.isSelected];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLoRaAdvancedSettingCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKLoRaAdvancedSettingCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    [self.switchButton setEnabled:_dataModel.switchEnable];
    [self.switchButton setSelected:_dataModel.isOn];
    UIImage *buttonImage = (self.switchButton.isSelected ? LOADICON(@"MKCustomUIModule", @"MKLoRaAdvancedSettingCell", @"mk_customUI_switchSelectedIcon.png") : LOADICON(@"MKCustomUIModule", @"MKLoRaAdvancedSettingCell", @"mk_customUI_switchUnselectedIcon.png"));
    [self.switchButton setImage:buttonImage forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = NAVBAR_COLOR_MACROS;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(18.f);
        _msgLabel.text = @"Advanced Setting(Optional)";
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKCustomUIModule", @"MKLoRaAdvancedSettingCell", @"mk_customUI_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(13.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"Note:Please do not modify advanced settings unless necessary.";
    }
    return _noteLabel;
}

@end
