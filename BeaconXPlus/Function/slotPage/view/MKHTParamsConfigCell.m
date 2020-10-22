//
//  MKHTParamsConfigCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/31.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKHTParamsConfigCell.h"
#import "MKPickerView.h"

static CGFloat const pickViewRowHeight = 30.f;

@interface MKHTParamsConfigCell ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)UIView *temperView;

@property (nonatomic, strong)UILabel *temperLabel;

@property (nonatomic, strong)UILabel *temperValueLabel;

@property (nonatomic, strong)UIView *humiView;

@property (nonatomic, strong)UILabel *humiLabel;

@property (nonatomic, strong)UILabel *humiValueLabel;

@property (nonatomic, strong)UIView *timeView;

@property (nonatomic, strong)UITextField *timeTextField;

@property (nonatomic, strong)UILabel *timeUnitLabel;

@property (nonatomic, strong)UILabel *noteLabel;

/**
 当前选中的行数
 */
@property (nonatomic, assign)NSInteger index;

@end

@implementation MKHTParamsConfigCell

+ (MKHTParamsConfigCell *)initCellWithTableView:(UITableView *)tableView {
    MKHTParamsConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKHTParamsConfigCellIdenty"];
    if (!cell) {
        cell = [[MKHTParamsConfigCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKHTParamsConfigCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.pickerView];
        [self.contentView addSubview:self.temperView];
        [self.contentView addSubview:self.humiView];
        [self.contentView addSubview:self.timeView];
        [self.contentView addSubview:self.noteLabel];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupUI];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"HTStorage",
                     @"functionType":@(self.index),
                     @"temperature":SafeStr(self.temperValueLabel.text),
                     @"humidity":SafeStr(self.humiValueLabel.text),
                     @"storageTime":SafeStr(self.timeTextField.text)
                     },
             };
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return pickViewRowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataList.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    UILabel *titleLabel = (UILabel *)view;
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = DEFAULT_TEXT_COLOR;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = MKFont(12.f);
    }
    
    if(row == self.index){
        /*选中后的row的字体颜色*/
        /*重写- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; 方法加载 attributedText*/
        
        titleLabel.attributedText
        = [self pickerView:pickerView attributedTitleForRow:self.index forComponent:component];
        
    }else{
        
        titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return titleLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataList[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title = self.dataList[row];
    NSAttributedString *attString = [MKAttributedString getAttributedString:@[title]
                                                                      fonts:@[MKFont(13.f)]
                                                                     colors:@[UIColorFromRGB(0x2F84D0)]];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.index = row;
    [self.pickerView reloadAllComponents];
    //开始刷新UI
    [self setNeedsLayout];
    [self setupNoteMsg];
}

#pragma mark - event method
- (void)temperValueButtonPressed {
    NSArray *dataList = [self fetchTemperDataList];
    NSInteger row = [self fetchSlectedRow:dataList value:self.temperValueLabel.text];
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:row block:^(NSInteger currentRow) {
        self.temperValueLabel.text = dataList[currentRow];
        [self setupNoteMsg];
    }];
}

- (void)humiValueButtonPressed {
    NSArray *dataList = [self fetchHumidityDataList];
    NSInteger row = [self fetchSlectedRow:dataList value:self.humiValueLabel.text];
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:row block:^(NSInteger currentRow) {
        self.humiValueLabel.text = dataList[currentRow];
        [self setupNoteMsg];
    }];
}

- (void)timeTextFieldValueChanged {
    [self setupNoteMsg];
}

#pragma mark -
-(void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if (!ValidDict(_dataDic)) {
        return;
    }
    self.index = [dataDic[@"functionType"] integerValue];
    if (ValidStr(dataDic[@"temperature"])) {
        self.temperValueLabel.text = dataDic[@"temperature"];
    }
    if (ValidStr(dataDic[@"humidity"])) {
        self.humiValueLabel.text = dataDic[@"humidity"];
    }
    if (ValidStr(dataDic[@"storageTime"])) {
        self.timeTextField.text = dataDic[@"storageTime"];
    }
    [self setupUI];
    [self setupNoteMsg];
    [self.pickerView selectRow:self.index inComponent:0 animated:YES];
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

- (NSArray *)fetchTemperDataList {
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i <= 200; i ++) {
        NSString *value = [NSString stringWithFormat:@"%.1f",(i * 0.5)];
        [dataList addObject:value];
    }
    return dataList;
}

- (NSInteger)fetchSlectedRow:(NSArray *)dataList value:(NSString *)value {
    for (NSInteger i = 0; i < dataList.count; i ++) {
        if ([dataList[i] isEqualToString:value]) {
            return i;
        }
    }
    return 0;
}

- (NSArray *)fetchHumidityDataList {
    NSMutableArray *dataList = [NSMutableArray array];
    for (NSInteger i = 0; i <= 100; i ++) {
        NSString *value = [NSString stringWithFormat:@"%ld",(long)i];
        [dataList addObject:value];
    }
    return dataList;
}

- (void)setupNoteMsg {
    if (self.index == 0) {
        //温度
        if ([self.temperValueLabel.text isEqualToString:@"0.0"]) {
            self.noteLabel.text = @"The device records T&H data when the temperature changes arbitrarily.";
            return;
        }
        self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data when the temperature changes by more than %@ ℃.",self.temperValueLabel.text];
        return;
    }
    if (self.index == 1) {
        //湿度
        if ([self.humiValueLabel.text isEqualToString:@"0"]) {
            self.noteLabel.text = @"The device records T&H data when the humidity changes arbitrarily.";
            return;
        }
        self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data when the humidity changes by more than %@%@.",self.humiValueLabel.text,@"%"];
        return;
    }
    if (self.index == 2) {
        //温湿度
        CGFloat temperValue = [self.temperValueLabel.text floatValue];
        CGFloat humiValue = [self.humiValueLabel.text floatValue];
        if (temperValue == 0.0 && humiValue == 0.0) {
            //都任意变化
            self.noteLabel.text = @"The device records T&H data when the temperature or humidity changes arbitrarily.";
            return;
        }
        if (temperValue == 0 && humiValue > 0) {
            self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data when the temperature changes arbitrarily or humidity changes by more than %@%@.",self.humiValueLabel.text,@"%"];
            return;
        }
        if (temperValue > 0.0 && humiValue == 0) {
            self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data when the temperature changes by more than %@ ℃ or humidity changes arbitrarily.",self.temperValueLabel.text];
            return;
        }
        if (temperValue > 0.0 && humiValue > 0.0) {
            self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data when the temperature changes by more than %@ ℃ or humidity changes by more than %@%@.",self.temperValueLabel.text,self.humiValueLabel.text,@"%"];
        }
        return;
    }
    if (self.index == 3) {
        //时间
        self.noteLabel.text = [NSString stringWithFormat:@"The device records T&H data every %@ minute(s).",self.timeTextField.text];
        return;
    }
}

#pragma mark - setupUI

- (void)setupUI {
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-1.f);
        make.height.mas_equalTo(45.f);
    }];
    if (self.index == 0) {
        //温度
        [self.temperView setHidden:NO];
        [self.humiView setHidden:YES];
        [self.timeView setHidden:YES];
        [self.temperView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(30.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.pickerView.mas_top).mas_offset(10.f);
            make.height.mas_equalTo(30.f);
        }];
        return;
    }
    if (self.index == 1) {
        //湿度
        [self.temperView setHidden:YES];
        [self.humiView setHidden:NO];
        [self.timeView setHidden:YES];
        [self.humiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(30.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.pickerView.mas_top).mas_offset(10.f);
            make.height.mas_equalTo(30.f);
        }];
        return;
    }
    if (self.index == 2) {
        //温湿度
        [self.temperView setHidden:NO];
        [self.humiView setHidden:NO];
        [self.timeView setHidden:YES];
        [self.temperView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(30.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.pickerView.mas_top).mas_offset(10.f);
            make.height.mas_equalTo(30.f);
        }];
        [self.humiView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(30.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.temperView.mas_bottom).mas_offset(10.f);
            make.height.mas_equalTo(30.f);
        }];
        return;
    }
    if (self.index == 3) {
        //时间
        [self.temperView setHidden:YES];
        [self.humiView setHidden:YES];
        [self.timeView setHidden:NO];
        [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(30.f);
            make.right.mas_equalTo(-15.f);
            make.top.mas_equalTo(self.pickerView.mas_top).mas_offset(10.f);
            make.height.mas_equalTo(30.f);
        }];
        return;
    }
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"slot_htParamsConfig_saveIcon", @"png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [self createMsgLabel:MKFont(15.f)];
        _msgLabel.text = @"T&H Storage Condition";
    }
    return _msgLabel;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        // 显示选中框,iOS10以后分割线默认的是透明的，并且默认是显示的，设置该属性没有意义了，
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        _pickerView.layer.masksToBounds = YES;
        _pickerView.layer.borderColor = UIColorFromRGB(0x2F84D0).CGColor;
        _pickerView.layer.borderWidth = 0.5f;
        _pickerView.layer.cornerRadius = 4.f;
    }
    return _pickerView;
}

- (UIView *)temperView {
    if (!_temperView) {
        _temperView = [[UIView alloc] init];
        
        [_temperView addSubview:self.temperLabel];
        [_temperView addSubview:self.temperValueLabel];
        UILabel *unitLabel = [self createMsgLabel:MKFont(10.f)];
        unitLabel.text = @"℃";
        [_temperView addSubview:unitLabel];
        [self.temperLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(80.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.temperValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.temperLabel.mas_right).mas_offset(2.f);
            make.width.mas_equalTo(35.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.temperValueLabel.mas_right).mas_offset(2.f);
            make.width.mas_equalTo(15.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _temperView;
}

- (UILabel *)temperLabel {
    if (!_temperLabel) {
        _temperLabel = [self createMsgLabel:MKFont(13.f)];
        _temperLabel.text = @"Temperature";
    }
    return _temperLabel;
}

- (UILabel *)temperValueLabel {
    if (!_temperValueLabel) {
        _temperValueLabel = [[UILabel alloc] init];
        _temperValueLabel.textAlignment = NSTextAlignmentCenter;
        _temperValueLabel.textColor = UIColorFromRGB(0x2F84D0);
        _temperValueLabel.font = MKFont(13.f);
        _temperValueLabel.text = @"0.0";
        [_temperValueLabel addTapAction:self selector:@selector(temperValueButtonPressed)];
    }
    return _temperValueLabel;
}

- (UIView *)humiView {
    if (!_humiView) {
        _humiView = [[UIView alloc] init];
        
        [_humiView addSubview:self.humiLabel];
        [_humiView addSubview:self.humiValueLabel];
        UILabel *unitLabel = [self createMsgLabel:MKFont(10.f)];
        unitLabel.text = @"%";
        [_humiView addSubview:unitLabel];
        [self.humiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(80.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.humiValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.humiLabel.mas_right).mas_offset(2.f);
            make.width.mas_equalTo(35.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.humiValueLabel.mas_right).mas_offset(2.f);
            make.width.mas_equalTo(15.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _humiView;
}

- (UILabel *)humiLabel {
    if (!_humiLabel) {
        _humiLabel = [self createMsgLabel:MKFont(13.f)];
        _humiLabel.text = @"Humidity";
    }
    return _humiLabel;
}

- (UILabel *)humiValueLabel {
    if (!_humiValueLabel) {
        _humiValueLabel = [[UILabel alloc] init];
        _humiValueLabel.textAlignment = NSTextAlignmentCenter;
        _humiValueLabel.textColor = UIColorFromRGB(0x2F84D0);
        _humiValueLabel.font = MKFont(13.f);
        _humiValueLabel.text = @"0";
        [_humiValueLabel addTapAction:self selector:@selector(humiValueButtonPressed)];
    }
    return _humiValueLabel;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        
        [_timeView addSubview:self.timeTextField];
        [_timeView addSubview:self.timeUnitLabel];
        [self.timeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(50.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.timeUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeTextField.mas_right).mas_offset(2.f);
            make.width.mas_equalTo(50.f);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _timeView;
}

- (UITextField *)timeTextField {
    if (!_timeTextField) {
        _timeTextField = [[UITextField alloc] initWithTextFieldType:realNumberOnly];
        _timeTextField.textColor = UIColorFromRGB(0x2F84D0);
        _timeTextField.textAlignment = NSTextAlignmentCenter;
        _timeTextField.font = MKFont(12.f);
        _timeTextField.borderStyle = UITextBorderStyleNone;
        _timeTextField.text = @"1";
        [_timeTextField addTarget:self
                           action:@selector(timeTextFieldValueChanged)
                 forControlEvents:UIControlEventEditingChanged];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0x2F84D0);
        [_timeTextField addSubview:lineView];
        [lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _timeTextField;
}

- (UILabel *)timeUnitLabel {
    if (!_timeUnitLabel) {
        _timeUnitLabel = [self createMsgLabel:MKFont(10.f)];
        _timeUnitLabel.text = @"min(s)";
    }
    return _timeUnitLabel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(10.f);
        _noteLabel.numberOfLines = 0;
        _noteLabel.text = @"he device records T&H data when the humidity changes by more than 5%.";
    }
    return _noteLabel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"Temperature",@"Humidity",@"T&H",@"Time", nil];
    }
    return _dataList;
}

- (UILabel *)createMsgLabel:(UIFont *)font {
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.textColor = DEFAULT_TEXT_COLOR;
    tempLabel.textAlignment = NSTextAlignmentLeft;
    tempLabel.font = font;
    return tempLabel;
}

@end
