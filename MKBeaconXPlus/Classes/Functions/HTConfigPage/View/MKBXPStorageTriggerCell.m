//
//  MKBXPStorageTriggerCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPStorageTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

#import "MKBXPStorageTriggerHTView.h"
#import "MKBXPStorageTriggerHumidityView.h"
#import "MKBXPStorageTriggerTempView.h"
#import "MKBXPStorageTriggerTimeView.h"

@implementation MKBXPStorageTriggerCellModel
@end

@interface MKBXPStorageTriggerCell ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXPStorageTriggerHTView *thView;

@property (nonatomic, strong)MKBXPStorageTriggerHumidityView *humidityView;

@property (nonatomic, strong)MKBXPStorageTriggerTempView *tempView;

@property (nonatomic, strong)MKBXPStorageTriggerTimeView *timeView;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKBXPStorageTriggerCell

+ (MKBXPStorageTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPStorageTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPStorageTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKBXPStorageTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPStorageTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBCOLOR(242, 242, 242);
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.pickerView];
        
        [self.backView addSubview:self.thView];
        [self.backView addSubview:self.humidityView];
        [self.backView addSubview:self.tempView];
        [self.backView addSubview:self.timeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-5.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.width.mas_equalTo(100.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pickerView.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
    [self.thView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.tempView);
    }];
    [self.humidityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.tempView);
    }];
    [self.timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.tempView);
    }];
}

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.f;
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
    if(self.index == row){
        /*选中后的row的字体颜色*/
        /*重写- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED; 方法加载 attributedText*/
        
        titleLabel.attributedText
        = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
        
    }else{
        
        titleLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return titleLabel;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataList[row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *typeName = self.dataList[row];
    NSAttributedString *attString = [MKCustomUIAdopter attributedString:@[typeName]
                                                                  fonts:@[MKFont(13.f)]
                                                                 colors:@[UIColorFromRGB(0x2F84D0)]];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.index = row;
    [self.pickerView reloadAllComponents];
    [self setupUI];
}

#pragma mark - setter
- (void)setDataModel:(MKBXPStorageTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.index = _dataModel.triggerType;
    [self.pickerView selectRow:self.index inComponent:0 animated:YES];
    [self setupUI];
}

#pragma mark - public method
- (NSDictionary *)getStorageTriggerConditions {
    if (self.index == 0) {
        //温度
        return @{
            @"triggerType":@(self.index),
            @"temperature":[self.tempView getCurrentTemperateure],
        };
    }
    if (self.index == 1) {
        //湿度
        return @{
            @"triggerType":@(self.index),
            @"humidity":[self.humidityView getCurrentHumidity],
        };
    }
    if (self.index == 2) {
        //温湿度
        return @{
            @"triggerType":@(self.index),
            @"temperature":[self.thView getCurrentTemperature],
            @"humidity":[self.thView getCurrentHumidity]
        };
    }
    if (self.index == 3) {
        //时间
        return @{
            @"triggerType":@(self.index),
            @"time":[self.timeView getCurrentTime],
        };
    }
    return @{
        @"triggerType":@(self.index),
    };
}

#pragma mark - private method
- (void)setupUI {
    self.tempView.hidden = (self.index != 0);
    self.humidityView.hidden = (self.index != 1);
    self.thView.hidden = (self.index != 2);
    self.timeView.hidden = (self.index != 3);
    if (self.index == 0) {
        //更新温度
        [self.tempView updateTemperateure:self.dataModel.temperature];
        return;
    }
    if (self.index == 1) {
        //更新湿度
        [self.humidityView updateHumidityValue:self.dataModel.humidity];
        return;
    }
    if (self.index == 2) {
        //更新温湿度
        [self.thView updateTemperature:self.dataModel.temperature humidity:self.dataModel.humidity];
        return;
    }
    if (self.index == 3) {
        //更新time
        [self.timeView updateTime:self.dataModel.storageTime];
        return;
    }
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Storage trigger";
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

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray arrayWithObjects:@"Temperature",@"Humidity",@"T&H",@"Time", nil];
    }
    return _dataList;
}

- (MKBXPStorageTriggerHTView *)thView {
    if (!_thView) {
        _thView = [[MKBXPStorageTriggerHTView alloc] init];
    }
    return _thView;
}

- (MKBXPStorageTriggerTempView *)tempView {
    if (!_tempView) {
        _tempView = [[MKBXPStorageTriggerTempView alloc] init];
    }
    return _tempView;
}

- (MKBXPStorageTriggerHumidityView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKBXPStorageTriggerHumidityView alloc] init];
    }
    return _humidityView;
}

- (MKBXPStorageTriggerTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[MKBXPStorageTriggerTimeView alloc] init];
    }
    return _timeView;
}

@end
