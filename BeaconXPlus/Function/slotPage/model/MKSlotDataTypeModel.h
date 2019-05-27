//
//  MKSlotDataTypeModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSlotDataTypeModel : NSObject

/**
 通道数据类型
 */
@property (nonatomic, assign)slotFrameType slotType;

/**
 是否可点击
 */
@property (nonatomic, assign)BOOL clickEnable;

/**
 第几个通道
 */
@property (nonatomic, assign)bxpActiveSlotNo slotIndex;

@end

NS_ASSUME_NONNULL_END
