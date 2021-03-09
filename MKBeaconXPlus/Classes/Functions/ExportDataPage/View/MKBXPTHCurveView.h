//
//  MKBXPTHCurveView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPTHCurveViewModel : NSObject

/// 曲线颜色，默认蓝色
@property (nonatomic, strong)UIColor *lineColor;

/// 曲线线宽，默认1.f
@property (nonatomic, assign)CGFloat lineWidth;

/// 曲线背景颜色,默认RGBCOLOR(224, 245, 254)
@property (nonatomic, strong)UIColor *curveViewBackgroundColor;

/// 右侧曲线标题
@property (nonatomic, copy)NSString *curveTitle;

/// 标题颜色，默认#353535
@property (nonatomic, strong)UIColor *titleColor;

/// 标题字体大小，默认12.f
@property (nonatomic, strong)UIFont *titleFont;

/// 竖轴的颜色，默认#353535
@property (nonatomic, strong)UIColor *yPostionColor;

/// 竖轴线宽，默认0.5
@property (nonatomic, assign)CGFloat yPostionWidth;

/// 左侧竖轴显示的标签字体颜色，默认#353535
@property (nonatomic, strong)UIColor *labelColor;

/// 左侧竖轴显示的标签字体大小，默认10.f
@property (nonatomic, strong)UIFont *labelFont;

@end

@interface MKBXPTHCurveView : UIView

- (void)drawCurveWithParamModel:(MKBXPTHCurveViewModel *)dataModel
                      pointList:(NSArray <NSString *>*)pointList
                       maxValue:(CGFloat)maxValue
                       minValue:(CGFloat)minValue;

- (void)drawCurveWithPointList:(NSArray <NSString *>*)pointList
                      maxValue:(CGFloat)maxValue
                      minValue:(CGFloat)minValue;

@end

NS_ASSUME_NONNULL_END
