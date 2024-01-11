//
//  MKDeviceInfoDfuCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKDeviceInfoDfuCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKDeviceInfoDfuCellModel
@end

@interface MKDeviceInfoDfuCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIButton *rightButton;

@end

@implementation MKDeviceInfoDfuCell

+ (MKDeviceInfoDfuCell *)initCellWithTableView:(UITableView *)tableView {
    MKDeviceInfoDfuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDeviceInfoDfuCellIdenty"];
    if (!cell) {
        cell = [[MKDeviceInfoDfuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKDeviceInfoDfuCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.rightMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(10.f);
        make.right.mas_equalTo(self.rightButton.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)rightButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_textButtonCell_buttonAction:)]) {
        [self.delegate mk_textButtonCell_buttonAction:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKDeviceInfoDfuCellModel *)dataModel {
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKDeviceInfoDfuCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.leftMsg);
    self.rightMsgLabel.text = SafeStr(_dataModel.rightMsg);
    [self.rightButton setTitle:_dataModel.rightButtonTitle forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _msgLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [MKCustomUIAdopter customButtonWithTitle:@"OK"
                                                         target:self
                                                         action:@selector(rightButtonPressed)];
        [_rightButton.titleLabel setFont:MKFont(12.f)];
    }
    return _rightButton;
}

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = UIColorFromRGB(0x808080);
        _rightMsgLabel.font = MKFont(13.f);
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightMsgLabel;
}

@end
