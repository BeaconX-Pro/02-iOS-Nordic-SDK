//
//  MKSwitchStatusCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSwitchStatusCell.h"

static NSString *const MKSwitchStatusCellIdenty = @"MKSwitchStatusCellIdenty";

@interface MKSwitchStatusCell ()

@property (nonatomic, strong)UISwitch *switchView;

@end

@implementation MKSwitchStatusCell

+ (MKSwitchStatusCell *)initCellWithTableView:(UITableView *)tableView{
    MKSwitchStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:MKSwitchStatusCellIdenty];
    if (!cell) {
        cell = [[MKSwitchStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKSwitchStatusCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.switchView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - Private method
- (void)switchViewValueChanged{
    if ([self.delegate respondsToSelector:@selector(needChangedCellSwitchStatus:row:)]) {
        [self.delegate needChangedCellSwitchStatus:self.switchView.isOn row:self.indexPath.row];
    }
}

#pragma mark - Public method
- (void)setIsOn:(BOOL)isOn{
    [self.switchView setOn:isOn];
}

#pragma mark - setter & getter
- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.backgroundColor = COLOR_WHITE_MACROS;
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
