//
//  MKBXScanUIDCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXScanUIDCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const msgLabelWidth = 60.f;
static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;

#define msgFont MKFont(12.f)

@implementation MKBXScanUIDCellModel
@end

@interface MKBXScanUIDCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,UID
 */
@property (nonatomic, strong)UILabel *typeLabel;

/**
 RSSI@0m
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 发射功率
 */
@property (nonatomic, strong)UILabel *txPowerLabel;

/**
 NamespaceID
 */
@property (nonatomic, strong)UILabel *nameSpaceLabel;

/**
 NamespaceID值
 */
@property (nonatomic, strong)UILabel *nameSpaceIDLabel;

/**
 instanceID
 */
@property (nonatomic, strong)UILabel *instanceLabel;

/**
 instanceID值
 */
@property (nonatomic, strong)UILabel *instanceIDLabel;

@end

@implementation MKBXScanUIDCell

+ (MKBXScanUIDCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXScanUIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXScanUIDCellIdenty"];
    if (!cell) {
        cell = [[MKBXScanUIDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXScanUIDCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.nameSpaceLabel];
        [self.contentView addSubview:self.nameSpaceIDLabel];
        [self.contentView addSubview:self.instanceLabel];
        [self.contentView addSubview:self.instanceIDLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.rssiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.rssiLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.nameSpaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.nameSpaceIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.nameSpaceLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.instanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.nameSpaceLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.instanceIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.instanceLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXScanUIDCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        return;
    }
    self.txPowerLabel.text = [NSString stringWithFormat:@"%@dBm",_dataModel.txPower];
    self.nameSpaceIDLabel.text = [@"0x" stringByAppendingString:[SafeStr(_dataModel.namespaceId) uppercaseString]];
    self.instanceIDLabel.text = [@"0x" stringByAppendingString:[SafeStr(_dataModel.instanceId) uppercaseString]];
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanUIDCell", @"mk_bx_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"UID";
    }
    return _typeLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:msgFont];
        _rssiLabel.text = @"RSSI@0m";
    }
    return _rssiLabel;
}

- (UILabel *)txPowerLabel{
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:msgFont];
        _txPowerLabel.text = @"0dBm";
    }
    return _txPowerLabel;
}

- (UILabel *)nameSpaceLabel{
    if (!_nameSpaceLabel) {
        _nameSpaceLabel = [self createLabelWithFont:msgFont];
        _nameSpaceLabel.text = @"Namespace ID";
    }
    return _nameSpaceLabel;
}

- (UILabel *)nameSpaceIDLabel{
    if (!_nameSpaceIDLabel) {
        _nameSpaceIDLabel = [self createLabelWithFont:msgFont];
    }
    return _nameSpaceIDLabel;
}

- (UILabel *)instanceLabel{
    if (!_instanceLabel) {
        _instanceLabel = [self createLabelWithFont:msgFont];
        _instanceLabel.text = @"Instance ID";
    }
    return _instanceLabel;
}

- (UILabel *)instanceIDLabel{
    if (!_instanceIDLabel) {
        _instanceIDLabel = [self createLabelWithFont:msgFont];
    }
    return _instanceIDLabel;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
