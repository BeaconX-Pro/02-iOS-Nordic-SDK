//
//  MKBXSlotFrameTypePickView.m
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXSlotFrameTypePickView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@implementation MKBXSlotFrameTypePickViewCellModel
@end

@interface MKBXSlotFrameTypePickView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, assign)mk_bx_slotFrameType frameType;

@end

@implementation MKBXSlotFrameTypePickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        [self.backView addSubview:self.pickerView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(100.f);
        make.top.mas_equalTo(10.f);
        make.bottom.mas_equalTo(-10.f);
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
    MKBXSlotFrameTypePickViewCellModel *model = self.dataList[row];
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
    MKBXSlotFrameTypePickViewCellModel *model = self.dataList[row];
    return model.frameName;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    MKBXSlotFrameTypePickViewCellModel *model = self.dataList[row];
    NSAttributedString *attString = [MKCustomUIAdopter attributedString:@[model.frameName]
                                                                  fonts:@[MKFont(13.f)]
                                                                 colors:@[NAVBAR_COLOR_MACROS]];
    return attString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    MKBXSlotFrameTypePickViewCellModel *model = self.dataList[row];
    self.frameType = model.frameType;
    [self.pickerView reloadAllComponents];
    if ([self.delegate respondsToSelector:@selector(mk_bx_slotFrameTypeChanged:)]) {
        [self.delegate mk_bx_slotFrameTypeChanged:model.frameType];
    }
}

#pragma mark - public method
- (void)updateFrameType:(mk_bx_slotFrameType)frameType {
    if (!ValidArray(self.dataList)) {
        return;
    }
    [self.pickerView reloadAllComponents];
    self.frameType = frameType;
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.dataList.count; i ++) {
        MKBXSlotFrameTypePickViewCellModel *model = self.dataList[i];
        if (model.frameType == frameType) {
            selectedRow = i;
            break;
        }
    }
    [self.pickerView selectRow:selectedRow inComponent:0 animated:YES];
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
        _leftIcon.image = LOADICON(@"MKBeaconXCustomUI", @"MKBXSlotFrameTypePickView", @"mk_bx_slotFrameType.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Frame type";
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
        _pickerView.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _pickerView.layer.borderWidth = 0.5f;
        _pickerView.layer.cornerRadius = 4.f;
    }
    return _pickerView;
}

@end
