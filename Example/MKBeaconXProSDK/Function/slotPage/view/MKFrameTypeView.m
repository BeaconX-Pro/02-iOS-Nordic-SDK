//
//  MKFrameTypeView.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKFrameTypeView.h"

static CGFloat const pickViewRowHeight = 30.f;
static CGFloat const pickViewWidth = 80.f;

static CGFloat const leftIconWidth = 22.f;
static CGFloat const leftIconHeight = 22.f;
static CGFloat const typeLabelWidth = 100.f;
static CGFloat const offset_X = 15.f;

@interface MKFrameTypeViewModel : NSObject

@property (nonatomic, copy)NSString *typeName;

@property (nonatomic, assign)slotFrameType frameType;

@end

@implementation MKFrameTypeViewModel
@end

@interface MKFrameTypeView()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIImageView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, assign)slotFrameType frameType;

@end

@implementation MKFrameTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.pickerView];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(leftIconWidth);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(leftIconHeight);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(offset_X);
        make.width.mas_equalTo(typeLabelWidth);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(pickViewWidth);
        make.top.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-10.f);
    }];
}

#pragma mark - 代理方法

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
    MKFrameTypeViewModel *model = self.dataList[row];
    if(model.frameType == self.frameType){
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
    MKFrameTypeViewModel *model = self.dataList[row];
    return model.typeName;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    MKFrameTypeViewModel *model = self.dataList[row];
    NSAttributedString *attString = [MKAttributedString getAttributedString:@[model.typeName]
                                                                      fonts:@[MKFont(13.f)]
                                                                     colors:@[UIColorFromRGB(0x2F84D0)]];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    MKFrameTypeViewModel *model = self.dataList[row];
    self.frameType = model.frameType;
    [self.pickerView reloadAllComponents];
    if ([self.delegate respondsToSelector:@selector(frameTypeChangedMethod:)]) {
        [self.delegate frameTypeChangedMethod:model.frameType];
    }
}

#pragma mark - Private method

- (void)reloadDataList {
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:[self fetchTypeList]];
    [self.pickerView reloadAllComponents];
}

- (NSArray *)fetchTypeList {
    MKFrameTypeViewModel *tlmModel = [[MKFrameTypeViewModel alloc] init];
    tlmModel.typeName = @"TLM";
    tlmModel.frameType = slotFrameTypeTLM;
    
    MKFrameTypeViewModel *uidModel = [[MKFrameTypeViewModel alloc] init];
    uidModel.typeName = @"UID";
    uidModel.frameType = slotFrameTypeUID;
    
    MKFrameTypeViewModel *urlModel = [[MKFrameTypeViewModel alloc] init];
    urlModel.typeName = @"URL";
    urlModel.frameType = slotFrameTypeURL;
    
    MKFrameTypeViewModel *iBeaconModel = [[MKFrameTypeViewModel alloc] init];
    iBeaconModel.typeName = @"iBeacon";
    iBeaconModel.frameType = slotFrameTypeiBeacon;
    
    MKFrameTypeViewModel *deviceInfoModel = [[MKFrameTypeViewModel alloc] init];
    deviceInfoModel.typeName = @"Device Info";
    deviceInfoModel.frameType = slotFrameTypeInfo;
    
    MKFrameTypeViewModel *noDataModel = [[MKFrameTypeViewModel alloc] init];
    noDataModel.typeName = @"NO DATA";
    noDataModel.frameType = slotFrameTypeNull;
    
    MKFrameTypeViewModel *axisModel = [[MKFrameTypeViewModel alloc] init];
    axisModel.typeName = @"3-axis";
    axisModel.frameType = slotFrameTypeThreeASensor;
    
    MKFrameTypeViewModel *thModel = [[MKFrameTypeViewModel alloc] init];
    thModel.typeName = @"T&H";
    thModel.frameType = slotFrameTypeTHSensor;
    
    if ([[MKDataManager shared].deviceType isEqualToString:@"01"]) {
        //带LIS3DH3轴加速度计
        return @[tlmModel,uidModel,urlModel,iBeaconModel,deviceInfoModel,axisModel,noDataModel];
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"02"]) {
        //带SHT3X温湿度传感器
        return @[tlmModel,uidModel,urlModel,iBeaconModel,deviceInfoModel,thModel,noDataModel];
    }
    if ([[MKDataManager shared].deviceType isEqualToString:@"03"]) {
        //同时带有LIS3DH及SHT3X传感器
        return @[tlmModel,uidModel,urlModel,iBeaconModel,deviceInfoModel,thModel,axisModel,noDataModel];
    }
    //不带传感器
    return @[tlmModel,uidModel,urlModel,iBeaconModel,deviceInfoModel,noDataModel];
}

#pragma mark - Public method

- (void)updateFrameType:(slotFrameType)frameType {
    [self reloadDataList];
    self.frameType = frameType;
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKFrameTypeViewModel *model = self.dataList[i];
        if (model.frameType == frameType) {
            selectedRow = i;
            break;
        }
    }
    [self.pickerView selectRow:selectedRow inComponent:0 animated:YES];
}

#pragma mark - setter & getter

- (UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] init];
        _backView.image = LOADIMAGE(@"scanHeaderViewBackIcon", @"png");
        _backView.userInteractionEnabled = YES;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADIMAGE(@"slot_frameType", @"png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Frame Type";
    }
    return _typeLabel;
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
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end
