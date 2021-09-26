//
//  MKBXTriggerTapView.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKBXTriggerTapViewType) {
    MKBXTriggerTapViewDouble,
    MKBXTriggerTapViewTriple,
    MKBXTriggerTapViewDeviceMoves,
    MKBXTriggerTapViewAmbientLightDetected,
};

@interface MKBXTriggerTapViewModel : NSObject

/// 0:Start and keep advertising,1:Start advertising for,2:Stop advertising for
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)MKBXTriggerTapViewType viewType;

/// index=1的时候，输入框的值
@property (nonatomic, copy)NSString *startValue;

/// index=2的时候，输入框的值
@property (nonatomic, copy)NSString *stopValue;

@end

@protocol MKBXTriggerTapViewDelegate <NSObject>

/// 用户选择了触发方式
/// @param index 0:Start and keep advertising,1:Start advertising for,2:Stop advertising for
/// @param viewType 当前触发回调的view类型
- (void)mk_bx_triggerTapViewIndexChanged:(NSInteger)index viewType:(MKBXTriggerTapViewType)viewType;

/// index=1的时候，输入框的值
- (void)mk_bx_triggerTapViewStartValueChanged:(NSString *)startValue viewType:(MKBXTriggerTapViewType)viewType;

/// index=2的时候，输入框的值
- (void)mk_bx_triggerTapViewStopValueChanged:(NSString *)stopValue viewType:(MKBXTriggerTapViewType)viewType;

@end

@interface MKBXTriggerTapView : UIView

@property (nonatomic, weak)id <MKBXTriggerTapViewDelegate>delegate;

@property (nonatomic, strong)MKBXTriggerTapViewModel *dataModel;

@end

NS_ASSUME_NONNULL_END
