//
//  MKBXPHTConfigNormalCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPHTConfigNormalCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXPHTConfigNormalCellModel
@end

@interface MKBXPHTConfigNormalCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKBXPHTConfigNormalCell

+ (MKBXPHTConfigNormalCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPHTConfigNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPHTConfigNormalCellIdenty"];
    if (!cell) {
        cell = [[MKBXPHTConfigNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPHTConfigNormalCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.rightIcon];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(5.f);
        make.bottom.mas_equalTo(-5.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXPHTConfigNormalCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
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

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPHTConfigNormalCell", @"bxp_goNextButton.png");
    }
    return _rightIcon;
}

@end
