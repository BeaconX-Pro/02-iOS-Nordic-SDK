//
//  MKNormalTextCell.m
//  mokoLibrary_Example
//
//  Created by aa on 2020/12/16.
//  Copyright © 2020 Chengang. All rights reserved.
//

#import "MKNormalTextCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const offset_X = 15.f;

@implementation MKNormalTextCellModel

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    UIFont *msgFont = (self.leftMsgTextFont ? self.leftMsgTextFont : MKFont(15.f));
    CGFloat maxMsgWidth = width / 2 - offset_X - 3.f;
    if (self.leftIcon) {
        maxMsgWidth = maxMsgWidth - self.leftIcon.size.width - 3.f;
    }
    CGSize msgSize = [NSString sizeWithText:self.leftMsg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    if (!ValidStr(self.noteMsg)) {
        //没有底部note内容
        return MAX(msgSize.height + 2 * offset_X, 50.f);
    }
    //存在底部的note
    UIFont *noteFont = (self.noteMsgFont ? self.noteMsgFont : MKFont(12.f));
    CGSize noteSize = [NSString sizeWithText:self.noteMsg
                                     andFont:noteFont
                                  andMaxSize:CGSizeMake(width - 2 * offset_X, MAXFLOAT)];
    return MAX(msgSize.height + 2 * offset_X, 50.f) + noteSize.height + 10.f;
}

@end


@interface MKNormalTextCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *leftMsgLabel;

@property (nonatomic, strong)UILabel *rightMsgLabel;

@property (nonatomic, strong)UIImageView *rightIcon;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKNormalTextCell

+ (MKNormalTextCell *)initCellWithTableView:(UITableView *)tableView {
    MKNormalTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKNormalTextCellIdenty"];
    if (!cell) {
        cell = [[MKNormalTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKNormalTextCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftMsgLabel];
        [self.contentView addSubview:self.rightMsgLabel];
        [self.contentView addSubview:self.rightIcon];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL hasNote = ValidStr(self.noteLabel.text);
    
    CGSize msgSize = [self msgSize];
    [self.leftMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.leftIcon) {
            make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(3.f);
        }else{
            make.left.mas_equalTo(offset_X);
        }
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-3.f);
        if (hasNote) {
            //有底部的note标签内容
            make.top.mas_equalTo(offset_X);
        }else {
            //如果没有，则上下居中
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }
        make.height.mas_equalTo(msgSize.height);
    }];
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
    
    [self.rightIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(8.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(14.f);
    }];
    [self.rightMsgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.dataModel.showRightIcon) {
            make.right.mas_equalTo(self.rightIcon.mas_left).mas_offset(-2.f);
        }else {
            make.right.mas_equalTo(-15.f);
        }
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.centerY.mas_equalTo(self.leftMsgLabel.mas_centerY);
        make.height.mas_equalTo(self.rightMsgLabel.font.lineHeight);
    }];
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_X);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark -
- (void)setDataModel:(MKNormalTextCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKNormalTextCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.leftMsgLabel.text = (ValidStr(_dataModel.leftMsg) ? _dataModel.leftMsg : @"");
    self.leftMsgLabel.textColor = (_dataModel.leftMsgTextColor ? _dataModel.leftMsgTextColor : DEFAULT_TEXT_COLOR);
    self.leftMsgLabel.font = (_dataModel.leftMsgTextFont ? _dataModel.leftMsgTextFont : MKFont(15.f));
    self.rightMsgLabel.text = (ValidStr(_dataModel.rightMsg) ? _dataModel.rightMsg : @"");
    self.rightMsgLabel.textColor = (_dataModel.rightMsgTextColor ? _dataModel.rightMsgTextColor : UIColorFromRGB(0x808080));
    self.rightMsgLabel.font = (_dataModel.rightMsgTextFont ? _dataModel.rightMsgTextFont : MKFont(13.f));
    self.rightIcon.hidden = !_dataModel.showRightIcon;
    if (self.leftIcon && self.leftIcon.superview) {
        [self.leftIcon removeFromSuperview];
        self.leftIcon = nil;
    }
    if (_dataModel.leftIcon) {
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = _dataModel.leftIcon;
        [self.contentView addSubview:self.leftIcon];
    }
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setNeedsLayout];
}

- (CGSize)msgSize {
    if (!ValidStr(self.leftMsgLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat maxMsgWidth = self.contentView.frame.size.width / 2 - offset_X - 3.f;
    if (self.leftIcon) {
        UIImage *image = self.leftIcon.image;
        maxMsgWidth = maxMsgWidth - image.size.width - 3.f;
    }
    CGSize msgSize = [NSString sizeWithText:self.leftMsgLabel.text
                                    andFont:self.leftMsgLabel.font
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    return CGSizeMake(maxMsgWidth, msgSize.height);
}

- (CGSize)noteSize {
    if (!ValidStr(self.noteLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat width = self.contentView.frame.size.width - 2 * offset_X;
    CGSize noteSize = [NSString sizeWithText:self.noteLabel.text
                                     andFont:self.noteLabel.font
                                  andMaxSize:CGSizeMake(width, MAXFLOAT)];
    return CGSizeMake(width, noteSize.height);
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

- (UILabel *)rightMsgLabel {
    if (!_rightMsgLabel) {
        _rightMsgLabel = [[UILabel alloc] init];
        _rightMsgLabel.textColor = UIColorFromRGB(0x808080);
        _rightMsgLabel.textAlignment = NSTextAlignmentRight;
        _rightMsgLabel.font = MKFont(13.f);
    }
    return _rightMsgLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] init];
        _rightIcon.image = LOADICON(@"MKCustomUIModule", @"MKNormalTextCell", @"mk_customUI_goNextButton.png");
    }
    return _rightIcon;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = DEFAULT_TEXT_COLOR;
        _noteLabel.font = MKFont(12.f);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end
