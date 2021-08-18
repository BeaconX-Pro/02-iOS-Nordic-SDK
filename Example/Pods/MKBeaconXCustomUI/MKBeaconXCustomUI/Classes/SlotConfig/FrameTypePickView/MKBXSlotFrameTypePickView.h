//
//  MKBXSlotFrameTypePickView.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKBXEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotFrameTypePickViewCellModel : NSObject

@property (nonatomic, copy)NSString *frameName;

@property (nonatomic, assign)mk_bx_slotFrameType frameType;

@end

@protocol MKBXSlotFrameTypePickViewDelegate <NSObject>

- (void)mk_bx_slotFrameTypeChanged:(mk_bx_slotFrameType)frameType;

@end

@interface MKBXSlotFrameTypePickView : UIView

@property (nonatomic, assign, readonly)mk_bx_slotFrameType frameType;

/// 选择器数据源
@property (nonatomic, strong)NSMutableArray <MKBXSlotFrameTypePickViewCellModel *>*dataList;

@property (nonatomic, weak)id <MKBXSlotFrameTypePickViewDelegate>delegate;

- (void)updateFrameType:(mk_bx_slotFrameType)frameType;

@end

NS_ASSUME_NONNULL_END
