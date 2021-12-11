//
//  MKBXSlotConfigTriggerCell.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSlotConfigTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKPickerView.h"

#import "MKBXTriggerHumidityView.h"
#import "MKBXTriggerTapView.h"
#import "MKBXTriggerTemperatureView.h"

@implementation MKBXSlotConfigTriggerCellModel

- (instancetype)init {
    if (self = [super init]) {
        _deviceType = @"00";
    }
    return self;
}

@end

@interface MKBXSlotConfigTriggerCell ()<MKBXTriggerHumidityViewDelegate,
MKBXTriggerTemperatureViewDelegate,
MKBXTriggerTapViewDelegate>

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *triggerTypeLabel;

@property (nonatomic, strong)UILabel *triggerLabel;

@property (nonatomic, strong)MKBXTriggerTemperatureView *temperView;

@property (nonatomic, strong)MKBXTriggerTemperatureViewModel *temperViewModel;

@property (nonatomic, strong)MKBXTriggerHumidityView *humidityView;

@property (nonatomic, strong)MKBXTriggerHumidityViewModel *humidityViewModel;

@property (nonatomic, strong)MKBXTriggerTapView *doubleTapView;

@property (nonatomic, strong)MKBXTriggerTapViewModel *doubleTapViewModel;

@property (nonatomic, strong)MKBXTriggerTapView *tripleTapView;

@property (nonatomic, strong)MKBXTriggerTapViewModel *tripleTapViewModel;

@property (nonatomic, strong)MKBXTriggerTapView *movesView;

@property (nonatomic, strong)MKBXTriggerTapViewModel *movesViewModel;

@property (nonatomic, strong)MKBXTriggerTapView *lightDetectedView;

@property (nonatomic, strong)MKBXTriggerTapViewModel *lightDetectedViewModel;

@property (nonatomic, assign)NSInteger index;

@end

@implementation MKBXSlotConfigTriggerCell

+ (MKBXSlotConfigTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXSlotConfigTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXSlotConfigTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKBXSlotConfigTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXSlotConfigTriggerCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leftIcon];
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.switchButton];
        [self.contentView addSubview:self.triggerLabel];
        [self.contentView addSubview:self.triggerTypeLabel];
        [self.contentView addSubview:self.temperView];
        [self.contentView addSubview:self.humidityView];
        [self.contentView addSubview:self.doubleTapView];
        [self.contentView addSubview:self.tripleTapView];
        [self.contentView addSubview:self.movesView];
        [self.contentView addSubview:self.lightDetectedView];
        [self.triggerTypeLabel setHidden:YES];
        [self.triggerLabel setHidden:YES];
        [self.doubleTapView setHidden:YES];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:YES];
        [self.movesView setHidden:YES];
        [self.lightDetectedView setHidden:YES];
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
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
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
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(10.f);
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
    [self.lightDetectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.temperView);
    }];
}

#pragma mark - MKBXSlotConfigCellProtocol
- (NSDictionary *)mk_bx_slotConfigCell_params {
    if (!self.switchButton.selected) {
        //关闭触发
        return @{
            @"msg":@"",
            @"result":@{
                    @"dataType":mk_bx_slotConfig_advTriggerType,
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
    if ([self.dataModel.deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    if ([self.dataModel.deviceType isEqualToString:@"02"] || [self.dataModel.deviceType isEqualToString:@"03"]) {
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
    
    if ([self.dataModel.deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
    }
    if ([self.dataModel.deviceType isEqualToString:@"04"]) {
        //带光感
        if (self.index == 2) {
            //Ambient light detected
            return [self fetchTriggerTapViewData:self.lightDetectedView];
        }
    }
    if ([self.dataModel.deviceType isEqualToString:@"05"]) {
        //带LIS3DH和光感
        if (self.index == 2) {
            //Device moves
            return [self fetchTriggerTapViewData:self.movesView];
        }
        if (self.index == 3) {
            //Ambient light detected
            return [self fetchTriggerTapViewData:self.lightDetectedView];
        }
    }
    return @{
        @"msg":@"Params Error",
        @"result":@{},
    };
}

#pragma mark - MKBXTriggerHumidityViewDelegate
- (void)mk_bx_triggerHumidityStartStatusChanged:(BOOL)start {
    self.humidityViewModel.start = start;
}

- (void)mk_bx_triggerHumidityThresholdValueChanged:(float)sliderValue {
    self.humidityViewModel.sliderValue = sliderValue;
}

#pragma mark - MKBXTriggerTemperatureViewDelegate
- (void)mk_bx_triggerTemperatureStartStatusChanged:(BOOL)start {
    self.temperViewModel.start = start;
}

- (void)mk_bx_triggerTemperatureThresholdValueChanged:(float)sliderValue {
    self.temperViewModel.sliderValue = sliderValue;
}

#pragma mark - MKBXTriggerTapViewDelegate

/// 用户选择了触发方式
/// @param index 0:Start and keep advertising,1:Start advertising for,2:Stop advertising for
/// @param viewType 当前触发回调的view类型
- (void)mk_bx_triggerTapViewIndexChanged:(NSInteger)index viewType:(MKBXTriggerTapViewType)viewType {
    if (viewType == MKBXTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.index = index;
        return;
    }
    if (viewType == MKBXTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.index = index;
        return;
    }
    if (viewType == MKBXTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.index = index;
        return;
    }
    if (viewType == MKBXTriggerTapViewAmbientLightDetected) {
        //光感
        self.lightDetectedViewModel.index = index;
        return;
    }
}

/// index=1的时候，输入框的值
- (void)mk_bx_triggerTapViewStartValueChanged:(NSString *)startValue viewType:(MKBXTriggerTapViewType)viewType {
    if (viewType == MKBXTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.startValue = startValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.startValue = startValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.startValue = startValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewAmbientLightDetected) {
        //光感
        self.lightDetectedViewModel.startValue = startValue;
        return;
    }
}

/// index=2的时候，输入框的值
- (void)mk_bx_triggerTapViewStopValueChanged:(NSString *)stopValue viewType:(MKBXTriggerTapViewType)viewType {
    if (viewType == MKBXTriggerTapViewDouble) {
        //双击
        self.doubleTapViewModel.stopValue = stopValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewTriple) {
        //三击
        self.tripleTapViewModel.stopValue = stopValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewDeviceMoves) {
        //移动触发
        self.movesViewModel.stopValue = stopValue;
        return;
    }
    if (viewType == MKBXTriggerTapViewAmbientLightDetected) {
        //光感
        self.lightDetectedViewModel.stopValue = stopValue;
        return;
    }
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    [self updateSwitchButtonIcon];
    if ([self.delegate respondsToSelector:@selector(mk_bx_triggerSwitchStatusChanged:)]) {
        [self.delegate mk_bx_triggerSwitchStatusChanged:self.switchButton.selected];
    }
}

- (void)triggerLabelPressed {
    NSArray *dataList = [self triggerTypeList];
    NSInteger index = [self pickViewIndex:dataList];
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:dataList selectedRow:index block:^(NSInteger currentRow) {
        self.triggerLabel.text = dataList[currentRow];
        self.index = currentRow;
        [self setupUI];
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXSlotConfigTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXSlotConfigTriggerCellModel.class]) {
        return;
    }
    self.switchButton.selected = _dataModel.isOn;
    [self updateSwitchButtonIcon];
    [self updateIndexValue];
    [self reloadSubViews];
}

#pragma mark - private method
- (void)reloadSubViews {
    if (self.switchButton.selected) {
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
    [self.lightDetectedView setHidden:YES];
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
    if ([self.dataModel.deviceType isEqualToString:@"04"]) {
        //仅带光感,@"Press button twice",@"Press button three times",@"Ambient light detected"
        if ([self.dataModel.type isEqualToString:@"06"] && ValidDict(self.dataModel.conditions)) {
            //光感触发
            self.index = 2;
            return;
        }
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"05"]) {
        //带光感和LIS3DH3轴加速度计,@"Press button twice",@"Press button three times",@"Device moves",@"Ambient light detected"
        if ([self.dataModel.type isEqualToString:@"05"] && ValidDict(self.dataModel.conditions)) {
            //移动触发
            self.index = 2;
            return;
        }
        if ([self.dataModel.type isEqualToString:@"06"] && ValidDict(self.dataModel.conditions)) {
            //光感触发
            self.index = 3;
            return;
        }
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计,@"Press button twice",@"Press button three times",@"Device moves"
        if ([self.dataModel.type isEqualToString:@"05"] && ValidDict(self.dataModel.conditions)) {
            //移动
            self.index = 2;
            return;
        }
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"02"] || [self.dataModel.deviceType isEqualToString:@"03"]) {
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
        if ([self.dataModel.type isEqualToString:@"05"] && ValidDict(self.dataModel.conditions) && [self.dataModel.deviceType isEqualToString:@"03"]) {
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
        [self.lightDetectedView setHidden:YES];
        NSString *startValue = @"30";
        NSString *stopValue = @"30";
        NSInteger tempIndex = 0;
        if (ValidDict(self.dataModel.conditions)) {
            BOOL start = [self.dataModel.conditions[@"start"] boolValue];
            if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                if (start) {
                    tempIndex = 0;
                }
            }else {
                if (start) {
                    tempIndex = 1;
                    startValue = self.dataModel.conditions[@"time"];
                }else {
                    tempIndex = 2;
                    stopValue = self.dataModel.conditions[@"time"];
                }
            }
        }
        self.doubleTapViewModel.index = tempIndex;
        self.doubleTapViewModel.startValue = startValue;
        self.doubleTapViewModel.stopValue = stopValue;
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
        [self.lightDetectedView setHidden:YES];
        
        NSString *startValue = @"30";
        NSString *stopValue = @"30";
        NSInteger tempIndex = 0;
        
        if (ValidDict(self.dataModel.conditions)) {
            BOOL start = [self.dataModel.conditions[@"start"] boolValue];
            if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                if (start) {
                    tempIndex = 0;
                }
            }else {
                if (start) {
                    tempIndex = 1;
                    startValue = self.dataModel.conditions[@"time"];
                }else {
                    tempIndex = 2;
                    stopValue = self.dataModel.conditions[@"time"];
                }
            }
        }
        self.tripleTapViewModel.index = tempIndex;
        self.tripleTapViewModel.startValue = startValue;
        self.tripleTapViewModel.stopValue = stopValue;
        self.tripleTapView.dataModel = self.tripleTapViewModel;
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"00"]) {
        return;
    }
    
    if ([self.dataModel.deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        if (self.index == 2) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            [self.lightDetectedView setHidden:YES];
            
            NSString *startValue = @"30";
            NSString *stopValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 2;
                        stopValue = self.dataModel.conditions[@"time"];
                    }else {
                        tempIndex = 1;
                        startValue = self.dataModel.conditions[@"time"];
                    }
                }
            }
            self.movesViewModel.index = tempIndex;
            self.movesViewModel.startValue = startValue;
            self.movesViewModel.stopValue = stopValue;
            self.movesView.dataModel = self.movesViewModel;
            return;
        }
        return;
    }
    
    if ([self.dataModel.deviceType isEqualToString:@"02"] || [self.dataModel.deviceType isEqualToString:@"03"]) {
        //带SHT3X温湿度传感器或者同时带有LIS3DH及SHT3X传感器
        if (self.index == 2 || self.index == 3) {
            //3.Temperature above
            //4.Temperature below
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:NO];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            [self.lightDetectedView setHidden:YES];
            
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
            [self.lightDetectedView setHidden:YES];
            
            self.humidityViewModel.sliderValue = [self.dataModel.conditions[@"humidity"] floatValue];
            self.humidityViewModel.above = (self.index == 4);
            self.humidityViewModel.start = [self.dataModel.conditions[@"start"] boolValue];
            self.humidityView.dataModel = self.humidityViewModel;
            return;
        }
    }
    
    if ([self.dataModel.deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        if (self.index == 6) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            [self.lightDetectedView setHidden:YES];
            
            NSString *startValue = @"30";
            NSString *stopValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 2;
                        stopValue = self.dataModel.conditions[@"time"];
                    }else {
                        tempIndex = 1;
                        startValue = self.dataModel.conditions[@"time"];
                    }
                }
            }
            self.movesViewModel.index = tempIndex;
            self.movesViewModel.startValue = startValue;
            self.movesViewModel.stopValue = stopValue;
            self.movesView.dataModel = self.movesViewModel;
            return;
        }
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"04"]) {
        //带光感
        if (self.index == 2) {
            //Ambient light detected
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            [self.lightDetectedView setHidden:NO];
            
            NSString *startValue = @"30";
            NSString *stopValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 1;
                        startValue = self.dataModel.conditions[@"time"];
                    }else {
                        tempIndex = 2;
                        stopValue = self.dataModel.conditions[@"time"];
                    }
                }
            }
            self.lightDetectedViewModel.index = tempIndex;
            self.lightDetectedViewModel.startValue = startValue;
            self.lightDetectedViewModel.stopValue = stopValue;
            self.lightDetectedView.dataModel = self.lightDetectedViewModel;
            return;
        }
        return;
    }
    if ([self.dataModel.deviceType isEqualToString:@"05"]) {
        //光感和三轴加速度
        if (self.index == 2) {
            //Device moves
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:NO];
            [self.lightDetectedView setHidden:YES];
            
            NSString *startValue = @"30";
            NSString *stopValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 2;
                        stopValue = self.dataModel.conditions[@"time"];
                    }else {
                        tempIndex = 1;
                        startValue = self.dataModel.conditions[@"time"];
                    }
                }
            }
            self.movesViewModel.index = tempIndex;
            self.movesViewModel.startValue = startValue;
            self.movesViewModel.stopValue = stopValue;
            self.movesView.dataModel = self.movesViewModel;
            return;
        }
        if (self.index == 3) {
            //Ambient light detected
            [self.doubleTapView setHidden:YES];
            [self.temperView setHidden:YES];
            [self.humidityView setHidden:YES];
            [self.tripleTapView setHidden:YES];
            [self.movesView setHidden:YES];
            [self.lightDetectedView setHidden:NO];
            
            NSString *startValue = @"30";
            NSString *stopValue = @"30";
            NSInteger tempIndex = 0;
            
            if (ValidDict(self.dataModel.conditions)) {
                BOOL start = [self.dataModel.conditions[@"start"] boolValue];
                if ([self.dataModel.conditions[@"time"] integerValue] == 0) {
                    if (start) {
                        tempIndex = 0;
                    }
                }else {
                    if (start) {
                        tempIndex = 1;
                        startValue = self.dataModel.conditions[@"time"];
                    }else {
                        tempIndex = 2;
                        stopValue = self.dataModel.conditions[@"time"];
                    }
                }
            }
            self.lightDetectedViewModel.index = tempIndex;
            self.lightDetectedViewModel.startValue = startValue;
            self.lightDetectedViewModel.stopValue = stopValue;
            self.lightDetectedView.dataModel = self.lightDetectedViewModel;
            return;
        }
    }
}

- (void)updateSwitchButtonIcon {
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigTriggerCell", @"mk_bx_switchSelectedIcon.png") : LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigTriggerCell", @"mk_bx_switchUnselectedIcon.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
}

- (NSArray *)triggerTypeList {
    if ([self.dataModel.deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        return @[@"Press button twice",@"Press button three times",@"Device moves"];
    }
    if ([self.dataModel.deviceType isEqualToString:@"02"]) {
        //带SHT3X温湿度传感器
        return @[@"Press button twice",@"Press button three times",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below"];
    }
    if ([self.dataModel.deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        return @[@"Press button twice",@"Press button three times",@"Temperature above",@"Temperature below",@"Humidity above",@"Humidity below",@"Device moves"];
    }
    if ([self.dataModel.deviceType isEqualToString:@"04"]) {
        //带光感
        return @[@"Press button twice",@"Press button three times",@"Ambient light detected"];
    }
    if ([self.dataModel.deviceType isEqualToString:@"05"]) {
        //同时带有LIS3DH3轴加速度计和光感
        return @[@"Press button twice",@"Press button three times",@"Device moves",@"Ambient light detected"];
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
                     @"dataType":mk_bx_slotConfig_advTriggerType,
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
                     @"dataType":mk_bx_slotConfig_advTriggerType,
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

- (NSDictionary *)fetchTriggerTapViewData:(MKBXTriggerTapView *)tapView {
    MKBXTriggerTapViewModel *tempModel = self.doubleTapViewModel;
    NSString *triggerType = @"03";
    if (tapView == self.tripleTapView) {
        triggerType = @"04";
        tempModel = self.tripleTapViewModel;
    }else if (tapView == self.movesView) {
        triggerType = @"05";
        tempModel = self.movesViewModel;
    }else if (tapView == self.lightDetectedView) {
        triggerType = @"06";
        tempModel = self.lightDetectedViewModel;
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
    BOOL start = (tempModel.index != 2);
    if (tapView == self.movesView) {
        //
        start = (tempModel.index != 1);
    }
    return @{
             @"msg":@"",
             @"result":@{
                     @"dataType":mk_bx_slotConfig_advTriggerType,
                     @"params":@{
                             @"isOn":@(YES),
                             @"triggerParams":@{
                                     @"triggerType":triggerType,
                                     @"conditions":@{
                                             @"time":timeValue,
                                             @"start":@(start)
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
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigTriggerCell", @"mk_bx_slotParamsTriggerIcon.png");
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

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotConfigTriggerCell", @"mk_bx_switchUnselectedIcon.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)triggerTypeLabel {
    if (!_triggerTypeLabel) {
        _triggerTypeLabel = [[UILabel alloc] init];
        _triggerTypeLabel.textColor = DEFAULT_TEXT_COLOR;
        _triggerTypeLabel.textAlignment = NSTextAlignmentLeft;
        _triggerTypeLabel.font = MKFont(15.f);
        _triggerTypeLabel.text = @"Trigger type";
    }
    return _triggerTypeLabel;
}

- (UILabel *)triggerLabel {
    if (!_triggerLabel) {
        _triggerLabel = [[UILabel alloc] init];
        _triggerLabel.textColor = NAVBAR_COLOR_MACROS;
        _triggerLabel.textAlignment = NSTextAlignmentLeft;
        _triggerLabel.font = MKFont(13.f);
        _triggerLabel.text = @"Press button twice";
        [_triggerLabel addTapAction:self selector:@selector(triggerLabelPressed)];
    }
    return _triggerLabel;
}

- (MKBXTriggerTemperatureView *)temperView {
    if (!_temperView) {
        _temperView = [[MKBXTriggerTemperatureView alloc] init];
        _temperView.delegate = self;
    }
    return _temperView;
}

- (MKBXTriggerTemperatureViewModel *)temperViewModel {
    if (!_temperViewModel) {
        _temperViewModel = [[MKBXTriggerTemperatureViewModel alloc] init];
    }
    return _temperViewModel;
}

- (MKBXTriggerHumidityView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKBXTriggerHumidityView alloc] init];
        _humidityView.delegate = self;
    }
    return _humidityView;
}

- (MKBXTriggerHumidityViewModel *)humidityViewModel {
    if (!_humidityViewModel) {
        _humidityViewModel = [[MKBXTriggerHumidityViewModel alloc] init];
    }
    return _humidityViewModel;
}

- (MKBXTriggerTapView *)doubleTapView {
    if (!_doubleTapView) {
        _doubleTapView = [[MKBXTriggerTapView alloc] init];
        _doubleTapView.delegate = self;
    }
    return _doubleTapView;
}

- (MKBXTriggerTapViewModel *)doubleTapViewModel {
    if (!_doubleTapViewModel) {
        _doubleTapViewModel = [[MKBXTriggerTapViewModel alloc] init];
        _doubleTapViewModel.viewType = MKBXTriggerTapViewDouble;
    }
    return _doubleTapViewModel;
}

- (MKBXTriggerTapView *)tripleTapView {
    if (!_tripleTapView) {
        _tripleTapView = [[MKBXTriggerTapView alloc] init];
        _tripleTapView.delegate = self;
    }
    return _tripleTapView;
}

- (MKBXTriggerTapViewModel *)tripleTapViewModel {
    if (!_tripleTapViewModel) {
        _tripleTapViewModel = [[MKBXTriggerTapViewModel alloc] init];
        _tripleTapViewModel.viewType = MKBXTriggerTapViewTriple;
    }
    return _tripleTapViewModel;
}

- (MKBXTriggerTapView *)movesView {
    if (!_movesView) {
        _movesView = [[MKBXTriggerTapView alloc] init];
        _movesView.delegate = self;
    }
    return _movesView;
}

- (MKBXTriggerTapViewModel *)movesViewModel {
    if (!_movesViewModel) {
        _movesViewModel = [[MKBXTriggerTapViewModel alloc] init];
        _movesViewModel.viewType = MKBXTriggerTapViewDeviceMoves;
    }
    return _movesViewModel;
}

- (MKBXTriggerTapView *)lightDetectedView {
    if (!_lightDetectedView) {
        _lightDetectedView = [[MKBXTriggerTapView alloc] init];
        _lightDetectedView.delegate = self;
    }
    return _lightDetectedView;
}

- (MKBXTriggerTapViewModel *)lightDetectedViewModel {
    if (!_lightDetectedViewModel) {
        _lightDetectedViewModel = [[MKBXTriggerTapViewModel alloc] init];
        _lightDetectedViewModel.viewType = MKBXTriggerTapViewAmbientLightDetected;
    }
    return _lightDetectedViewModel;
}

@end
