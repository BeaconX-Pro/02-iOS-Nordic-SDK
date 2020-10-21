//
//  MKBaseCell.m
//  mokoLibrary
//
//  Created by aa on 2020/10/7.
//

#import "MKBaseCell.h"
#import "Masonry.h"
#import "MKMacroDefines.h"

@interface MKBaseCell ()

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark - getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

@end
