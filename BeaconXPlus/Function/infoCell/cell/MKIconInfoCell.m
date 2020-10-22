//
//  MKIconInfoCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/24.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKIconInfoCell.h"
#import "MKMainCellModel.h"

static CGFloat const offset_X = 15.f;
static CGFloat const leftIconWidth = 25.f;
static CGFloat const leftIconHeight = 25.f;
static CGFloat const rightIconWidth = 8.f;
static CGFloat const rightIconHeight = 14.f;

#define labelWidth (self.contentView.frame.size.width - 3 * offset_X - leftIconWidth - rightIconWidth - 2 * 5) / 2

@interface MKIconInfoCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *leftMsgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKIconInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.leftMsgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.rightIcon];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(leftIconHeight);
    }];
    CGSize leftSize = [NSString sizeWithText:self.leftMsgLabel.text
                                     andFont:self.leftMsgLabel.font
                                  andMaxSize:CGSizeMake(MAXFLOAT, self.leftMsgLabel.font.lineHeight)];
    CGFloat leftMsgWidth = MIN(labelWidth, leftSize.width);
    [self.leftMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5);
        make.width.mas_equalTo(leftMsgWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftMsgLabel.mas_right).mas_offset(offset_X);
        make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(rightIconWidth);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(rightIconHeight);
    }];
}

#pragma mark - Public method
- (void)setDataModel:(MKMainCellModel *)dataModel{
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    if (ValidStr(_dataModel.leftIconName)) {
        [self.leftIcon setImage:LOADIMAGE(_dataModel.leftIconName, @"png")];
    }
    if (ValidStr(_dataModel.leftMsg)) {
        [self.leftMsgLabel setText:_dataModel.leftMsg];
    }
    if (ValidStr(_dataModel.rightMsg)) {
        [self.rightMsgLabel setText:_dataModel.rightMsg];
    }
    if (ValidStr(_dataModel.rightIconName)) {
        [self.rightIcon setImage:LOADIMAGE(_dataModel.rightIconName, @"png")];
    }
    [self.rightIcon setHidden:_dataModel.hiddenRightIcon];
    [self setNeedsLayout];
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
    }
    return _leftIcon;
}

- (UILabel *)leftMsgLabel{
    if (!_leftMsgLabel) {
        _leftMsgLabel = [[UILabel alloc] init];
        _leftMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _leftMsgLabel.font = MKFont(15.f);
        _leftMsgLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftMsgLabel;
}

- (UILabel *)rightMsgLabel{
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = RGBCOLOR(114, 114, 114);
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
        _rightMsgLabel.font = MKFont(15.f);
    }
    return _rightMsgLabel;
}

- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADIMAGE(@"goto_next_button", @"png");
    }
    return _rightIcon;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

@end
