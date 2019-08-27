//
//  MKSlotTriggerCell.m
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotTriggerCell.h"

#import "MKTriggerTemperatureView.h"
#import "MKTriggerHumidityView.h"
#import "MKTriggerTapView.h"

#import "MKSlotConfigPickView.h"
#import "MKSlider.h"

@interface MKSlotTriggerCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UILabel *triggerTypeLabel;

@property (nonatomic, strong)UILabel *triggerLabel;

@property (nonatomic, strong)MKTriggerTemperatureView *temperView;

@property (nonatomic, strong)MKTriggerHumidityView *humidityView;

@property (nonatomic, strong)MKTriggerTapView *doubleTapView;

@property (nonatomic, strong)MKTriggerTapView *tripleTapView;

@property (nonatomic, strong)MKTriggerTapView *movesView;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKSlotTriggerCell

+ (MKSlotTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKSlotTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKSlotTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKSlotTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKSlotTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchView];
        [self.contentView addSubview:self.triggerLabel];
        [self.contentView addSubview:self.triggerTypeLabel];
        [self.contentView addSubview:self.temperView];
        [self.contentView addSubview:self.humidityView];
        [self.contentView addSubview:self.doubleTapView];
        [self.contentView addSubview:self.tripleTapView];
        [self.contentView addSubview:self.movesView];
        [self.triggerTypeLabel setHidden:YES];
        [self.triggerLabel setHidden:YES];
        [self.doubleTapView setHidden:YES];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:YES];
        [self.movesView setHidden:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.switchView.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(51.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.triggerTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.triggerLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.triggerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.triggerTypeLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.switchView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.temperView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.triggerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(230.f);
    }];
    [self.humidityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.temperView);
    }];
    [self.doubleTapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.temperView);
    }];
    [self.tripleTapView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.temperView);
    }];
    [self.movesView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.temperView);
    }];
}

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData{
    if (!self.switchView.isOn) {
        //关闭触发条件
        return @{
                 @"code":@"1",
                 @"result":@{
                         @"type":@"triggerConditions",
                         @"trigger":@(NO),
                         },
                 };
    }
    //打开触发情况下，需要校验参数
    if (self.index == 0) {
        //Button double tap
        return [self fetchTriggerTapViewData:self.doubleTapView];
    }
    if (self.index == 1) {
        //Button triple tap
        return [self fetchTriggerTapViewData:self.tripleTapView];
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"02"] || [[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器或者同时带有LIS3DH及SHT3X传感器
        if (self.index == 2 || self.index == 3) {
            //3.Temperature above
            //4.Temperature below
            return [self fetchTemperViewData];
        }
        if (self.index == 4 || self.index == 5) {
            //5.Humidity above
            //6.Humidity below
            return [self fetchHumidityViewData];
        }
    }
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    return [self errorDic:@"params error"];
}

#pragma mark - event method
- (void)triggerLabelPressed {
    NSArray *dataList = [self triggerTypeList];
    NSInteger index = [self pickViewIndex:dataList];
    MKSlotConfigPickView *pickView = [[MKSlotConfigPickView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:index block:^(NSInteger currentRow) {
        self.triggerLabel.text = dataList[currentRow];
        self.index = currentRow;
        [self setupUI];
    }];
}

- (void)switchViewValueChanged {
    [self reloadSubViews];
    if ([self.delegate respondsToSelector:@selector(triggerSwitchStatusChanged:)]) {
        [self.delegate triggerSwitchStatusChanged:self.switchView.isOn];
    }
}

#pragma mark -
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = nil;
    _dataDic = dataDic;
    if (!ValidDict(_dataDic)) {
        return;
    }
    [self.switchView setOn:[dataDic[@"trigger"] boolValue]];
    [self updateIndexValue];
    [self reloadSubViews];
}

#pragma mark - private method

- (NSDictionary *)fetchTemperViewData {
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"triggerConditions",
                     @"trigger":@(YES),
                     @"conditions":@{
                             @"triggerType":@"01",
                             @"above":@(self.temperView.above),
                             @"temperature":[NSString stringWithFormat:@"%.f",self.temperView.temperSlider.value],
                             @"start":@(self.temperView.start)
                             },
                     },
             };
}

- (NSDictionary *)fetchHumidityViewData {
    return @{
             @"code":@"1",
             @"result":@{
                     @"type":@"triggerConditions",
                     @"trigger":@(YES),
                     @"conditions":@{
                             @"triggerType":@"02",
                             @"above":@(self.humidityView.above),
                             @"humidity":[NSString stringWithFormat:@"%.f",self.humidityView.humiditySlider.value],
                             @"start":@(self.humidityView.start)
                             },
                     },
             };
}

- (NSDictionary *)fetchTriggerTapViewData:(MKTriggerTapView *)tapView {
    NSString *triggerType = @"03";
    if (tapView == self.tripleTapView) {
        triggerType = @"04";
    }else if (tapView == self.movesView) {
        triggerType = @"05";
    }
    if (tapView.index == 0) {
        return @{
                 @"code":@"1",
                 @"result":@{
                         @"type":@"triggerConditions",
                         @"trigger":@(YES),
                         @"conditions":@{
                                 @"triggerType":triggerType,
                                 @"time":@"00",
                                 @"start":@(YES)
                                 },
                         },
                 };
    }
    if (tapView.index == 1) {
        NSString *time = [tapView.startField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!ValidStr(time) || [time integerValue] < 1 || [time integerValue] > 65535) {
            return [self errorDic:@"params error"];
        }
        return @{
                 @"code":@"1",
                 @"result":@{
                         @"type":@"triggerConditions",
                         @"trigger":@(YES),
                         @"conditions":@{
                                 @"triggerType":triggerType,
                                 @"time":time,
                                 @"start":@(YES)
                                 },
                         },
                 };
    }
    if (tapView.index == 2) {
        NSString *time = [tapView.stopField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (!ValidStr(time) || [time integerValue] < 1 || [time integerValue] > 65535) {
            return [self errorDic:@"params error"];
        }
        return @{
                 @"code":@"1",
                 @"result":@{
                         @"type":@"triggerConditions",
                         @"trigger":@(YES),
                         @"conditions":@{
                                 @"triggerType":triggerType,
                                 @"time":time,
                                 @"start":@(NO)
                                 },
                         },
                 };
    }
    return [self errorDic:@"params error"];
}

- (NSDictionary *)errorDic:(NSString *)errorMsg{
    return @{
             @"code":@"2",
             @"msg":SafeStr(errorMsg),
             };
}

- (void)reloadSubViews {
    BOOL isOn = self.switchView.isOn;
    if (isOn) {
        //开关打开
        [self.triggerTypeLabel setHidden:NO];
        [self.triggerLabel setHidden:NO];
        [self setupUI];
        return;
    }
    //开关关闭
    [self.triggerTypeLabel setHidden:YES];
    [self.triggerLabel setHidden:YES];
    [self.doubleTapView setHidden:YES];
    [self.temperView setHidden:YES];
    [self.humidityView setHidden:YES];
    [self.tripleTapView setHidden:YES];
    [self.movesView setHidden:YES];
}

- (void)updateIndexValue {
    if ([self.dataDic[@"type"] isEqualToString:@"00"]) {
        return;
    }
    if ([self.dataDic[@"type"] isEqualToString:@"03"] && ValidDict(self.dataDic[@"conditions"])) {
        //双击
        self.index = 0;
        return;
    }
    if ([self.dataDic[@"type"] isEqualToString:@"04"] && ValidDict(self.dataDic[@"conditions"])) {
        //三击
        self.index = 1;
        return;
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计,@"Button double tap",@"Button triple tap",@"Device moves"
        if ([self.dataDic[@"type"] isEqualToString:@"05"] && ValidDict(self.dataDic[@"conditions"])) {
            //移动
            self.index = 2;
            return;
        }
        return;
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"02"] || [[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器,@"Button double tap",@"Button triple tap",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below"
        if ([self.dataDic[@"type"] isEqualToString:@"01"] && ValidDict(self.dataDic[@"conditions"])) {
            //温度
            NSDictionary *conditions = self.dataDic[@"conditions"];
            if ([conditions[@"above"] boolValue]) {
                self.index = 2;
            }else {
                self.index = 3;
            }
        }
        if ([self.dataDic[@"type"] isEqualToString:@"02"] && ValidDict(self.dataDic[@"conditions"])) {
            //温度
            NSDictionary *conditions = self.dataDic[@"conditions"];
            if ([conditions[@"above"] boolValue]) {
                self.index = 4;
            }else {
                self.index = 5;
            }
        }
        if ([self.dataDic[@"type"] isEqualToString:@"05"] && ValidDict(self.dataDic[@"conditions"]) && [[MKDataManager shared].deviceType isEqualToString:@"03"]) {
            //移动
            self.index = 6;
        }
        return;
    }
}

- (void)setupUI {
    NSArray *typeList = [self triggerTypeList];
    self.triggerLabel.text = typeList[self.index];
    if (self.index == 0) {
        //Button double tap
        [self.doubleTapView setHidden:NO];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:YES];
        [self.movesView setHidden:YES];
        if (ValidDict(self.dataDic[@"conditions"])) {
            BOOL start = [self.dataDic[@"conditions"][@"start"] boolValue];
            NSInteger index = 1;
            if ([self.dataDic[@"conditions"][@"time"] integerValue] == 0) {
                if (start) {
                    index = 0;
                }
            }else {
                if (start) {
                    index = 1;
                }else {
                    index = 2;
                }
            }
            [self.doubleTapView updateIndex:index timeValue:self.dataDic[@"conditions"][@"time"]];
            return;
        }
        [self.doubleTapView updateIndex:0 timeValue:@"30"];
        return;
    }
    if (self.index == 1) {
        //Button triple tap
        [self.doubleTapView setHidden:YES];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:NO];
        [self.movesView setHidden:YES];
        if (ValidDict(self.dataDic[@"conditions"])) {
            BOOL start = [self.dataDic[@"conditions"][@"start"] boolValue];
            NSInteger index = 1;
            if ([self.dataDic[@"conditions"][@"time"] integerValue] == 0) {
                if (start) {
                    index = 0;
                }
            }else {
                if (start) {
                    index = 1;
                }else {
                    index = 2;
                }
            }
            [self.tripleTapView updateIndex:index timeValue:self.dataDic[@"conditions"][@"time"]];
            return;
        }
        [self.tripleTapView updateIndex:0 timeValue:@"30"];
        return;
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"00"]) {
        return;
    }
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            if (ValidDict(self.dataDic[@"conditions"])) {
                BOOL start = [self.dataDic[@"conditions"][@"start"] boolValue];
                NSInteger index = 1;
                if ([self.dataDic[@"conditions"][@"time"] integerValue] == 0) {
                    if (start) {
                        index = 0;
                    }
                }else {
                    if (start) {
                        index = 1;
                    }else {
                        index = 2;
                    }
                }
                [self.movesView updateIndex:index timeValue:self.dataDic[@"conditions"][@"time"]];
                return;
            }
            [self.movesView updateIndex:0 timeValue:@"30"];
            return;
        }
        return;
    }
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"02"] || [[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器或者同时带有LIS3DH及SHT3X传感器
        if (self.index == 2 || self.index == 3) {
            //3.Temperature above
            //4.Temperature below
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:NO];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            [self.temperView updateAbove:(self.index == 2) start:[self.dataDic[@"conditions"][@"start"] boolValue]];
            [self.temperView.temperSlider setValue:[self.dataDic[@"conditions"][@"temperature"] floatValue]];
            self.temperView.sliderValueLabel.text = [NSString stringWithFormat:@"%.f℃",self.temperView.temperSlider.value];
            return;
        }
        if (self.index == 4 || self.index == 5) {
            //5.Humidity above
            //6.Humidity below
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:NO];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            [self.humidityView updateAbove:(self.index == 4) start:[self.dataDic[@"conditions"][@"start"] boolValue]];
            [self.humidityView.humiditySlider setValue:[self.dataDic[@"conditions"][@"humidity"] floatValue]];
            self.humidityView.sliderValueLabel.text = [NSString stringWithFormat:@"%.f%@",self.humidityView.humiditySlider.value,@"%"];
            return;
        }
    }
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            if (ValidDict(self.dataDic[@"conditions"])) {
                BOOL start = [self.dataDic[@"conditions"][@"start"] boolValue];
                NSInteger index = 1;
                if ([self.dataDic[@"conditions"][@"time"] integerValue] == 0) {
                    if (start) {
                        index = 0;
                    }
                }else {
                    if (start) {
                        index = 1;
                    }else {
                        index = 2;
                    }
                }
                [self.movesView updateIndex:index timeValue:self.dataDic[@"conditions"][@"time"]];
                return;
            }
            [self.movesView updateIndex:0 timeValue:@"30"];
            return;
        }
        return;
    }
}

- (NSArray *)triggerTypeList {
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        return @[@"Button double tap",@"Button triple tap",@"Device moves"];
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"02"]) {
        //带SHT3X温湿度传感器
        return @[@"Button double tap",@"Button triple tap",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below"];
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        return @[@"Button double tap",@"Button triple tap",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below",@"Device moves"];
    }
    //不带传感器
    return @[@"Button double tap",@"Button triple tap"];
}

- (NSInteger)pickViewIndex:(NSArray *)dataList {
    for (NSInteger i = 0; i < dataList.count; i ++) {
        if ([self.triggerLabel.text isEqualToString:dataList[i]]) {
            return i;
        }
    }
    return 0;
}

#pragma mark - setter & getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"slot_params_triggerIcon", @"png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"Trigger";
    }
    return _msgLabel;
}

- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self
                        action:@selector(switchViewValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UILabel *)triggerTypeLabel {
    if (!_triggerTypeLabel) {
        _triggerTypeLabel = [[UILabel alloc] init];
        _triggerTypeLabel.textColor = DEFAULT_TEXT_COLOR;
        _triggerTypeLabel.textAlignment = NSTextAlignmentLeft;
        _triggerTypeLabel.font = MKFont(15.f);
        _triggerTypeLabel.text = @"Trigger Type";
    }
    return _triggerTypeLabel;
}

- (UILabel *)triggerLabel {
    if (!_triggerLabel) {
        _triggerLabel = [[UILabel alloc] init];
        _triggerLabel.textColor = UIColorFromRGB(0x2F84D0);
        _triggerLabel.textAlignment = NSTextAlignmentLeft;
        _triggerLabel.font = MKFont(13.f);
        _triggerLabel.text = @"Button double tap";
        [_triggerLabel addTapAction:self selector:@selector(triggerLabelPressed)];
    }
    return _triggerLabel;
}

- (MKTriggerTemperatureView *)temperView {
    if (!_temperView) {
        _temperView = [[MKTriggerTemperatureView alloc] init];
    }
    return _temperView;
}

- (MKTriggerHumidityView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKTriggerHumidityView alloc] init];
    }
    return _humidityView;
}

- (MKTriggerTapView *)doubleTapView {
    if (!_doubleTapView) {
        _doubleTapView = [[MKTriggerTapView alloc] initWithType:MKTriggerTapViewDouble];
    }
    return _doubleTapView;
}

- (MKTriggerTapView *)tripleTapView {
    if (!_tripleTapView) {
        _tripleTapView = [[MKTriggerTapView alloc] initWithType:MKTriggerTapViewTriple];
    }
    return _tripleTapView;
}

- (MKTriggerTapView *)movesView {
    if (!_movesView) {
        _movesView = [[MKTriggerTapView alloc] initWithType:MKTriggerTapViewDeviceMoves];
    }
    return _movesView;
}

@end
