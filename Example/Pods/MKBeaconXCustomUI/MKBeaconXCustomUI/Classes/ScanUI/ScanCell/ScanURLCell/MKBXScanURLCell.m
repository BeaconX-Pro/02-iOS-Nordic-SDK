//
//  MKBXScanURLCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/10.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXScanURLCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"
#import "UIView+MKAdd.h"

static CGFloat const msgLabelWidth = 60.f;
static CGFloat const offset_X = 10.f;
static CGFloat const offset_Y = 10.f;
static CGFloat const leftIconWidth = 7.f;
static CGFloat const leftIconHeight = 7.f;

#define msgFont MKFont(12.f)

@implementation MKBXScanURLCellModel
@end

@interface MKBXScanURLCell ()

/**
 小蓝点
 */
@property (nonatomic, strong)UIImageView *leftIcon;

/**
 类型,URL
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
 Link
 */
@property (nonatomic, strong)UILabel *linkLabel;

/**
 Link值
 */
@property (nonatomic, strong)UILabel *linkIDLabel;

@property (nonatomic, strong)UIView *linkLine;

@end

@implementation MKBXScanURLCell

+ (MKBXScanURLCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXScanURLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXScanURLCellIdenty"];
    if (!cell) {
        cell = [[MKBXScanURLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXScanURLCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.txPowerLabel];
        [self.contentView addSubview:self.linkLabel];
        [self.contentView addSubview:self.linkIDLabel];
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
    [self.linkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.width.mas_equalTo(self.typeLabel.mas_width);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    CGSize lineIDSize = [NSString sizeWithText:self.linkIDLabel.text
                                       andFont:self.linkIDLabel.font
                                    andMaxSize:CGSizeMake(MAXFLOAT, msgFont.lineHeight)];
    CGFloat lineIDWidth = lineIDSize.width;
    if (lineIDWidth > self.contentView.frame.size.width - (offset_X + leftIconWidth + 100 + 5.f)) {
        lineIDWidth = self.contentView.frame.size.width - (offset_X + leftIconWidth + 100 + 5.f);
    }
    [self.linkIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_left);
        make.width.mas_equalTo(lineIDWidth);
        make.top.mas_equalTo(self.linkLabel.mas_top);
        make.height.mas_equalTo(msgFont.lineHeight);
    }];
    [self.linkLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - event method
- (void)linkUrlPressed{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.dataModel.shortUrl]
                                       options:@{}
                             completionHandler:nil];
}

#pragma mark - setter

- (void)setDataModel:(MKBXScanURLCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXScanURLCellModel.class]) {
        return;
    }
    self.txPowerLabel.text = [NSString stringWithFormat:@"%@dBm",_dataModel.txPower];
    self.linkIDLabel.text = SafeStr(_dataModel.shortUrl);
    [self setNeedsLayout];
}

#pragma mark - getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanURLCell", @"mk_bx_littleBluePoint.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [self createLabelWithFont:MKFont(15.f)];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.text = @"URL";
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
    }
    return _txPowerLabel;
}

- (UILabel *)linkLabel{
    if (!_linkLabel) {
        _linkLabel = [self createLabelWithFont:msgFont];
        _linkLabel.text = @"URL link";
    }
    return _linkLabel;
}

- (UILabel *)linkIDLabel{
    if (!_linkIDLabel) {
        _linkIDLabel = [self createLabelWithFont:msgFont];
        _linkIDLabel.numberOfLines = 0;
        _linkIDLabel.textColor = [UIColor blueColor];
        [_linkIDLabel addSubview:self.linkLine];
        [_linkIDLabel addTapAction:self selector:@selector(linkUrlPressed)];
    }
    return _linkIDLabel;
}

- (UIView *)linkLine{
    if (!_linkLine) {
        _linkLine = [[UIView alloc] init];
        _linkLine.backgroundColor = [UIColor blueColor];
    }
    return _linkLine;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
