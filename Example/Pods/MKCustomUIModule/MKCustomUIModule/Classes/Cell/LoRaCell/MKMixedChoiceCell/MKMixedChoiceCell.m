//
//  MKMixedChoiceCell.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMixedChoiceCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const offset_X = 15.f;
static CGFloat const offset_Y = 10.f;
static NSInteger const buttonViewBaseTag = 2021010801;

@implementation MKMixedChoiceCellButtonModel

- (instancetype)init {
    if (self = [super init]) {
        self.enabled = YES;
    }
    return self;
}

- (CGFloat)heightForViewWidth:(CGFloat)viewWidth {
    CGFloat iconWidth = 15.f;
    CGFloat iconHeight = 15.f;
    if (self.selectedIcon) {
        iconWidth = self.selectedIcon.size.width;
        iconHeight = self.selectedIcon.size.height;
    }
    UIFont *msgFont = (self.buttonMsgFont ? self.buttonMsgFont : MKFont(11.f));
    CGFloat msgWith = viewWidth - 4 - iconWidth;
    CGSize msgSize = [NSString sizeWithText:self.buttonMsg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(msgWith, MAXFLOAT)];
    CGFloat tempHeight = MAX(msgSize.height, iconHeight);
    return MAX(tempHeight, 20.f);
}

@end

@implementation MKMixedChoiceCellModel

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width {
    UIFont *msgFont = (self.msgFont ? self.msgFont : MKFont(15.f));
    CGFloat maxMsgWidth = width - 2 * offset_X;
    CGFloat iconHeight = 0;
    if (self.leftIcon) {
        maxMsgWidth = maxMsgWidth - self.leftIcon.size.width - 3.f;
        iconHeight = self.leftIcon.size.height;
    }
    CGSize msgSize = [NSString sizeWithText:self.msg
                                    andFont:msgFont
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    CGFloat msgHeight = MAX(msgSize.height, iconHeight);
    
    CGFloat buttonViewHeight = offset_Y;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKMixedChoiceCellButtonModel *buttonModel = self.dataList[i];
        CGFloat tempViewHeight = [buttonModel heightForViewWidth:(width - 2 * offset_X)];
        buttonViewHeight += (tempViewHeight + offset_Y);
    }
    if (!ValidStr(self.noteMsg)) {
        return MAX(msgHeight + 2 * offset_Y + buttonViewHeight, 50.f);
    }
    //存在底部的note
    UIFont *noteFont = (self.noteMsgFont ? self.noteMsgFont : MKFont(12.f));
    CGSize noteSize = [NSString sizeWithText:self.noteMsg
                                     andFont:noteFont
                                  andMaxSize:CGSizeMake(width - 2 * offset_X, MAXFLOAT)];
    return MAX(msgHeight + 2 * offset_Y + buttonViewHeight, 50.f) + noteSize.height + 10;
}

@end

@interface MKMixedChoiceButton : UIControl

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKMixedChoiceCellButtonModel *dataModel;

@end

@implementation MKMixedChoiceButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.icon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat iconWidth = 5.f;
    CGFloat iconHeight = 5.f;
    if (self.icon.image) {
        iconWidth = self.icon.image.size.width;
        iconHeight = self.icon.image.size.height;
    }
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(1.f);
        make.width.mas_equalTo(iconWidth);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(iconHeight);
    }];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(self.frame.size.width - iconWidth - 5, MAXFLOAT)];
    CGFloat msgHeight = MAX(msgSize.height, iconHeight);
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-1.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(msgHeight);
    }];
}

#pragma mark -
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(11.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

@end

@interface MKMixedChoiceCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *noteLabel;

@property (nonatomic, strong)NSMutableArray <MKMixedChoiceButton *>*subViewList;

@end

@implementation MKMixedChoiceCell

+ (MKMixedChoiceCell *)initCellWithTableView:(UITableView *)tableView {
    MKMixedChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMixedChoiceCellIdenty"];
    if (!cell) {
        cell = [[MKMixedChoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKMixedChoiceCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize msgSize = [self msgSize];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.leftIcon) {
            make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(3.f);
        }else{
            make.left.mas_equalTo(offset_X);
        }
        make.right.mas_equalTo(-offset_X);
        make.top.mas_equalTo(offset_Y);
        make.height.mas_equalTo(msgSize.height);
    }];
    if (self.leftIcon) {
        //左侧有图标
        UIImage *image = self.leftIcon.image;
        [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(offset_X);
            make.width.mas_equalTo(image.size.width);
            make.centerY.mas_equalTo(self.msgLabel.mas_centerY);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    for (NSInteger i = 0; i < self.subViewList.count; i ++) {
        MKMixedChoiceButton *buttonView = self.subViewList[i];
        MKMixedChoiceCellButtonModel *buttonModel = self.dataModel.dataList[i];
        if (i == 0) {
            //第一个
            [buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(offset_X);
                make.right.mas_equalTo(-offset_X);
                make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
                make.height.mas_equalTo([buttonModel heightForViewWidth:(self.contentView.frame.size.width - 2 * offset_X)]);
            }];
        }else {
            //非第一个，则以上一个底部为准
            MKMixedChoiceButton *lastView = self.subViewList[i - 1];
            [buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(offset_X);
                make.right.mas_equalTo(-offset_X);
                make.top.mas_equalTo(lastView.mas_bottom).mas_offset(10.f);
                make.height.mas_equalTo([buttonModel heightForViewWidth:(self.contentView.frame.size.width - 2 * offset_X)]);
            }];
        }
        
    }
    CGSize noteSize = [self noteSize];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.right.mas_equalTo(-offset_X);
        make.bottom.mas_equalTo(-offset_Y);
        make.height.mas_equalTo(noteSize.height);
    }];
}

#pragma mark - event method
- (void)buttonViewPressed:(MKMixedChoiceButton *)buttonView {
    buttonView.selected = !buttonView.selected;
    if (buttonView.selected) {
        UIImage *selectedIcon = (buttonView.dataModel.selectedIcon ? buttonView.dataModel.selectedIcon : LOADICON(@"MKCustomUIModule", @"MKMixedChoiceCell", @"mk_customUI_listButtonSelectedIcon.png"));
        buttonView.icon.image = selectedIcon;
    }else {
        UIImage *normalIcon = (buttonView.dataModel.normalIcon ? buttonView.dataModel.normalIcon : LOADICON(@"MKCustomUIModule", @"MKMixedChoiceCell", @"mk_customUI_listButtonUnselectedIcon.png"));
        buttonView.icon.image = normalIcon;
    }
    if ([self.delegate respondsToSelector:@selector(mk_mixedChoiceSubButtonEventMethod:cellIndex:buttonIndex:)]) {
        [self.delegate mk_mixedChoiceSubButtonEventMethod:buttonView.isSelected
                                                cellIndex:self.dataModel.index
                                              buttonIndex:buttonView.dataModel.buttonIndex];
    }
}

#pragma mark -
-(void)setDataModel:(MKMixedChoiceCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKMixedChoiceCellModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_dataModel.contentColor ? _dataModel.contentColor : COLOR_WHITE_MACROS);
    self.msgLabel.text = SafeStr(_dataModel.msg);
    self.msgLabel.font = (_dataModel.msgFont ? _dataModel.msgFont : MKFont(15.f));
    self.msgLabel.textColor = (_dataModel.msgColor ? _dataModel.msgColor : DEFAULT_TEXT_COLOR);
    if (self.leftIcon && self.leftIcon.superview) {
        [self.leftIcon removeFromSuperview];
        self.leftIcon = nil;
    }
    if (_dataModel.leftIcon) {
        self.leftIcon = [[UIImageView alloc] init];
        self.leftIcon.image = _dataModel.leftIcon;
        [self.contentView addSubview:self.leftIcon];
    }
    if (ValidArray(self.subViewList)) {
        for (MKMixedChoiceButton *buttonView in self.subViewList) {
            if (buttonView.superview) {
                [buttonView removeFromSuperview];
            }
        }
        [self.subViewList removeAllObjects];
    }
    for (NSInteger i = 0; i < _dataModel.dataList.count; i ++) {
        MKMixedChoiceButton *buttonView = [self loadButtonWithButtonModel:_dataModel.dataList[i]];
        [self.contentView addSubview:buttonView];
        [self.subViewList addObject:buttonView];
    }
    self.noteLabel.text = SafeStr(_dataModel.noteMsg);
    self.noteLabel.font = (_dataModel.noteMsgFont ? _dataModel.noteMsgFont : MKFont(12.f));
    self.noteLabel.textColor = (_dataModel.noteMsgColor ? _dataModel.noteMsgColor : DEFAULT_TEXT_COLOR);
    [self setNeedsLayout];
}

#pragma mark - private method
- (CGSize)msgSize {
    if (!ValidStr(self.msgLabel.text)) {
        return CGSizeMake(0, 0);
    }
    CGFloat maxMsgWidth = self.contentView.frame.size.width - 2 * 15.f;
    CGFloat iconHeight = 0;
    if (self.leftIcon) {
        UIImage *image = self.leftIcon.image;
        maxMsgWidth = maxMsgWidth - image.size.width - 3.f;
        iconHeight = image.size.height;
    }
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(maxMsgWidth, MAXFLOAT)];
    CGFloat msgHeight = MAX(msgSize.height, iconHeight);
    return CGSizeMake(maxMsgWidth, msgHeight);
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

- (MKMixedChoiceButton *)loadButtonWithButtonModel:(MKMixedChoiceCellButtonModel *)buttonModel {
    MKMixedChoiceButton *buttonView = [[MKMixedChoiceButton alloc] init];
    buttonView.enabled = buttonModel.enabled;
    buttonView.selected = buttonModel.selected;
    if (buttonModel.selected) {
        UIImage *selectedIcon = (buttonModel.selectedIcon ? buttonModel.selectedIcon : LOADICON(@"MKCustomUIModule", @"MKMixedChoiceCell", @"mk_customUI_listButtonSelectedIcon.png"));
        buttonView.icon.image = selectedIcon;
    }else {
        UIImage *normalIcon = (buttonModel.normalIcon ? buttonModel.normalIcon : LOADICON(@"MKCustomUIModule", @"MKMixedChoiceCell", @"mk_customUI_listButtonUnselectedIcon.png"));
        buttonView.icon.image = normalIcon;
    }
    buttonView.msgLabel.text = SafeStr(buttonModel.buttonMsg);
    buttonView.msgLabel.font = (buttonModel.buttonMsgFont ? buttonModel.buttonMsgFont : MKFont(11.f));
    buttonView.msgLabel.textColor = (buttonModel.buttonMsgColor ? buttonModel.buttonMsgColor : DEFAULT_TEXT_COLOR);
    buttonView.dataModel = buttonModel;
    [buttonView addTarget:self
                   action:@selector(buttonViewPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    return buttonView;
}

#pragma mark - getter

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
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

- (NSMutableArray<MKMixedChoiceButton *> *)subViewList {
    if (!_subViewList) {
        _subViewList = [NSMutableArray array];
    }
    return _subViewList;
}

@end
