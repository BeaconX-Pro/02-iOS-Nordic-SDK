//
//  MKBXScanSearchButton.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/11.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXScanSearchButton.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXScanSearchButtonModel
@end

@interface MKBXScanSearchButton ()

/**
 搜索图标
 */
@property (nonatomic, strong)UIImageView *searchIcon;

/**
 button的标题
 */
@property (nonatomic, strong)UILabel *titleLabel;

/**
 搜索条件
 */
@property (nonatomic, strong)UILabel *searchLabel;

/**
 清除搜索条件
 */
@property (nonatomic, strong)UIButton *clearButton;

@end

@implementation MKBXScanSearchButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE_MACROS;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.f;
        [self addSubview:self.searchIcon];
        [self addSubview:self.titleLabel];
        [self addSubview:self.searchLabel];
        [self addSubview:self.clearButton];
        [self addTarget:self
                 action:@selector(searchButtonPressed)
       forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchIcon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-10);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(self.mas_height);
    }];
}

#pragma mark - Private method

- (void)clearButtonPressed{
    [self.titleLabel setHidden:NO];
    [self.searchIcon setHidden:NO];
    [self.searchLabel setHidden:YES];
    [self.clearButton setHidden:YES];
    if ([self.delegate respondsToSelector:@selector(mk_bx_scanSearchButtonClearMethod)]) {
        [self.delegate mk_bx_scanSearchButtonClearMethod];
    }
}

- (void)searchButtonPressed{
    if ([self.delegate respondsToSelector:@selector(mk_bx_scanSearchButtonMethod)]) {
        [self.delegate mk_bx_scanSearchButtonMethod];
    }
}

#pragma mark - setting
- (void)setDataModel:(MKBXScanSearchButtonModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXScanSearchButtonModel.class]) {
        return;
    }
    self.titleLabel.text = (ValidStr(_dataModel.placeholder) ? _dataModel.placeholder : @"Edit Filter");
    NSMutableArray *conditions = [NSMutableArray array];
    if (ValidStr(_dataModel.searchName)) {
        [conditions addObject:_dataModel.searchName];
    }
    if (ValidStr(_dataModel.searchMac)) {
        [conditions addObject:_dataModel.searchMac];
    }
    if (_dataModel.searchRssi > _dataModel.minSearchRssi) {
        NSString *rssiValue = [NSString stringWithFormat:@"%lddBm",(long)_dataModel.searchRssi];
        [conditions addObject:rssiValue];
    }
    if (!ValidArray(conditions)) {
        [self.titleLabel setHidden:NO];
        [self.searchIcon setHidden:NO];
        [self.searchLabel setHidden:YES];
        [self.clearButton setHidden:YES];
        return;
    }
    [self.titleLabel setHidden:YES];
    [self.searchIcon setHidden:YES];
    [self.searchLabel setHidden:NO];
    [self.clearButton setHidden:NO];
    NSString *title = @"";
    for (NSString *string in conditions) {
        title = [title stringByAppendingString:[NSString stringWithFormat:@";%@",string]];
    }
    [self.searchLabel setText:[title substringFromIndex:1]];
}

#pragma mark - getter
- (UIImageView *)searchIcon{
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXScanSearchButton", @"mk_bx_searchGrayIcon.png");
    }
    return _searchIcon;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(220, 220, 220);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = MKFont(15.f);
        _titleLabel.text = @"Edit Filter";
    }
    return _titleLabel;
}

- (UILabel *)searchLabel{
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textColor = DEFAULT_TEXT_COLOR;
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.font = MKFont(15.f);
    }
    return _searchLabel;
}

- (UIButton *)clearButton{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:LOADICON(@"MKBeaconXCustomUI", @"MKBXScanSearchButton", @"mk_bx_clearButtonIcon.png") forState:UIControlStateNormal];
        [_clearButton addTarget:self
                         action:@selector(clearButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

@end
