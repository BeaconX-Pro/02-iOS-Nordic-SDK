//
//  MKBXScanBeaconCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXScanBeaconCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;

#define msgFont MKFont(12.f)

@implementation MKBXScanBeaconCellModel
@end

@interface MKBXScanBeaconCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,UID
 */
@property (nonatomic, strong)UILabel *typeLabel;

/**
 RSSI@1m
 */
@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)UILabel *rssiValueLabel;

/**
 发射功率
 */
@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UILabel *distanceLabel;

@property (nonatomic, strong)UILabel *distanceValueLabel;

/**
 uuid
 */
@property (nonatomic, strong)UILabel *uuidLabel;

/**
 uuid值
 */
@property (nonatomic, strong)UILabel *uuidIDLabel;

/**
 主值
 */
@property (nonatomic, strong)UILabel *majorLabel;

@property (nonatomic, strong)UILabel *majorIDLabel;

/**
 次值
 */
@property (nonatomic, strong)UILabel *minorLabel;

@property (nonatomic, strong)UILabel *minorIDLabel;

@end

@implementation MKBXScanBeaconCell

+ (MKBXScanBeaconCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXScanBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXScanBeaconCellIdenty"];
    if (!cell) {
        cell = [[MKBXScanBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXScanBeaconCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.rssiValueLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.txPowerValueLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.distanceValueLabel];
        [self.contentView addSubview:self.uuidLabel];
        [self.contentView addSubview:self.uuidIDLabel];
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.majorIDLabel];
        [self.contentView addSubview:self.minorLabel];
        [self.contentView addSubview:self.minorIDLabel];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.uuidLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    CGSize uuidIDSize = [NSString sizeWithText:self.uuidIDLabel.text
                                       andFont:self.uuidIDLabel.font
                                    andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * offset_X - 140.f, MAXFLOAT)];
    [self.uuidIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(self.uuidLabel.mas_top);
        make.height.mas_equalTo(uuidIDSize.height);
    }];
    [self.majorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.uuidIDLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.majorIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.majorLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.minorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.majorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.minorIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.minorLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.minorLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.rssiValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.rssiLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.distanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.distanceLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.distanceLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.txPowerValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiLabel.mas_right).mas_offset(25.f);
        make.right.mas_equalTo(-offset_X);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXScanBeaconCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXScanBeaconCellModel.class]) {
        return;
    }
    self.uuidIDLabel.text = SafeStr(_dataModel.uuid);
    self.majorIDLabel.text = SafeStr(_dataModel.major);
    self.minorIDLabel.text = SafeStr(_dataModel.minor);
    self.rssiValueLabel.text = [NSString stringWithFormat:@"%@%@",SafeStr(_dataModel.rssi1M),@"dBm"];
    self.txPowerValueLabel.text = [NSString stringWithFormat:@"%@%@",SafeStr(_dataModel.txPower),@"dBm"];
    NSString *distanceValue = [self calcDistByRSSI:[_dataModel.rssi intValue] measurePower:labs([_dataModel.rssi1M integerValue])];
    if ([distanceValue floatValue] <= 0.1) {
        self.distanceValueLabel.text = @"Immediate";
    }else if ([distanceValue floatValue] > 0.1 && [distanceValue floatValue] <= 1.f) {
        self.distanceValueLabel.text = @"Near";
    }else if ([distanceValue floatValue] > 1.f) {
        self.distanceValueLabel.text = @"Far";
    }
    [self setNeedsLayout];
}

#pragma mark - public method

+ (CGFloat)getCellHeightWithUUID:(NSString *)uuid{
    if (!ValidStr(uuid)) {
        return 125.f;
    }
    CGSize uuidIDSize = [NSString sizeWithText:uuid
                                       andFont:MKFont(16.f)
                                    andMaxSize:CGSizeMake(kViewWidth - 2 * offset_X - 140.f, MAXFLOAT)];
    return 120 + uuidIDSize.height;
}

#pragma mark - private method

- (NSString *)calcDistByRSSI:(int)rssi measurePower:(NSInteger)measurePower{
    int iRssi = abs(rssi);
    float power = (iRssi - measurePower) / (10 * 2.0);
    return [NSString stringWithFormat:@"%.2fm",pow(10, power)];
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanBeaconCell", @"mk_bx_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"iBeacon";
    }
    return _typeLabel;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:msgFont];
        _rssiLabel.text = @"RSSI@1m";
    }
    return _rssiLabel;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [self  createLabelWithFont:msgFont];
    }
    return _rssiValueLabel;
}

- (UILabel *)txPowerLabel{
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:msgFont];
        _txPowerLabel.text = @"Tx power";
    }
    return _txPowerLabel;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [self createLabelWithFont:msgFont];
    }
    return _txPowerValueLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [self createLabelWithFont:msgFont];
        _distanceLabel.text = @"Proximity state";
    }
    return _distanceLabel;
}

- (UILabel *)distanceValueLabel {
    if (!_distanceValueLabel) {
        _distanceValueLabel = [self createLabelWithFont:msgFont];
    }
    return _distanceValueLabel;
}

- (UILabel *)uuidLabel{
    if (!_uuidLabel) {
        _uuidLabel = [self createLabelWithFont:msgFont];
        _uuidLabel.text = @"UUID";
    }
    return _uuidLabel;
}

- (UILabel *)uuidIDLabel{
    if (!_uuidIDLabel) {
        _uuidIDLabel = [self createLabelWithFont:msgFont];
        _uuidIDLabel.numberOfLines = 0;
    }
    return _uuidIDLabel;
}

- (UILabel *)majorLabel{
    if (!_majorLabel) {
        _majorLabel = [self createLabelWithFont:msgFont];
        _majorLabel.text = @"Major";
    }
    return _majorLabel;
}

- (UILabel *)majorIDLabel{
    if (!_majorIDLabel) {
        _majorIDLabel = [self createLabelWithFont:msgFont];
    }
    return _majorIDLabel;
}

- (UILabel *)minorLabel{
    if (!_minorLabel) {
        _minorLabel = [self createLabelWithFont:msgFont];
        _minorLabel.text = @"Minor";
    }
    return _minorLabel;
}

- (UILabel *)minorIDLabel{
    if (!_minorIDLabel) {
        _minorIDLabel = [self createLabelWithFont:msgFont];
    }
    return _minorIDLabel;
}

#pragma mark - Private method

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
