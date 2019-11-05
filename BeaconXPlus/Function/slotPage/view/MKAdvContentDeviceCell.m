//
//  MKAdvContentDeviceCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/29.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAdvContentDeviceCell.h"

@interface MKAdvContentDeviceCell ()

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)UITextField *textField;

@end

@implementation MKAdvContentDeviceCell

+ (MKAdvContentDeviceCell *)initCellWithTable:(UITableView *)tableView {
    MKAdvContentDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKAdvContentDeviceCellIdenty"];
    if (!cell) {
        cell = [[MKAdvContentDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKAdvContentDeviceCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.deviceNameLabel];
        [self.contentView addSubview:self.textField];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(95.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.minTopOffset);
        make.height.mas_equalTo(30.f);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    NSString *deviceName = self.textField.text;
    if (!ValidStr(deviceName) || deviceName.length > 20) {
        return [self errorDic:@"The input parameter is illegal"];
    }
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"deviceInfo",
                     @"deviceName":deviceName,
                     },
             };
}

#pragma mark - event method
- (void)deviceNameChangedMethod {
    NSString *deviceName = self.textField.text;
    if (deviceName.length > 20) {
        deviceName = [deviceName substringWithRange:NSMakeRange(0, 20)];
    }
    self.textField.text = deviceName;
}

#pragma mark -
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = nil;
    _dataDic = dataDic;
    if (!ValidDict(dataDic)) {
        return;
    }
    if (ValidStr(dataDic[@"peripheralName"])) {
        self.textField.text = dataDic[@"peripheralName"];
    }else {
        self.textField.text = @"";
    }
}

#pragma mark - private method

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

#pragma mark - setter & getter
- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(15.f);
        _deviceNameLabel.text = @"Device Name";
    }
    return _deviceNameLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = DEFAULT_TEXT_COLOR;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = MKFont(15.f);
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        [_textField addTarget:self
                       action:@selector(deviceNameChangedMethod)
             forControlEvents:UIControlEventEditingChanged];
        
        _textField.layer.masksToBounds = YES;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _textField.layer.cornerRadius = 3.f;
        _textField.attributedPlaceholder = [MKAttributedString getAttributedString:@[@"No more than 20 characters"] fonts:@[MKFont(15.f)] colors:@[RGBCOLOR(222, 222, 222)]];
    }
    return _textField;
}

@end
