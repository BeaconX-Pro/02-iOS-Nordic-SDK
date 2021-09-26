//
//  MKBXQuickSwitchCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/16.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXQuickSwitchCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static CGFloat const switchButtonWidth = 40.f;
static CGFloat const switchButtonHeight = 30.f;

@implementation MKBXQuickSwitchCellLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //从第二个循环到最后一个
    for (NSInteger i = 1 ; i < attributes.count ; i ++ )
        {
        //当前的attribute
        UICollectionViewLayoutAttributes * currentLayoutAttributes = attributes[i];
        
        //上一个attribute
        UICollectionViewLayoutAttributes * prevLayoutAttributes = attributes[i - 1];
        
        //设置的最大间距，根绝需要修改
        CGFloat maximumSpacing = 11.0;
        
        //前一个cell的最右边
        CGFloat origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        //如果当前一个cell的最右边加上我们的想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有的cell的x值都被加到第一行最后一个元素的后面了
        if (origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width)
            {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
            }
        
        }
    
    return attributes;
}

@end

@implementation MKBXQuickSwitchCellModel
@end

@interface MKBXQuickSwitchCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *switchStatusLabel;

@end

@implementation MKBXQuickSwitchCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.switchButton];
        [self.backView addSubview:self.switchStatusLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(self.contentView.frame.size.width - 2 * 5.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(msgSize.height);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(switchButtonWidth);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(switchButtonHeight);
    }];
    [self.switchStatusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    [self updateSwitchButtonIcon];
    if ([self.delegate respondsToSelector:@selector(mk_bx_quickSwitchStatusChanged:index:)]) {
        [self.delegate mk_bx_quickSwitchStatusChanged:self.switchButton.selected index:self.dataModel.index];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXQuickSwitchCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXQuickSwitchCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.titleMsg);
    self.switchButton.selected = _dataModel.isOn;
    [self updateSwitchButtonIcon];
}

#pragma mark - private method
- (void)updateSwitchButtonIcon {
    UIImage *image = (self.switchButton.selected ? LOADICON(@"MKBeaconXCustomUI", @"MKBXQuickSwitchCell", @"mk_bx_switchSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXQuickSwitchCell", @"mk_bx_switchUnselectedIcon.png"));
    [self.switchButton setImage:image forState:UIControlStateNormal];
    UIColor *statusColor = (self.switchButton.selected ? NAVBAR_COLOR_MACROS : UIColorFromRGB(0xcccccc));
    self.switchStatusLabel.textColor = statusColor;
    self.switchStatusLabel.text = (self.switchButton.selected ? @"Enabled" : @"Disabled");
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = NO;
        _backView.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _backView.layer.borderWidth = CUTTING_LINE_HEIGHT;
        _backView.layer.cornerRadius = 6.f;
        _backView.layer.shadowColor = DEFAULT_TEXT_COLOR.CGColor;
        _backView.layer.shadowOffset = CGSizeMake(1.5, 3);
        _backView.layer.shadowOpacity = .8f;
    }
    return _backView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(13.f);
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)switchStatusLabel {
    if (!_switchStatusLabel) {
        _switchStatusLabel = [[UILabel alloc] init];
        _switchStatusLabel.textAlignment = NSTextAlignmentLeft;
        _switchStatusLabel.textColor = UIColorFromRGB(0xcccccc);
        _switchStatusLabel.font = MKFont(13.f);
    }
    return _switchStatusLabel;
}

@end
