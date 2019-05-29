//
//  MKAxisAcceDataCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAxisAcceDataCell.h"

@interface MKAxisAcceDataCell ()

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *xDataLabel;

@property (nonatomic, strong)UILabel *yDataLabel;

@property (nonatomic, strong)UILabel *zDataLabel;

@property (nonatomic, strong)UILabel *bottomLabel;

@end

@implementation MKAxisAcceDataCell

+ (MKAxisAcceDataCell *)initCellWithTableView:(UITableView *)table {
    MKAxisAcceDataCell *cell = [table dequeueReusableCellWithIdentifier:@"MKAxisAcceDataCellIdenty"];
    if (!cell) {
        cell = [[MKAxisAcceDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAxisAcceDataCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self.contentView addSubview:self.syncLabel];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.xDataLabel];
        [self.contentView addSubview:self.yDataLabel];
        [self.contentView addSubview:self.zDataLabel];
        [self.contentView addSubview:self.bottomLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    CGFloat width = (kScreenWidth - 6 * 15.f) / 3;
    [self.xDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(width);
        make.top.mas_equalTo(self.syncLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.yDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.zDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xDataLabel.mas_left);
        make.right.mas_equalTo(self.zDataLabel.mas_right);
        make.top.mas_equalTo(self.xDataLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    if ([self.delegate respondsToSelector:@selector(updateThreeAxisNotifyStatus:)]) {
        [self.delegate updateThreeAxisNotifyStatus:self.syncButton.selected];
    }
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[self animation] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    self.syncLabel.text = @"Sync";
}

#pragma mark -
- (void)setAxisData:(NSDictionary *)axisData {
    _axisData = nil;
    _axisData = axisData;
    if (!ValidDict(_axisData)) {
        return;
    }
    NSArray *dataList = axisData[@"axisData"];
    if (!ValidArray(dataList)) {
        return;
    }
    NSDictionary *data = [dataList lastObject];
    self.xDataLabel.text = [@"X-Data:0x" stringByAppendingString:data[@"x-Data"]];
    self.yDataLabel.text = [@"Y-Data:0x" stringByAppendingString:data[@"y-Data"]];
    self.zDataLabel.text = [@"Z-Data:0x" stringByAppendingString:data[@"z-Data"]];
}

#pragma mark - private method
- (CABasicAnimation *)animation{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = 2.f;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

#pragma mark - setter & getter
- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTapAction:self selector:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADIMAGE(@"threeAxisAcceLoadingIcon", @"png");
        _synIcon.userInteractionEnabled = YES;
    }
    return _synIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"3-Axis Accelerometer Data";
    }
    return _msgLabel;
}

- (UILabel *)xDataLabel {
    if (!_xDataLabel) {
        _xDataLabel = [[UILabel alloc] init];
        _xDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _xDataLabel.textAlignment = NSTextAlignmentCenter;
        _xDataLabel.font = MKFont(12.f);
        _xDataLabel.text = @"X-Data:0x0000";
    }
    return _xDataLabel;
}

- (UILabel *)yDataLabel {
    if (!_yDataLabel) {
        _yDataLabel = [[UILabel alloc] init];
        _yDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _yDataLabel.textAlignment = NSTextAlignmentCenter;
        _yDataLabel.font = MKFont(12.f);
        _yDataLabel.text = @"Y-Data:0x0000";
    }
    return _yDataLabel;
}

- (UILabel *)zDataLabel {
    if (!_zDataLabel) {
        _zDataLabel = [[UILabel alloc] init];
        _zDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _zDataLabel.textAlignment = NSTextAlignmentCenter;
        _zDataLabel.font = MKFont(12.f);
        _zDataLabel.text = @"Z-Data:0x0000";
    }
    return _zDataLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.textColor = RGBCOLOR(229, 173, 140);
        _bottomLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLabel.font = MKFont(11.f);
        _bottomLabel.text = @"Scale = ±0g;  Data Rare = 0Hz";
    }
    return _bottomLabel;
}

@end
