//
//  MKBXPSlotConfigController.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKBXEnumerateDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSlotConfigController : MKBaseViewController

/// 数据通道类型
@property (nonatomic, assign)mk_bx_slotFrameType slotType;

/// 通道index
@property (nonatomic, assign)NSInteger slotIndex;

@end

NS_ASSUME_NONNULL_END
