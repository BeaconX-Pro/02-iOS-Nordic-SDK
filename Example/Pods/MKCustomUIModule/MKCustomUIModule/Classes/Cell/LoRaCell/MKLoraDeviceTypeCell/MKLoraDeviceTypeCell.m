//
//  MKLoraDeviceTypeCell.m
//  MKLoraWANLib_Example
//
//  Created by aa on 2020/12/14.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKLoraDeviceTypeCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const functionButtonWidth = 105.f;
static CGFloat const functionButtonHeight = 45.f;

@implementation MKLoraDeviceTypeCellModel
@end

@interface MKDeviceTypeCellButton : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKDeviceTypeCellButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.5f);
        make.width.mas_equalTo(13);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(40);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-0.5f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeUnselectedIcon.png");
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(11.f);
    }
    return _msgLabel;
}

@end

@interface MKLoraDeviceTypeCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKDeviceTypeCellButton *classButton1;

@property (nonatomic, strong)MKDeviceTypeCellButton *classButton2;

@property (nonatomic, assign)mk_loraDeviceType currentType;

@end

@implementation MKLoraDeviceTypeCell

+ (MKLoraDeviceTypeCell *)initCellWithTableView:(UITableView *)tableView {
    MKLoraDeviceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKLoraDeviceTypeCellIdenty"];
    if (!cell) {
        cell = [[MKLoraDeviceTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKLoraDeviceTypeCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.classButton1];
        [self.contentView addSubview:self.classButton2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.classButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(functionButtonWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(functionButtonHeight);
    }];
    [self.classButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.classButton2.mas_left).mas_offset(10.f);
        make.width.mas_equalTo(functionButtonWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(functionButtonHeight);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.classButton1.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)classButton1Pressed {
    if (self.currentType == mk_loraDeviceType_first) {
        return;
    }
    self.currentType = mk_loraDeviceType_first;
    self.classButton1.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeSelectedIcon.png");
    self.classButton2.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeUnselectedIcon.png");
    if ([self.delegate respondsToSelector:@selector(mk_loraDeviceTypeSelected:deviceType:)]) {
        [self.delegate mk_loraDeviceTypeSelected:self.dataModel.index deviceType:mk_loraDeviceType_first];
    }
}

- (void)classButton2Pressed {
    if (self.currentType == mk_loraDeviceType_second) {
        return;
    }
    self.currentType = mk_loraDeviceType_second;
    self.classButton1.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeUnselectedIcon.png");
    self.classButton2.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeSelectedIcon.png");
    if ([self.delegate respondsToSelector:@selector(mk_loraDeviceTypeSelected:deviceType:)]) {
        [self.delegate mk_loraDeviceTypeSelected:self.dataModel.index deviceType:mk_loraDeviceType_second];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKLoraDeviceTypeCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKLoraDeviceTypeCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.classButton1.msgLabel.text = SafeStr(_dataModel.buttonTitle1);
    self.classButton2.msgLabel.text = SafeStr(_dataModel.buttonTitle2);
    self.currentType = _dataModel.type;
    if (_dataModel.type == mk_loraDeviceType_first) {
        self.classButton1.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeSelectedIcon.png");
        self.classButton2.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeUnselectedIcon.png");
        return;
    }
    if (_dataModel.type == mk_loraDeviceType_second) {
        self.classButton1.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeUnselectedIcon.png");
        self.classButton2.icon.image = LOADICON(@"MKCustomUIModule", @"MKLoraDeviceTypeCell", @"mk_customUI_deviceTypeSelectedIcon.png");
        return;
    }
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(14.f);
    }
    return _msgLabel;
}

- (MKDeviceTypeCellButton *)classButton1 {
    if (!_classButton1) {
        _classButton1 = [[MKDeviceTypeCellButton alloc] init];
        [_classButton1 addTarget:self
                          action:@selector(classButton1Pressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _classButton1;
}

- (MKDeviceTypeCellButton *)classButton2 {
    if (!_classButton2) {
        _classButton2 = [[MKDeviceTypeCellButton alloc] init];
        [_classButton2 addTarget:self
                          action:@selector(classButton2Pressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _classButton2;
}

@end
