//
//  MKBXPRecodeHistoryHudView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2023/9/27.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPRecodeHistoryHudView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

@interface MKBXPRecodeHistoryHudView ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXPRecodeHistoryHudView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(self.frame.size.width - 2 * 90);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - public method
- (void)showMsg:(NSString *)msg {
    self.msgLabel.text = msg;
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.backgroundColor = [UIColor blackColor];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.numberOfLines = 0;
        
        _msgLabel.layer.masksToBounds = YES;
        _msgLabel.layer.maskedCorners = 6;
    }
    return _msgLabel;
}

@end
