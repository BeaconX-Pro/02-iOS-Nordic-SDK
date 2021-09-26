//
//  MKBXPLightSensorButtonView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPLightSensorButtonView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXPLightSensorButtonViewModel
@end

@interface MKBXPLightSensorButtonView ()

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXPLightSensorButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize iconSize = self.icon.image.size;
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(iconSize.width);
        make.top.mas_equalTo(2.f);
        make.height.mas_equalTo(iconSize.height);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXPLightSensorButtonViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXPLightSensorButtonViewModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.icon.image = _dataModel.icon;
}

#pragma mark - getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(11.f);
    }
    return _msgLabel;
}

@end
