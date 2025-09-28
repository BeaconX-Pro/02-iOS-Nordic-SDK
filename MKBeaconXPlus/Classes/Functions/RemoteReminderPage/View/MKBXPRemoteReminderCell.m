//
//  MKBXPRemoteReminderCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2022/3/3.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPRemoteReminderCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXPRemoteReminderCellModel
@end

@interface MKBXPRemoteReminderCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *remindButton;

@end

@implementation MKBXPRemoteReminderCell

+ (MKBXPRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPRemoteReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPRemoteReminderCellIdenty"];
    if (!cell) {
        cell = [[MKBXPRemoteReminderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPRemoteReminderCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.remindButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.remindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(35.f);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.remindButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)remindButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxd_remindButtonPressed:)]) {
        [self.delegate bxd_remindButtonPressed:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXPRemoteReminderCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXPRemoteReminderCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
    }
    return _msgLabel;
}

- (UIButton *)remindButton {
    if (!_remindButton) {
        _remindButton = [MKCustomUIAdopter customButtonWithTitle:@"Remind"
                                                          target:self
                                                          action:@selector(remindButtonPressed)];
    }
    return _remindButton;
}

@end
