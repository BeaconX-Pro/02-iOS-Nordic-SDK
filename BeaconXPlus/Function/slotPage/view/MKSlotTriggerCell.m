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

@interface MKSlotTriggerCell ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UISwitch *switchView;

@property (nonatomic, strong)UIView *bottomView;

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
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.triggerLabel];
        [self.bottomView addSubview:self.triggerTypeLabel];
        [self.bottomView addSubview:self.temperView];
        [self.bottomView addSubview:self.humidityView];
        [self.bottomView addSubview:self.doubleTapView];
        [self.bottomView addSubview:self.tripleTapView];
        [self.bottomView addSubview:self.movesView];
        [self setupUI];
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
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.switchView.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(0);
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
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(25.f);
    }];
    [self.temperView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.triggerLabel.mas_bottom).mas_offset(5.f);
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
    BOOL hidden = !self.switchView.isOn;
    self.bottomView.alpha = (hidden ? 0 : 1);
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
    if ([dataDic[@"type"] isEqualToString:@"00"]) {
        //无触发条件
        return;
    }
    self.index = [dataDic[@"type"] integerValue] - 1;
    [self setupUI];
}

- (void)updateSwitchStatus:(BOOL)isOn {
    [self.switchView setOn:isOn];
    self.bottomView.alpha = (isOn ? 1 : 0);
}

#pragma mark - private method

- (void)setupUI {
    if (self.index == 0) {
        //Button double tap
        [self.doubleTapView setHidden:NO];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:YES];
        [self.movesView setHidden:YES];
        return;
    }
    if (self.index == 1) {
        //Button triple tap
        [self.doubleTapView setHidden:YES];
        [self.temperView setHidden:YES];
        [self.humidityView setHidden:YES];
        [self.tripleTapView setHidden:NO];
        [self.movesView setHidden:YES];
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
            [self.temperView updateAbove:(self.index == 2) start:YES];
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
            [self.humidityView updateAbove:(self.index == 4) start:YES];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
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
