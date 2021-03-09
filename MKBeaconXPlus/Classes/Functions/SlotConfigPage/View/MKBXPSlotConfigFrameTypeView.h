//
//  MKBXPSlotConfigFrameTypeView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKBXPEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPSlotConfigFrameTypeViewDelegate <NSObject>

- (void)bxp_frameTypeChangedMethod:(mk_bxp_slotFrameType)frameType;

@end

@interface MKBXPSlotConfigFrameTypeView : UIView

@property (nonatomic, assign, readonly)mk_bxp_slotFrameType frameType;

@property (nonatomic, weak)id <MKBXPSlotConfigFrameTypeViewDelegate>delegate;

- (void)updateFrameType:(mk_bxp_slotFrameType)frameType;

@end

NS_ASSUME_NONNULL_END
