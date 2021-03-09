//
//  MKBXPTriggerTapView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXPTriggerTapViewType) {
    MKBXPTriggerTapViewDouble,
    MKBXPTriggerTapViewTriple,
    MKBXPTriggerTapViewDeviceMoves,
};

@interface MKBXPTriggerTapViewModel : NSObject

/// 0:Always advertise,1:Start advertising for a while,2:Stop advertising for a while
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)MKBXPTriggerTapViewType viewType;

/// index=1的时候，输入框的值
@property (nonatomic, copy)NSString *startValue;

/// index=2的时候，输入框的值
@property (nonatomic, copy)NSString *stopValue;

@end

@protocol MKBXPTriggerTapViewDelegate <NSObject>

/// 用户选择了触发方式
/// @param index 0:Always advertise,1:Start advertising for a while,2:Stop advertising for a while
/// @param viewType 当前触发回调的view类型
- (void)bxp_triggerTapViewIndexChanged:(NSInteger)index viewType:(MKBXPTriggerTapViewType)viewType;

/// index=1的时候，输入框的值
- (void)bxp_triggerTapViewStartValueChanged:(NSString *)startValue viewType:(MKBXPTriggerTapViewType)viewType;

/// index=2的时候，输入框的值
- (void)bxp_triggerTapViewStopValueChanged:(NSString *)stopValue viewType:(MKBXPTriggerTapViewType)viewType;

@end

@interface MKBXPTriggerTapView : UIView

@property (nonatomic, weak)id <MKBXPTriggerTapViewDelegate>delegate;

@property (nonatomic, strong)MKBXPTriggerTapViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
