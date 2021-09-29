//
//  MKBXSlotConfigURLCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSlotConfigURLCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKPickerView.h"

#import "MKBXSlotDataAdopter.h"

@implementation MKBXSlotConfigURLCellModel
@end

@interface MKBXSlotConfigURLCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *urlTypeLabel;

@property (nonatomic, strong)MKTextField *textField;

@end

@implementation MKBXSlotConfigURLCell

+ (MKBXSlotConfigURLCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSlotConfigURLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSlotConfigURLCellIdenty"];
    if (!cell) {
        cell = [[MKBXSlotConfigURLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSlotConfigURLCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.urlTypeLabel];
        [self.backView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.urlTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.urlTypeLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - MKBXSlotConfigCellProtocol
- (NSDictionary *)mk_bx_slotConfigCell_params {
    if (!ValidStr(self.textField.text)) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    NSString *url = [self.urlTypeLabel.text stringByAppendingString:self.textField.text];
    //需要对,@"http://"、@"https://这两种情况单独处理
    BOOL legal = [url regularExpressions:isUrl];
    if (legal) {
        return [self getLegitimateUrl:self.urlTypeLabel.text urlContent:self.textField.text];
    }
    return [self suffixIllegal:self.urlTypeLabel.text urlContent:self.textField.text];
}

#pragma mark - event method
- (void)urlTypeLabelPressed {
    NSInteger index = 0;
    NSArray *headerList = @[@"http://www.",@"https://www.",@"http://",@"https://"];
    
    for (NSInteger i = 0; i < headerList.count; i ++) {
        if ([self.urlTypeLabel.text isEqualToString:headerList[i]]) {
            index = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:headerList selectedRow:index block:^(NSInteger currentRow) {
        self.urlTypeLabel.text = headerList[currentRow];
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXSlotConfigURLCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSlotConfigURLCellModel.class]) {
        return;
    }
    [self loadUrlInfo:_dataModel.advData];
}

#pragma mark - private method
- (void)loadUrlInfo:(NSData *)advData{
    if (!ValidData(advData) || advData.length < 3) {
        return;
    }
    const unsigned char *cData = [advData bytes];
    unsigned char *data;
    
    // Malloc advertise data for char*
    data = malloc(sizeof(unsigned char) * advData.length);
    if (!data) {
        return;
    }
    
    for (int i = 0; i < advData.length; i++) {
        data[i] = *cData++;
    }
    NSString *url = @"";
    for (int i = 0; i < advData.length - 3; i++) {
        url = [url stringByAppendingString:[MKBXSlotDataAdopter getEncodedString:*(data + i + 3)]];
    }
    self.urlTypeLabel.text = [MKBXSlotDataAdopter getUrlscheme:*(data+2)];
    self.textField.text = url;
}

#pragma mark - Private method

- (NSDictionary *)getLegitimateUrl:(NSString *)header urlContent:(NSString *)urlContent{
    NSArray *urlList = [urlContent componentsSeparatedByString:@"."];
    if (!ValidArray(urlList)) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    NSString *expansion = [MKBXSlotDataAdopter getExpansionHex:[@"." stringByAppendingString:[urlList lastObject]]];
    if (!ValidStr(expansion)) {
        //后缀名不合法
        return [self suffixIllegal:header urlContent:urlContent];
    }
    //如果后缀名合法，则校验中间的字符，最大长度是16
    NSString *content = @"";
    for (NSInteger i = 0; i < urlList.count - 1; i ++) {
        content = [content stringByAppendingString:[NSString stringWithFormat:@".%@",urlList[i]]];
    }
    if (!ValidStr(content)) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    content = [content substringFromIndex:1];
    if (content.length > 16) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    
    return @{
        @"msg":@"",
        @"result":@{
                @"dataType":mk_bx_slotConfig_advContentType,
                @"params":@{
                        @"frameType":mk_bx_slotConfig_urlData,
                        @"urlHeader":header,
                        @"urlExpansion":[@"." stringByAppendingString:[urlList lastObject]],
                        @"urlContent":content,
                }
        }
    };
}

- (NSDictionary *)suffixIllegal:(NSString *)header urlContent:(NSString *)urlContent{
    //如果url不合法，则最大输入长度是17个字节
    if (urlContent.length < 2) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    if (urlContent.length > 17) {
        return @{
            @"msg":@"Data format incorrect!",
            @"result":@{},
        };
    }
    return @{
        @"msg":@"",
        @"result":@{
                @"dataType":mk_bx_slotConfig_advContentType,
                @"params":@{
                        @"frameType":mk_bx_slotConfig_urlData,
                        @"urlHeader":header,
                        @"urlContent":urlContent,
                        @"urlExpansion":@""
                }
        }
    };
}

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigURLCell", @"mk_bx_slotAdvContent.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Adv content";
    }
    return _typeLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"URL";
    }
    return _msgLabel;
}

- (UILabel *)urlTypeLabel{
    if (!_urlTypeLabel) {
        _urlTypeLabel = [[UILabel alloc] init];
        _urlTypeLabel.textAlignment = NSTextAlignmentLeft;
        _urlTypeLabel.textColor = RGBCOLOR(111, 111, 111);
        _urlTypeLabel.font = MKFont(12.f);
        _urlTypeLabel.text = @"http://www.";
        
        _urlTypeLabel.layer.masksToBounds = YES;
        _urlTypeLabel.layer.borderWidth = 0.5f;
        _urlTypeLabel.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _urlTypeLabel.layer.cornerRadius = 2.f;
        
        [_urlTypeLabel addTapAction:self selector:@selector(urlTypeLabelPressed)];
    }
    return _urlTypeLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [[MKTextField alloc] initWithTextFieldType:mk_normal];
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = MKFont(15.f);
        _textField.placeholder = @"mokoblue.com/";
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _textField.layer.cornerRadius = 3.f;
    }
    return _textField;
}

@end
