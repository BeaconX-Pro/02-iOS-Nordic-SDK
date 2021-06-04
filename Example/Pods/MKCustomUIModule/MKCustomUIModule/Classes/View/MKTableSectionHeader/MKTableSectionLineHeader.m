//
//  MKTableSectionLineHeader.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/4/2.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKTableSectionLineHeader.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKTableSectionLineHeaderModel
@end

@interface MKTableSectionLineHeader ()

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKTableSectionLineHeader

+ (MKTableSectionLineHeader *)initHeaderViewWithTableView:(UITableView *)tableView {
    MKTableSectionLineHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MKTableSectionLineHeaderIdenty"];
    if (!headerView) {
        headerView = [[MKTableSectionLineHeader alloc] initWithReuseIdentifier:@"MKTableSectionLineHeaderIdenty"];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize msgSize = [NSString sizeWithText:SafeStr(self.msgLabel.text)
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(self.contentView.frame.size.width - 30.f, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(msgSize.height);
    }];
}

#pragma mark - setter
- (void)setHeaderModel:(MKTableSectionLineHeaderModel *)headerModel {
    _headerModel = nil;
    _headerModel = headerModel;
    if (!_headerModel || ![_headerModel isKindOfClass:MKTableSectionLineHeaderModel.class]) {
        return;
    }
    self.contentView.backgroundColor = (_headerModel.contentColor ? _headerModel.contentColor : RGBCOLOR(242, 242, 242));
    if (ValidStr(_headerModel.text)) {
        self.msgLabel.text = SafeStr(_headerModel.text);
        self.msgLabel.textColor = (_headerModel.msgTextColor ? _headerModel.msgTextColor : DEFAULT_TEXT_COLOR);
        self.msgLabel.font = (_headerModel.msgTextFont ? _headerModel.msgTextFont : MKFont(15.f));
        [self setNeedsLayout];
    }else {
        self.msgLabel.text = @"";
    }
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

@end
