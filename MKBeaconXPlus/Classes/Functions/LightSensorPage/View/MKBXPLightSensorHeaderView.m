//
//  MKBXPLightSensorHeaderView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPLightSensorHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXPLightSensorHeaderViewModel
@end

@interface MKBXPLightSensorHeaderView ()

@property (nonatomic, strong)UIView *topView;

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *sensorLabel;

@property (nonatomic, strong)UILabel *sensorStatusLabel;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *dateLabel;

@end

@implementation MKBXPLightSensorHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.topView];
        [self.topView addSubview:self.icon];
        [self.topView addSubview:self.sensorLabel];
        [self.topView addSubview:self.sensorStatusLabel];
        
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.syncLabel];
        [self.bottomView addSubview:self.syncButton];
        [self.bottomView addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(44.f);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(33.f);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(33.f);
    }];
    [self.sensorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.sensorStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sensorLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-5.f);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(90.f);
    }];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(self.syncButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxp_lightSensorSyncTime)]) {
        [self.delegate bxp_lightSensorSyncTime];
    }
}

#pragma mark - public method
- (void)updateSensorStatus:(BOOL)detected {
    self.sensorStatusLabel.text = (detected ? @"Ambient light detected" : @"Ambient light NOT detected");
}

- (void)updateCurrentTime:(NSString *)time {
    self.dateLabel.text = SafeStr(time);
}

#pragma mark - getter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = COLOR_WHITE_MACROS;
        
        _topView.layer.masksToBounds = YES;
        _topView.layer.cornerRadius = 6.f;
    }
    return _topView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPLightSensorHeaderView", @"bxp_lightSensorIcon.png");
    }
    return _icon;
}

- (UILabel *)sensorLabel {
    if (!_sensorLabel) {
        _sensorLabel = [[UILabel alloc] init];
        _sensorLabel.textColor = DEFAULT_TEXT_COLOR;
        _sensorLabel.font = MKFont(15.f);
        _sensorLabel.textAlignment = NSTextAlignmentLeft;
        _sensorLabel.text = @"Sensor status";
    }
    return _sensorLabel;
}

- (UILabel *)sensorStatusLabel {
    if (!_sensorStatusLabel) {
        _sensorStatusLabel = [[UILabel alloc] init];
        _sensorStatusLabel.textColor = DEFAULT_TEXT_COLOR;
        _sensorStatusLabel.textAlignment = NSTextAlignmentRight;
        _sensorStatusLabel.font = MKFont(13.f);
        _sensorStatusLabel.text = @"Ambient light NOT detected";
    }
    return _sensorStatusLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WHITE_MACROS;
        
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 6.f;
    }
    return _bottomView;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentLeft;
        _syncLabel.font = MKFont(15.f);
        _syncLabel.text = @"Sync Beacon time";
    }
    return _syncLabel;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [MKCustomUIAdopter customButtonWithTitle:@"Sync"
                                                        target:self
                                                        action:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = DEFAULT_TEXT_COLOR;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.font = MKFont(15.f);
    }
    return _dateLabel;
}

@end
