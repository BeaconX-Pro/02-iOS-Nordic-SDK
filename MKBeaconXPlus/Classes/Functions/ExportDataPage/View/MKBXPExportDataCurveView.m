//
//  MKBXPExportDataCurveView.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPExportDataCurveView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKBXPTHCurveView.h"

@interface MKBXPExportDataCurveView ()

@property (nonatomic, strong)UILabel *totalLabel;

@property (nonatomic, strong)UILabel *displayLabel;

@property (nonatomic, strong)MKBXPTHCurveView *tempView;

@property (nonatomic, strong)MKBXPTHCurveViewModel *tempModel;

@property (nonatomic, strong)MKBXPTHCurveView *humidityView;

@property (nonatomic, strong)MKBXPTHCurveViewModel *humidityModel;

@end

@implementation MKBXPExportDataCurveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(224, 245, 254);
        [self addSubview:self.tempView];
        [self addSubview:self.humidityView];
        [self addSubview:self.totalLabel];
        [self addSubview:self.displayLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.totalLabel.mas_bottom).mas_offset(3.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.tempView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(self.mas_centerY).mas_offset(-5.f);
    }];
    [self.humidityView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(5.f);
        make.height.mas_equalTo(self.tempView.mas_height);
    }];
    
}

#pragma mark - public method
- (void)updateTemperatureDatas:(NSArray <NSString *>*)temperatureList
                temperatureMax:(CGFloat)temperatureMax
                temperatureMin:(CGFloat)temperatureMin
                  humidityList:(NSArray <NSString *>*)humidityList
                   humidityMax:(CGFloat)humidityMax
                   humidityMin:(CGFloat)humidityMin
                 completeBlock:(void (^)(void))completeBlock {
    if (!ValidArray(temperatureList) || !ValidArray(humidityList)) {
        if (completeBlock) {
            completeBlock();
        }
        return;
    }
    self.totalLabel.text = [@"Total Data Points: " stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)temperatureList.count]];
    NSString *displayText = [NSString stringWithFormat:@"%ld",(long)temperatureList.count];
    if (temperatureList.count > 1000) {
        displayText = @"1000";
    }
    self.displayLabel.text = [@"Window Display Points: " stringByAppendingString:displayText];
    [self.tempView drawCurveWithParamModel:self.tempModel
                                 pointList:temperatureList
                                  maxValue:temperatureMax
                                  minValue:temperatureMin];
    [self.humidityView drawCurveWithParamModel:self.humidityModel
                                     pointList:humidityList
                                      maxValue:humidityMax
                                      minValue:humidityMin];
    if (completeBlock) {
        completeBlock();
    }
}

#pragma mark - getter
- (MKBXPTHCurveView *)tempView {
    if (!_tempView) {
        _tempView = [[MKBXPTHCurveView alloc] init];
    }
    return _tempView;
}

- (MKBXPTHCurveViewModel *)tempModel {
    if (!_tempModel) {
        _tempModel = [[MKBXPTHCurveViewModel alloc] init];
        _tempModel.curveTitle = @"Temperature(℃)";
    }
    return _tempModel;
}

- (MKBXPTHCurveView *)humidityView {
    if (!_humidityView) {
        _humidityView = [[MKBXPTHCurveView alloc] init];
    }
    return _humidityView;
}

- (MKBXPTHCurveViewModel *)humidityModel {
    if (!_humidityModel) {
        _humidityModel = [[MKBXPTHCurveViewModel alloc] init];
        _humidityModel.lineColor = [UIColor greenColor];
        _humidityModel.curveTitle = @"Humidity(%RH)";
    }
    return _humidityModel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor blueColor];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.font = MKFont(10.f);
        _totalLabel.text = @"Total Data Points: 0";
    }
    return _totalLabel;
}

- (UILabel *)displayLabel {
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] init];
        _displayLabel.textColor = [UIColor blueColor];
        _displayLabel.textAlignment = NSTextAlignmentRight;
        _displayLabel.font = MKFont(10.f);
        _displayLabel.text = @"Window Display Points: 0";
    }
    return _displayLabel;
}

@end
