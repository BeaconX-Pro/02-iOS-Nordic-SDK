//
//  MKSlotVCModel.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSlotVCModel : NSObject

/**
 当前通道类型
 */
@property (nonatomic, assign)slotFrameType type;

/**
 当前通道的数据
 */
@property (nonatomic, strong)id returnData;

@end

NS_ASSUME_NONNULL_END
