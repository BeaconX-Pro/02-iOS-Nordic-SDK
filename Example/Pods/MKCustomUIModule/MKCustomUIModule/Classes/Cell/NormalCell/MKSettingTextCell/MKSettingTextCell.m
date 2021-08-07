//
//  MKSettingTextCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/7/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKSettingTextCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

static CGFloat const offset_X = 15.f;

@implementation MKSettingTextCellModel
@end

@interface MKSettingTextCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *leftMsgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@end

@implementation MKSettingTextCell

+ (MKSettingTextCell *)initCellWithTableView:(UITableView *)tableView {
    MKSettingTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKSettingTextCellIdenty"];
    if (!cell) {
        cell = [[MKSettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKSettingTextCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftMsgLabel];
        [self.contentView addSubview:self.rightIcon];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
        
    if (self.leftIcon) {
        //左侧有图标
        UIImage *image = self.leftIcon.image;
        [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset_X);
            make.width.mas_equalTo(image.size.width);
            make.centerY.mas_equalTo(self.leftMsgLabel.mas_centerY);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    
    [self.leftMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.leftIcon) {
            make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(3.f);
        }else{
            make.left.mas_equalTo(offset_X);
        }
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(self.leftMsgLabel.font.lineHeight);
    }];
    
    
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
}

#pragma mark -
- (void)setDataModel:(MKSettingTextCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKSettingTextCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.leftMsgLabel.text = (ValidStr(_dataModel.leftMsg) ? _dataModel.leftMsg : @"");
    self.leftMsgLabel.textColor = (_dataModel.leftMsgTextColor ? _dataModel.leftMsgTextColor : DEFAULT_TEXT_COLOR);
    self.leftMsgLabel.font = (_dataModel.leftMsgTextFont ? _dataModel.leftMsgTextFont : MKFont(15.f));
    if (self.leftIcon && self.leftIcon.superview) {
        [self.leftIcon removeFromSuperview];
        self.leftIcon = nil;
    }
    if (_dataModel.leftIcon) {
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = _dataModel.leftIcon;
        [self.contentView addSubview:self.leftIcon];
    }
    [self setNeedsLayout];
}

#pragma mark - setter & getter
- (UILabel *)leftMsgLabel {
    if (!_leftMsgLabel) {
        _leftMsgLabel = [[UILabel alloc] init];
        _leftMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _leftMsgLabel.textAlignment = NSTextAlignmentLeft;
        _leftMsgLabel.font = MKFont(15.f);
        _leftMsgLabel.numberOfLines = 0;
    }
    return _leftMsgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKCustomUIModule", @"MKSettingTextCell", @"mk_customUI_goNextButton.png");
    }
    return _rightIcon;
}

@end
