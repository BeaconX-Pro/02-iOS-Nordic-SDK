//
//  MKBXSlotConfigInfoCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSlotConfigInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"

@implementation MKBXSlotConfigInfoCellModel

- (instancetype)init {
    if (self = [super init]) {
        _nameMinLen = 1;
        _nameMaxLen = 20;
    }
    return self;
}

@end

@interface MKBXSlotConfigInfoCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *textField;

@end

@implementation MKBXSlotConfigInfoCell

+ (MKBXSlotConfigInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSlotConfigInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSlotConfigInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXSlotConfigInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSlotConfigInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(20.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - MKBXSlotConfigCellProtocol
- (NSDictionary *)mk_bx_slotConfigCell_params {
    if (!ValidStr(self.textField.text)) {
        return @{
            @"msg":@"Device name cannot be empty",
            @"result":@{},
        };
    }
    return @{
        @"msg":@"",
        @"result":@{
                @"dataType":mk_bx_slotConfig_advContentType,
                @"params":@{
                        @"frameType":mk_bx_slotConfig_infoData,
                        @"deviceName":self.textField.text,
                }
        }
    };
}

#pragma mark - setter
- (void)setDataModel:(MKBXSlotConfigInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSlotConfigInfoCellModel.class]) {
        return;
    }
    self.textField.text = SafeStr(_dataModel.deviceName);
    self.textField.placeholder = [NSString stringWithFormat:@"%ld ~ %ld characters.",(long)_dataModel.nameMinLen,(long)_dataModel.nameMaxLen];
    self.textField.maxLength = _dataModel.nameMaxLen;
}

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigInfoCell", @"mk_bx_slotAdvContent.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Adv content";
    }
    return _typeLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Device name";
    }
    return _msgLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.font = MKFont(15.f);
        _textField.textAlignment = NSTextAlignmentLeft;
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _textField.layer.cornerRadius = 3.f;
    }
    return _textField;
}

@end
