//
//  MKBXPSlotConfigTriggerCell.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPSlotConfigTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKPickerView.h"

#import "MKBXPConnectManager.h"

#import "MKBXPTriggerHumidityView.h"
#import "MKBXPTriggerTapView.h"
#import "MKBXPTriggerTemperatureView.h"

@implementation MKBXPSlotConfigTriggerCellModel
@end

@interface MKBXPSlotConfigTriggerCell ()<MKBXPTriggerHumidityViewDelegate,
MKBXPTriggerTemperatureViewDelegate,
MKBXPTriggerTapViewDelegate>

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UILabel *triggerTypeLabel;

@property (nonatomic, strong)UILabel *triggerLabel;

@property (nonatomic, strong)MKBXPTriggerTemperatureView *temperView;

@property (nonatomic, strong)MKBXPTriggerTemperatureViewModel *temperViewModel;

@property (nonatomic, strong)MKBXPTriggerHumidityView *humidityView;

@property (nonatomic, strong)MKBXPTriggerHumidityViewModel *humidityViewModel;

@property (nonatomic, strong)MKBXPTriggerTapView *doubleTapView;

@property (nonatomic, strong)MKBXPTriggerTapViewModel *doubleTapViewModel;

@property (nonatomic, strong)MKBXPTriggerTapView *tripleTapView;

@property (nonatomic, strong)MKBXPTriggerTapViewModel *tripleTapViewModel;

@property (nonatomic, strong)MKBXPTriggerTapView *movesView;

@property (nonatomic, strong)MKBXPTriggerTapViewModel *movesViewModel;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKBXPSlotConfigTriggerCell

+ (MKBXPSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXPSlotConfigTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXPSlotConfigTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKBXPSlotConfigTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXPSlotConfigTriggerCellIdenty"];
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

#pragma mark - MKBXPSlotConfigCellProtocol
- (NSDictionary *)bxp_slotConfigCell_paramValue {
    if (!self.switchView.isOn) {
        //关闭触发
        return @{
            @"msg":@"",
            @"result":@{
                    @"dataType":bxp_slotConfig_advTriggerType,
                    @"params":@{
                            @"isOn":@(NO),
                            @"triggerParams":@{},
                    }
            }
        };
    }
    //打开触发，需要根据不同的触发方式校验参数
    if (self.index == 0) {
        //Press button twice
        return [self fetchTriggerTapViewData:self.doubleTapView];
    }
    if (self.index == 1) {
        //Press button three times
        return [self fetchTriggerTapViewData:self.tripleTapView];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"] || [[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
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
    
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    return @{
        @"msg":@"Params Error",
        @"result":@{},
    };
}

#pragma mark - MKBXPTriggerHumidityViewDelegate
- (void)bxp_triggerHumidityStartStatusChanged:(BOOL)start {
    self.humidityViewModel.start = start;
}

- (void)bxp_triggerHumidityThresholdValueChanged:(float)sliderValue {
    self.humidityViewModel.sliderValue = sliderValue;
}

#pragma mark - MKBXPTriggerTemperatureViewDelegate
- (void)bxp_triggerTemperatureStartStatusChanged:(BOOL)start {
    self.temperViewModel.start = start;
}

- (void)bxp_triggerTemperatureThresholdValueChanged:(float)sliderValue {
    self.temperViewModel.sliderValue = sliderValue;
}

#pragma mark - MKBXPTriggerTapViewDelegate
/// 用户选择了触发方式
/// @param index 0:Always advertise,1:Start advertising for a while,2:Stop advertising for a while
/// @param viewType 当前触发回调的view类型
- (void)bxp_triggerTapViewIndexChanged:(NSInteger)index viewType:(MKBXPTriggerTapViewType)viewType {
    if (viewType == MKBXPTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.index = index;
        return;
    }
    if (viewType == MKBXPTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.index = index;
        return;
    }
    if (viewType == MKBXPTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.index = index;
        return;
    }
}

/// index=1的时候，输入框的值
- (void)bxp_triggerTapViewStartValueChanged:(NSString *)startValue viewType:(MKBXPTriggerTapViewType)viewType {
    if (viewType == MKBXPTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.startValue = startValue;
        return;
    }
    if (viewType == MKBXPTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.startValue = startValue;
        return;
    }
    if (viewType == MKBXPTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.startValue = startValue;
        return;
    }
}

/// index=2的时候，输入框的值
- (void)bxp_triggerTapViewStopValueChanged:(NSString *)stopValue viewType:(MKBXPTriggerTapViewType)viewType {
    if (viewType == MKBXPTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.stopValue = stopValue;
        return;
    }
    if (viewType == MKBXPTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.stopValue = stopValue;
        return;
    }
    if (viewType == MKBXPTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.stopValue = stopValue;
        return;
    }
}

#pragma mark - event method
- (void)switchViewValueChanged {
//    [self reloadSubViews];
    if ([self.delegate respondsToSelector:@selector(bxp_triggerSwitchStatusChanged:)]) {
        [self.delegate bxp_triggerSwitchStatusChanged:self.switchView.isOn];
    }
}

- (void)triggerLabelPressed {
    NSArray *dataList = [self triggerTypeList];
    NSInteger index = [self pickViewIndex:dataList];
    MKPickerView *pickView = [[MKPickerView alloc] init];
    pickView.dataList = dataList;
    [pickView showPickViewWithIndex:index block:^(NSInteger currentRow) {
        self.triggerLabel.text = dataList[currentRow];
        self.index = currentRow;
        [self setupUI];
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXPSlotConfigTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self.switchView setOn:_dataModel.isOn];
    [self updateIndexValue];
    [self reloadSubViews];
}

#pragma mark - private method
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
    if ([self.dataModel.type isEqualToString:@"00"]) {
        return;
    }
    if ([self.dataModel.type isEqualToString:@"03"] && ValidDict(self.dataModel.conditions)) {
        //双击
        self.index = 0;
        return;
    }
    if ([self.dataModel.type isEqualToString:@"04"] && ValidDict(self.dataModel.conditions)) {
        //三击
        self.index = 1;
        return;
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计,@"Press button twice",@"Press button three times",@"Device moves"
        if ([self.dataModel.type isEqualToString:@"05"] && ValidDict(self.dataModel.conditions)) {
            //移动
            self.index = 2;
            return;
        }
        return;
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"] || [[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器,@"Press button twice",@"Press button three times",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below"
        if ([self.dataModel.type isEqualToString:@"01"] && ValidDict(self.dataModel.conditions)) {
            //温度
            if ([self.dataModel.conditions[@"above"] boolValue]) {
                self.index = 2;
            }else {
                self.index = 3;
            }
        }
        if ([self.dataModel.type isEqualToString:@"02"] && ValidDict(self.dataModel.conditions)) {
            //湿度
            if ([self.dataModel.conditions[@"above"] boolValue]) {
                self.index = 4;
            }else {
                self.index = 5;
            }
        }
        if ([self.dataModel.type isEqualToString:@"05"] && ValidDict(self.dataModel.conditions) && [[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
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
        //Press button twice
        [self.doubleTapView setHidden:NO];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:YES];
        [self.movesView setHidden:YES];
        NSString *timeValue = @"30";
        NSInteger tempIndex = 0;
        if (ValidDict(self.dataModel.conditions)) {
            BOOL start = [self.dataModel.conditions[@"start"] boolValue];
            timeValue = self.dataModel.conditions[@"time"];
            if ([timeValue integerValue] == 0) {
                if (start) {
                    tempIndex = 0;
                }
            }else {
                if (start) {
                    tempIndex = 1;
                }else {
                    tempIndex = 2;
                }
            }
        }
        self.doubleTapViewModel.index = tempIndex;
        self.doubleTapViewModel.startValue = timeValue;
        self.doubleTapViewModel.stopValue = timeValue;
        self.doubleTapView.dataModel = self.doubleTapViewModel;
        return;
    }
    if (self.index == 1) {
        //Press button three times
        [self.doubleTapView setHidden:YES];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:NO];
        [self.movesView setHidden:YES];
        
        NSString *timeValue = @"30";
        NSInteger tempIndex = 0;
        
        if (ValidDict(self.dataModel.conditions)) {
            BOOL start = [self.dataModel.conditions[@"start"] boolValue];
            timeValue = self.dataModel.conditions[@"time"];
            if ([timeValue integerValue] == 0) {
                if (start) {
                    tempIndex = 0;
                }
            }else {
                if (start) {
                    tempIndex = 1;
                }else {
                    tempIndex = 2;
                }
            }
        }
        self.tripleTapViewModel.index = tempIndex;
        self.tripleTapViewModel.startValue = timeValue;
        self.tripleTapViewModel.stopValue = timeValue;
        self.tripleTapView.dataModel = self.tripleTapViewModel;
        return;
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"00"]) {
        return;
    }
    
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            
            NSString *timeValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                timeValue = self.dataModel.conditions[@"time"];
                if ([timeValue integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 1;
                    }else {
                        tempIndex = 2;
                    }
                }
            }
            self.movesViewModel.index = tempIndex;
            self.movesViewModel.startValue = timeValue;
            self.movesViewModel.stopValue = timeValue;
            self.movesView.dataModel = self.movesViewModel;
            return;
        }
        return;
    }
    
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"] || [[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器或者同时带有LIS3DH及SHT3X传感器
        if (self.index == 2 || self.index == 3) {
            //3.Temperature above
            //4.Temperature below
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:NO];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            
            self.temperViewModel.sliderValue = [self.dataModel.conditions[@"temperature"] floatValue];
            self.temperViewModel.above = (self.index == 2);
            self.temperViewModel.start = ([self.dataModel.conditions[@"start"] boolValue]);
            self.temperView.dataModel = self.temperViewModel;
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
            
            self.humidityViewModel.sliderValue = [self.dataModel.conditions[@"humidity"] floatValue];
            self.humidityViewModel.above = (self.index == 4);
            self.humidityViewModel.start = [self.dataModel.conditions[@"start"] boolValue];
            self.humidityView.dataModel = self.humidityViewModel;
            return;
        }
    }
    
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            
            NSString *timeValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                timeValue = self.dataModel.conditions[@"time"];
                if ([timeValue integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 1;
                    }else {
                        tempIndex = 2;
                    }
                }
            }
            self.movesViewModel.index = tempIndex;
            self.movesViewModel.startValue = timeValue;
            self.movesViewModel.stopValue = timeValue;
            self.movesView.dataModel = self.movesViewModel;
            return;
        }
        return;
    }
}

- (NSArray *)triggerTypeList {
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        return @[@"Press button twice",@"Press button three times",@"Device moves"];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"02"]) {
        //带SHT3X温湿度传感器
        return @[@"Press button twice",@"Press button three times",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below"];
    }
    if ([[MKBXPConnectManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        return @[@"Press button twice",@"Press button three times",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below",@"Device moves"];
    }
    //不带传感器
    return @[@"Press button twice",@"Press button three times"];
}

- (NSInteger)pickViewIndex:(NSArray *)dataList {
    for (NSInteger i = 0; i < dataList.count; i ++) {
        if ([self.triggerLabel.text isEqualToString:dataList[i]]) {
            return i;
        }
    }
    return 0;
}

- (NSDictionary *)fetchTemperViewData {
    return @{
             @"msg":@"",
             @"result":@{
                     @"dataType":bxp_slotConfig_advTriggerType,
                     @"params":@{
                             @"isOn":@(YES),
                             @"triggerParams":@{
                                     @"triggerType":@"01",
                                     @"conditions":@{
                                             @"above":@(self.temperViewModel.above),
                                             @"temperature":[NSString stringWithFormat:@"%.f",self.temperViewModel.sliderValue],
                                             @"start":@(self.temperViewModel.start)
                                     }
                             },
                     },
                     
             },
    };
}

- (NSDictionary *)fetchHumidityViewData {
    return @{
             @"msg":@"",
             @"result":@{
                     @"dataType":bxp_slotConfig_advTriggerType,
                     @"params":@{
                             @"isOn":@(YES),
                             @"triggerParams":@{
                                     @"triggerType":@"02",
                                     @"conditions":@{
                                             @"above":@(self.humidityViewModel.above),
                                             @"humidity":[NSString stringWithFormat:@"%.f",self.humidityViewModel.sliderValue],
                                             @"start":@(self.humidityViewModel.start)
                                     }
                             },
                     },
                     
             },
    };
}

- (NSDictionary *)fetchTriggerTapViewData:(MKBXPTriggerTapView *)tapView {
    MKBXPTriggerTapViewModel *tempModel = self.doubleTapViewModel;
    NSString *triggerType = @"03";
    if (tapView == self.tripleTapView) {
        triggerType = @"04";
        tempModel = self.tripleTapViewModel;
    }else if (tapView == self.movesView) {
        triggerType = @"05";
        tempModel = self.movesViewModel;
    }
    if ((tempModel.index == 1 && (!ValidStr(tempModel.startValue) || [tempModel.startValue integerValue] < 1 || [tempModel.startValue integerValue] > 65535))
        || (tempModel.index == 2 && (!ValidStr(tempModel.stopValue) || [tempModel.stopValue integerValue] < 1 || [tempModel.stopValue integerValue] > 65535))) {
        //start和stop
        return @{
            @"msg":@"Params Error",
            @"result":@{},
        };
    }
    NSString *timeValue = @"00";
    if (tempModel.index == 1) {
        timeValue = tempModel.startValue;
    }else if (tempModel.index == 2) {
        timeValue = tempModel.stopValue;
    }
    return @{
             @"msg":@"",
             @"result":@{
                     @"dataType":bxp_slotConfig_advTriggerType,
                     @"params":@{
                             @"isOn":@(YES),
                             @"triggerParams":@{
                                     @"triggerType":triggerType,
                                     @"conditions":@{
                                             @"time":timeValue,
                                             @"start":@(tempModel.index != 2)
                                     }
                             },
                     },
                     
             },
    };
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPSlotConfigTriggerCell", @"bxp_slot_params_triggerIcon.png");
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
        _triggerLabel.text = @"Press button twice";
        [_triggerLabel addTapAction:self selector:@selector(triggerLabelPressed)];
    }
    return _triggerLabel;
}

- (MKBXPTriggerTemperatureView *)temperView {
    if (!_temperView) {
        _temperView = [[MKBXPTriggerTemperatureView alloc] init];
        _temperView.delegate = self;
    }
    return _temperView;
}

- (MKBXPTriggerTemperatureViewModel *)temperViewModel {
    if (!_temperViewModel) {
        _temperViewModel = [[MKBXPTriggerTemperatureViewModel alloc] init];
    }
    return _temperViewModel;
}

- (MKBXPTriggerHumidityView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKBXPTriggerHumidityView alloc] init];
        _humidityView.delegate = self;
    }
    return _humidityView;
}

- (MKBXPTriggerHumidityViewModel *)humidityViewModel {
    if (!_humidityViewModel) {
        _humidityViewModel = [[MKBXPTriggerHumidityViewModel alloc] init];
    }
    return _humidityViewModel;
}

- (MKBXPTriggerTapView *)doubleTapView {
    if (!_doubleTapView) {
        _doubleTapView = [[MKBXPTriggerTapView alloc] init];
        _doubleTapView.delegate = self;
    }
    return _doubleTapView;
}

- (MKBXPTriggerTapViewModel *)doubleTapViewModel {
    if (!_doubleTapViewModel) {
        _doubleTapViewModel = [[MKBXPTriggerTapViewModel alloc] init];
        _doubleTapViewModel.viewType = MKBXPTriggerTapViewDouble;
    }
    return _doubleTapViewModel;
}

- (MKBXPTriggerTapView *)tripleTapView {
    if (!_tripleTapView) {
        _tripleTapView = [[MKBXPTriggerTapView alloc] init];
        _tripleTapView.delegate = self;
    }
    return _tripleTapView;
}

- (MKBXPTriggerTapViewModel *)tripleTapViewModel {
    if (!_tripleTapViewModel) {
        _tripleTapViewModel = [[MKBXPTriggerTapViewModel alloc] init];
        _tripleTapViewModel.viewType = MKBXPTriggerTapViewTriple;
    }
    return _tripleTapViewModel;
}

- (MKBXPTriggerTapView *)movesView {
    if (!_movesView) {
        _movesView = [[MKBXPTriggerTapView alloc] init];
        _movesView.delegate = self;
    }
    return _movesView;
}

- (MKBXPTriggerTapViewModel *)movesViewModel {
    if (!_movesViewModel) {
        _movesViewModel = [[MKBXPTriggerTapViewModel alloc] init];
        _movesViewModel.viewType = MKBXPTriggerTapViewDeviceMoves;
    }
    return _movesViewModel;
}

@end
