//
//  MKBXPAccelerationHeaderView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPAccelerationHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@interface MKBXPAccelerationHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UILabel *xDataLabel;

@property (nonatomic, strong)UILabel *yDataLabel;

@property (nonatomic, strong)UILabel *zDataLabel;

@end

@implementation MKBXPAccelerationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self.backView addSubview:self.syncLabel];
        [self.backView addSubview:self.xDataLabel];
        [self.backView addSubview:self.yDataLabel];
        [self.backView addSubview:self.zDataLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(15.f);
        make.bottom.mas_equalTo(-30.f);
    }];
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
    CGFloat width = (kViewWidth - 6 * 15.f) / 3;
    [self.xDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.yDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xDataLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.zDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.yDataLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(width);
        make.centerY.mas_equalTo(self.xDataLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"bxp_synIconAnimationKey"];
    if ([self.delegate respondsToSelector:@selector(bxp_updateThreeAxisNotifyStatus:)]) {
        [self.delegate bxp_updateThreeAxisNotifyStatus:self.syncButton.selected];
    }
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"bxp_synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    self.syncLabel.text = @"Sync";
}

#pragma mark - public method
- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData {
    self.xDataLabel.text = [@"X-Data:0x" stringByAppendingString:xData];
    self.yDataLabel.text = [@"Y-Data:0x" stringByAppendingString:yData];
    self.zDataLabel.text = [@"Z-Data:0x" stringByAppendingString:zData];
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTarget:self
                        action:@selector(syncButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPAccelerationHeaderView", @"bxp_threeAxisAcceLoadingIcon.png");
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

- (UILabel *)xDataLabel {
    if (!_xDataLabel) {
        _xDataLabel = [[UILabel alloc] init];
        _xDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _xDataLabel.textAlignment = NSTextAlignmentCenter;
        _xDataLabel.font = MKFont(12.f);
        _xDataLabel.text = @"X-Data:N/A";
    }
    return _xDataLabel;
}

- (UILabel *)yDataLabel {
    if (!_yDataLabel) {
        _yDataLabel = [[UILabel alloc] init];
        _yDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _yDataLabel.textAlignment = NSTextAlignmentCenter;
        _yDataLabel.font = MKFont(12.f);
        _yDataLabel.text = @"Y-Data:N/A";
    }
    return _yDataLabel;
}

- (UILabel *)zDataLabel {
    if (!_zDataLabel) {
        _zDataLabel = [[UILabel alloc] init];
        _zDataLabel.textColor = DEFAULT_TEXT_COLOR;
        _zDataLabel.textAlignment = NSTextAlignmentCenter;
        _zDataLabel.font = MKFont(12.f);
        _zDataLabel.text = @"Z-Data:N/A";
    }
    return _zDataLabel;
}

@end
