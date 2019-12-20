//
//  MKTimePickerView.h
//  FitPolo
//
//  Created by aa on 17/5/9.
//  Copyright © 2017年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKTimerPickerModel : NSObject

/**
 要展示的时间格式
 */
@property (nonatomic, copy)NSString *dateFormat;

/**
 时间选择器当前显示的时间,格式必须跟dateFormat一致，否则出错
 */
@property (nonatomic, copy)NSString *time;

/**
 时间选择器的类型
 */
@property (nonatomic, assign)UIDatePickerMode datePickerMode;

/**
 日期选择器最小的日期，yyyy-MM-dd
 */
@property (nonatomic, copy)NSString *maxTime;

/**
 日期选择器最大的日期,yyyy-MM-dd
 */
@property (nonatomic, copy)NSString *minTime;

@end

typedef void(^MKTimePickViewBlock)(MKTimerPickerModel *timeModel);

@interface MKTimePickerView : UIView

@property (nonatomic, strong)MKTimerPickerModel *timeModel;

/**
 显示时间选择器
 
 @param Block 返回选中的时间信息
 */
- (void)showTimePickViewBlock:(MKTimePickViewBlock)Block;

@end
