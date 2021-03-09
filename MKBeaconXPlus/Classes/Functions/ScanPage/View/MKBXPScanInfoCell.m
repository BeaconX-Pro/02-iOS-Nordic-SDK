//
//  MKBXPScanInfoCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPScanInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKBXPBaseBeacon.h"

#import "MKBXPScanBeaconModel.h"

static NSString *const nullInfoString = @"N/A";

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 25.f;
static CGFloat const batteryIconHeight = 25.f;

@interface MKBXPScanInfoCell ()

/**
 信号icon
 */
@property (nonatomic, strong)UIImageView *rssiIcon;

/**
 信号强度
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 设备名称
 */
@property (nonatomic, strong)UILabel *nameLabel;

/**
 连接按钮
 */
@property (nonatomic, strong)UIButton *connectButton;

/**
 电池图标
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

/**
 mac地址
 */
@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *topBackView;

@property (nonatomic, strong)UIView *centerBackView;

@property (nonatomic, strong)UIView *bottomBackView;

@end

@implementation MKBXPScanInfoCell

+ (MKBXPScanInfoCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXPScanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPScanInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXPScanInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPScanInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topBackView];
        [self.contentView addSubview:self.centerBackView];
        [self.contentView addSubview:self.bottomBackView];
        
        [self.topBackView addSubview:self.rssiIcon];
        [self.topBackView addSubview:self.rssiLabel];
        [self.topBackView addSubview:self.nameLabel];
        [self.topBackView addSubview:self.connectButton];
        
        [self.centerBackView addSubview:self.batteryIcon];
        [self.centerBackView addSubview:self.macLabel];
        
        [self.bottomBackView addSubview:self.batteryLabel];
        [self.bottomBackView addSubview:self.txPowerLabel];
        [self.bottomBackView addSubview:self.txPowerValueLabel];
        [self.bottomBackView addSubview:self.timeLabel];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40.f);
    }];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(rssiIconWidth);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(rssiIconWidth);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    CGFloat nameWidth = (self.contentView.frame.size.width - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.nameLabel.text
                                     andFont:self.nameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(20.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.centerY.mas_equalTo(self.topBackView.mas_centerY);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    [self.centerBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topBackView.mas_bottom);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(batteryIconWidth);
        make.centerY.mas_equalTo(self.centerBackView.mas_centerY);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-100.f);
        make.centerY.mas_equalTo(self.centerBackView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    
    [self.bottomBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.centerBackView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(3.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.batteryLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.txPowerLabel.mas_right);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.txPowerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed{
    if ([self.delegate respondsToSelector:@selector(connectPeripheralWithIndex:)]) {
        [self.delegate connectPeripheralWithIndex:self.beacon.index];
    }
}

#pragma mark - setter
- (void)setBeacon:(MKBXPScanBeaconModel *)beacon {
    _beacon = beacon;
    self.txPowerLabel.text = @"";
    self.txPowerValueLabel.text = @"";
    self.timeLabel.text = @"";
    self.timeLabel.text = beacon.displayTime;
    if (!_beacon || !_beacon.infoBeacon) {
        //如果数据不存在，可能是尚未扫描到该项设备，全部都显示N/A
        [self.rssiLabel setText:[NSString stringWithFormat:@"%ld",(long)[_beacon.rssi integerValue]]];
        [self.nameLabel setText:nullInfoString];
        [self.macLabel setText:@"MAC:N/A"];
        [self setNeedsLayout];
        return;
    }
    [self.rssiLabel setText:[NSString stringWithFormat:@"%ld",(long)[_beacon.rssi integerValue]]];
    NSString *name = (ValidStr(_beacon.deviceName) ? _beacon.deviceName : nullInfoString);
    [self.nameLabel setText:name];
    NSString *macAddress = (ValidStr(_beacon.infoBeacon.macAddress) ? _beacon.infoBeacon.macAddress : nullInfoString);
    [self.macLabel setText:[NSString stringWithFormat:@"MAC:%@",macAddress]];
    NSInteger battery = [_beacon.infoBeacon.battery integerValue];
    self.batteryLabel.text = [NSString stringWithFormat:@"%ld%@",(long)battery,@"mV"];
    self.txPowerLabel.text = @"Tx Power";
    self.txPowerValueLabel.text = [NSString stringWithFormat:@"%lddBm",(long)[_beacon.infoBeacon.txPower integerValue]];
    [self setNeedsLayout];
}


#pragma mark - getter

- (UIImageView *)rssiIcon{
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPScanInfoCell", @"bxp_signalIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:MKFont(10)];
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rssiLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [self createLabelWithFont:MKFont(15.f)];
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:UIColorFromRGB(0x2F84D0)];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTarget:self action:@selector(connectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPScanInfoCell", @"bxp_batteryHighest.png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:MKFont(10.f)];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryLabel;
}

- (UILabel *)macLabel{
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(13)];
    }
    return _macLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [self createLabelWithFont:MKFont(13.f)];
        _txPowerLabel.text = @"Tx Power:";
    }
    return _txPowerLabel;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _txPowerValueLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:MKFont(10.f)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
    }
    return _topBackView;
}

- (UIView *)centerBackView {
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] init];
    }
    return _centerBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
    }
    return _bottomBackView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
