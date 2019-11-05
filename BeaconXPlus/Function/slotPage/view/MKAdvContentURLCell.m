//
//  MKAdvContentURLCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvContentURLCell.h"

static NSString *const MKAdvContentURLCellIdenty = @"MKAdvContentURLCellIdenty";
static CGFloat const labelHeight = 30.f;

@interface MKAdvContentURLCell()

@property (nonatomic, strong)UILabel *urlLabel;
@property (nonatomic, strong)UILabel *typeLabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)NSMutableArray *dataList;

@end

@implementation MKAdvContentURLCell

+ (MKAdvContentURLCell *)initCellWithTableView:(UITableView *)tableView{
    MKAdvContentURLCell *cell = [tableView dequeueReusableCellWithIdentifier:MKAdvContentURLCellIdenty];
    if (!cell) {
        cell = [[MKAdvContentURLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKAdvContentURLCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.urlLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minOffset_X);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.minTopOffset);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.urlLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.urlLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-self.minOffset_X);
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.height.mas_equalTo(labelHeight);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    NSString *headerText = [self.typeLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlContent = self.textField.text;
    if (!ValidStr(headerText) || !ValidStr(urlContent)) {
        return [self errorDic:@"To set up the url can't be empty"];
    }
    NSString *text = [headerText stringByAppendingString:urlContent];
    //需要对,@"http://"、@"https://这两种情况单独处理
    BOOL legal = [text regularExpressions:isUrl];
    if (legal) {
        return [self getResultDicLegitimateUrl:headerText urlContent:urlContent];
    }
    //如果url不合法，则最大输入长度是17个字节
    return [self suffixIllegal:headerText urlContent:urlContent];
}

#pragma mark - Private method

- (NSDictionary *)getResultDicLegitimateUrl:(NSString *)header
                                 urlContent:(NSString *)urlContent{
    NSArray *urlList = [urlContent componentsSeparatedByString:@"."];
    if (!ValidArray(urlList)) {
        return [self errorDic:@"Please enter the correct url"];
    }
    NSString *expansion = [self getExpansionHex:[@"." stringByAppendingString:[urlList lastObject]]];
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
        return [self errorDic:@"Parse the data error"];
    }
    content = [content substringFromIndex:1];
    if (content.length > 16) {
        return [self errorDic:@"Enter the url of the length is too long"];
    }
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"URL",
                     @"urlHeader":header,
                     @"urlExpansion":[@"." stringByAppendingString:[urlList lastObject]],
                     @"urlContent":content,
                     },
             };
}

- (NSDictionary *)suffixIllegal:(NSString *)header urlContent:(NSString *)urlContent{
    //如果url不合法，则最大输入长度是17个字节
    if (urlContent.length < 2) {
        return [self errorDic:@"The url a minimum length of 2"];
    }
    if (urlContent.length > 17) {
        return [self errorDic:@"The url a maximum length of 17"];
    }
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"URL",
                     @"urlHeader":header,
                     @"urlContent":urlContent,
                     },
             };
}

/**
 根据后缀名返回写入数据时候的hex
 
 @param expansion 后缀名
 @return hex
 */
- (NSString *)getExpansionHex:(NSString *)expansion{
    if (!ValidStr(expansion)) {
        return nil;
    }
    if ([expansion isEqualToString:@".com/"]) {
        return @"00";
    }else if ([expansion isEqualToString:@".org/"]){
        return @"01";
    }else if ([expansion isEqualToString:@".edu/"]){
        return @"02";
    }else if ([expansion isEqualToString:@".net/"]){
        return @"03";
    }else if ([expansion isEqualToString:@".info/"]){
        return @"04";
    }else if ([expansion isEqualToString:@".biz/"]){
        return @"05";
    }else if ([expansion isEqualToString:@".gov/"]){
        return @"06";
    }else if ([expansion isEqualToString:@".com"]){
        return @"07";
    }else if ([expansion isEqualToString:@".org"]){
        return @"08";
    }else if ([expansion isEqualToString:@".edu"]){
        return @"09";
    }else if ([expansion isEqualToString:@".net"]){
        return @"0a";
    }else if ([expansion isEqualToString:@".info"]){
        return @"0b";
    }else if ([expansion isEqualToString:@".biz"]){
        return @"0c";
    }else if ([expansion isEqualToString:@".gov"]){
        return @"0d";
    }else{
        return nil;
    }
}

- (NSString *)getUrlscheme:(char)hexChar
{
    switch (hexChar) {
        case 0x00:
            return @"http://www.";
        case 0x01:
            return @"https://www.";
        case 0x02:
            return @"http://";
        case 0x03:
            return @"https://";
        default:
            return nil;
    }
}

- (NSString *)getEncodedString:(char)hexChar
{
    switch (hexChar) {
            
        case 0x00:
            return @".com/";
        case 0x01:
            return @".org/";
        case 0x02:
            return @".edu/";
        case 0x03:
            return @".net/";
        case 0x04:
            return @".info/";
        case 0x05:
            return @".biz/";
        case 0x06:
            return @".gov/";
        case 0x07:
            return @".com";
        case 0x08:
            return @".org";
        case 0x09:
            return @".edu";
        case 0x0a:
            return @".net";
        case 0x0b:
            return @".info";
        case 0x0c:
            return @".biz";
        case 0x0d:
            return @".gov";
        default:
            return [NSString stringWithFormat:@"%c", hexChar];
    }
}

/**
 生成错误的dic
 
 @param errorMsg 错误内容
 @return dic
 */
- (NSDictionary *)errorDic:(NSString *)errorMsg{
    return @{
             @"code":@"2",
             @"msg":SafeStr(errorMsg),
             };
}

- (void)typeLabelPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"url"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancle"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:self.dataList[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           [self urlTypeSelected:i];
                                                       }];
        [alert addAction:action];
    }
    [kAppRootController presentViewController:alert animated:YES completion:nil];
}

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
        url = [url stringByAppendingString:[self getEncodedString:*(data + i + 3)]];
    }
    self.typeLabel.text = [self getUrlscheme:*(data+2)];
    self.textField.text = url;
}

- (void)urlTypeSelected:(NSInteger )row{
    [self.typeLabel setText:self.dataList[row]];
}

- (UITextField *)createNewTextField{
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = MKFont(15.f);
    textField.keyboardType = UIKeyboardTypeASCIICapable;
//    [textField addTarget:self
//                  action:@selector(deviceNameChangedMethod)
//        forControlEvents:UIControlEventEditingChanged];
    
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
    textField.layer.cornerRadius = 3.f;
    
    return textField;
}

#pragma mark - Public method
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = nil;
    _dataDic = dataDic;
    if (!ValidDict(_dataDic)) {
        return;
    }
    NSData *advData = dataDic[@"advData"];
    [self loadUrlInfo:advData];
}

#pragma mark - setter & getter
- (UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.textAlignment = NSTextAlignmentRight;
        _urlLabel.textColor = RGBCOLOR(111, 111, 111);
        _urlLabel.font = MKFont(15.f);
        _urlLabel.text = @"URL";
    }
    return _urlLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = RGBCOLOR(111, 111, 111);
        _typeLabel.font = MKFont(13.f);
        _typeLabel.text = @"http://www.";
        
        _typeLabel.layer.masksToBounds = YES;
        _typeLabel.layer.borderWidth = 0.5f;
        _typeLabel.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _typeLabel.layer.cornerRadius = 2.f;
        
        [_typeLabel addTapAction:self selector:@selector(typeLabelPressed)];
    }
    return _typeLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [self createNewTextField];
        _textField.attributedPlaceholder = [MKAttributedString getAttributedString:@[@"mokosmart.com/"] fonts:@[MKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
    }
    return _textField;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"http://www.",@"https://www.",@"http://",@"https://", nil];
    }
    return _dataList;
}


@end
