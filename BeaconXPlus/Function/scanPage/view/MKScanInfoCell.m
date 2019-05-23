//
//  MKScanInfoCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKScanInfoCell.h"
#import "MKScanBeaconModel.h"

static NSString *const MKScanInfoCellIdenty = @"MKScanInfoCellIdenty";

static NSString *const nullInfoString = @"N/A";

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 22.f;
static CGFloat const batteryIconHeight = 12.f;

@interface MKScanInfoCell()

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

@property (nonatomic, strong)UILabel *connectEnableLabel;

/**
 电池图标
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

/**
 mac地址
 */
@property (nonatomic, strong)UILabel *macLabel;

/**
 底部黑色线条，展开2级菜单的时候显示，关闭2级菜单隐藏
 */
@property (nonatomic, strong)UIView *bottomLineView;

@end

@implementation MKScanInfoCell

+ (MKScanInfoCell *)initCellWithTableView:(UITableView *)tableView{
    MKScanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:MKScanInfoCellIdenty];
    if (!cell) {
        cell = [[MKScanInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKScanInfoCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.rssiIcon];
        [self.contentView addSubview:self.rssiLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.connectButton];
        [self.contentView addSubview:self.batteryIcon];
        [self.contentView addSubview:self.macLabel];
        [self.contentView addSubview:self.bottomLineView];
        [self.contentView addSubview:self.connectEnableLabel];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.rssiIcon setFrame:CGRectMake(offset_X, 15.f, rssiIconWidth, rssiIconHeight)];
    [self.nameLabel setFrame:CGRectMake(offset_X + rssiIconWidth + 10.f,
                                        10.f,
                                        self.contentView.frame.size.width - 20.f - connectButtonWidth - 2 * offset_X,
                                        MKFont(16.f).lineHeight)];
    [self.connectButton setFrame:CGRectMake(self.contentView.frame.size.width - offset_X - connectButtonWidth,
                                            8.f,
                                            connectButtonWidth,
                                            connectButtonHeight)];
    [self.rssiLabel setFrame:CGRectMake(offset_X, 20.f + rssiIconHeight, rssiIconWidth, MKFont(10).lineHeight)];
    [self.connectEnableLabel setFrame:CGRectMake(offset_X + batteryIconWidth + 10.f, 10.f + rssiIconHeight + MKFont(10).lineHeight, self.contentView.frame.size.width - (2 * offset_X + batteryIconWidth + 10.f), MKFont(13.f).lineHeight)];
    [self.batteryIcon setFrame:CGRectMake(offset_X, self.contentView.frame.size.height - batteryIconHeight - 15.f, batteryIconWidth, batteryIconHeight)];
    [self.macLabel setFrame:CGRectMake(offset_X + batteryIconWidth + 10.f, self.contentView.frame.size.height - batteryIconHeight - 18.f, self.contentView.frame.size.width - (2 * offset_X + batteryIconWidth + 15.f), MKFont(16.f).lineHeight)];
}



#pragma mark - Private method

- (void)connectButtonPressed{
    if (self.connectPeripheralBlock) {
        self.connectPeripheralBlock(self.beacon.index);
    }
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

#pragma mark - Public method
- (void)setBeacon:(MKScanBeaconModel *)beacon {
    _beacon = nil;
    _beacon = beacon;
    [self.bottomLineView setHidden:YES];
    if (!_beacon || !_beacon.infoBeacon) {
        //如果数据不存在，可能是尚未扫描到该项设备，全部都显示N/A
        [self.rssiLabel setText:[NSString stringWithFormat:@"%ld",(long)[_beacon.rssi integerValue]]];
        [self.nameLabel setText:nullInfoString];
        [self.macLabel setText:@"MAC:N/A"];
        [self.connectEnableLabel setHidden:YES];
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHighest", @"png")];
        return;
    }
    [self.rssiLabel setText:[NSString stringWithFormat:@"%ld",(long)[_beacon.rssi integerValue]]];
    NSString *name = (ValidStr(_beacon.infoBeacon.deviceName) ? _beacon.infoBeacon.deviceName : nullInfoString);
    [self.nameLabel setText:name];
    NSString *macAddress = (ValidStr(_beacon.infoBeacon.macAddress) ? _beacon.infoBeacon.macAddress : nullInfoString);
    [self.macLabel setText:[NSString stringWithFormat:@"MAC:%@",macAddress]];
    if ([_beacon.infoBeacon.battery integerValue] >= 0 && [_beacon.infoBeacon.battery integerValue] < 20) {
        //最低
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLowest", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 20 && [_beacon.infoBeacon.battery integerValue] < 40){
        //次低
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLower", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 40 && [_beacon.infoBeacon.battery integerValue] < 60){
        //中等
        [self.batteryIcon setImage:LOADIMAGE(@"batteryLow", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 60 && [_beacon.infoBeacon.battery integerValue] < 80){
        //次高
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHigher", @"png")];
    }else if ([_beacon.infoBeacon.battery integerValue] >= 80 && [_beacon.infoBeacon.battery integerValue] <= 100){
        //最高
        [self.batteryIcon setImage:LOADIMAGE(@"batteryHighest", @"png")];
    }
    [self.connectEnableLabel setHidden:NO];
    self.connectEnableLabel.text = (_beacon.infoBeacon.connectEnable ? @"CON" : @"UNCON");
}


#pragma mark - setter & getter

- (UIImageView *)rssiIcon{
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADIMAGE(@"signalIcon", @"png");
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
        _nameLabel = [self createLabelWithFont:MKFont(16.f)];
    }
    return _nameLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:NAVIGATION_BAR_COLOR];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTapAction:self selector:@selector(connectButtonPressed)];
    }
    return _connectButton;
}

- (UILabel *)connectEnableLabel{
    if (!_connectEnableLabel) {
        _connectEnableLabel = [self createLabelWithFont:MKFont(13.f)];
    }
    return _connectEnableLabel;
}

- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADIMAGE(@"batteryHighest", @"png");
    }
    return _batteryIcon;
}

- (UILabel *)macLabel{
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(14)];
    }
    return _macLabel;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = COLOR_BLACK_MARCROS;
    }
    return _bottomLineView;
}

@end
