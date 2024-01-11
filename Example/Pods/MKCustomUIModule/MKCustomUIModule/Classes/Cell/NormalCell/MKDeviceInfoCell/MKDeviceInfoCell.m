//
//  MKDeviceInfoCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKDeviceInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKDeviceInfoCellModel

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    CGSize leftSize = [NSString sizeWithText:self.leftMsg
                                     andFont:MKFont(15.f)
                                  andMaxSize:CGSizeMake(width / 2 - 15.f - 5.f, MAXFLOAT)];
    
    CGSize rightSize = [NSString sizeWithText:self.leftMsg
                                      andFont:MKFont(15.f)
                                   andMaxSize:CGSizeMake(width / 2 - 15.f - 5.f, MAXFLOAT)];
    CGFloat height = MAX(leftSize.height, rightSize.height);
    return MAX(44.f, height + 20.f);
}

@end

@interface MKDeviceInfoCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@end

@implementation MKDeviceInfoCell

+ (MKDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKDeviceInfoCellIdenty"];
    if (!cell) {
        cell = [[MKDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKDeviceInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize leftSize = [NSString sizeWithText:self.msgLabel.text
                                     andFont:self.msgLabel.font
                                  andMaxSize:CGSizeMake(self.contentView.frame.size.width / 2 - 15.f - 5.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(leftSize.height);
    }];
    
    CGSize rightSize = [NSString sizeWithText:self.rightMsgLabel.text
                                      andFont:self.rightMsgLabel.font
                                   andMaxSize:CGSizeMake(self.contentView.frame.size.width / 2 - 15.f - 5.f, MAXFLOAT)];
    [self.rightMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(rightSize.height);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKDeviceInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKDeviceInfoCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.leftMsg);
    self.rightMsgLabel.text = SafeStr(_dataModel.rightMsg);
    [self setNeedsLayout];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
        _rightMsgLabel.font = MKFont(13.f);
        _rightMsgLabel.numberOfLines = 0;
    }
    return _rightMsgLabel;
}

@end
