//
//  MKOptionsCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKOptionsCell.h"
#import "MKSlotDataTypeModel.h"

static NSString *const MKOptionsCellIdenty = @"MKOptionsCellIdenty";

static CGFloat const offset_X = 15.f;
static CGFloat const leftIconWidth = 25.f;
static CGFloat const leftIconHeight = 25.f;
static CGFloat const rightIconWidth = 8.f;
static CGFloat const rightIconHeight = 14.f;

#define labelWidth (self.contentView.frame.size.width - 3 * offset_X - leftIconWidth - rightIconWidth - 2 * 5) / 2

@interface MKOptionsCell()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *leftMsgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKOptionsCell

+ (MKOptionsCell *)initCellWithTabelView:(UITableView *)tableView{
    MKOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:MKOptionsCellIdenty];
    if (!cell) {
        cell = [[MKOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKOptionsCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.leftMsgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addTapAction:self selector:@selector(cellDidSelected)];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
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
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - Private method
- (void)cellDidSelected{
    if (!self.dataModel || !self.dataModel.clickEnable || !self.configSlotDataBlock) {
        return;
    }
    self.configSlotDataBlock(self.dataModel);
}

- (void)setInfos{
    if (!self.dataModel) {
        return;
    }
    switch (self.dataModel.slotType) {
        case slotFrameTypeNull:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeNoData", @"png");
            self.rightMsgLabel.text = @"NO DATA";
            break;
            
        case slotFrameTypeUID:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeCustom", @"png");
            self.rightMsgLabel.text = @"UID";
            break;
            
        case slotFrameTypeTLM:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeCustom", @"png");
            self.rightMsgLabel.text = @"TLM";
            break;
            
        case slotFrameTypeURL:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeCustom", @"png");
            self.rightMsgLabel.text = @"URL";
            break;
            
        case slotFrameTypeInfo:
            self.leftIcon.image = LOADIMAGE(@"slotInfoTypeIcon", @"png");
            self.rightMsgLabel.text = @"Device info";
            break;
            
        case slotFrameTypeiBeacon:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeiBeacon", @"png");
            self.rightMsgLabel.text = @"iBeacon";
            break;
        case slotFrameTypeThreeASensor:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeThreeAccelerometerIcon", @"png");
            self.rightMsgLabel.text = @"3-axis Accelerometer";
            break;
        case slotFrameTypeTHSensor:
            self.leftIcon.image = LOADIMAGE(@"slotDataTypeT&HIcon", @"png");
            self.rightMsgLabel.text = @"T&H";
            break;
    }
    NSString *slotIndexString = [NSString stringWithFormat:@"%ld",(long)(self.dataModel.slotIndex + 1)];
    self.leftMsgLabel.text = [NSString stringWithFormat:@"SLOT%@",slotIndexString];
}

#pragma mark - Public method

- (void)setDataModel:(MKSlotDataTypeModel *)dataModel{
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self setInfos];
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
