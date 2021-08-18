//
//  MKBXSlotConfigCellProtocol.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/12.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 下面定义的这些key都是mk_bx_slotConfigCell_params返回的json里面的key
 */
static NSString *const mk_bx_slotConfig_advContentType = @"00";
static NSString *const mk_bx_slotConfig_advParamType = @"01";
static NSString *const mk_bx_slotConfig_advTriggerType = @"02";

static NSString *const mk_bx_slotConfig_beaconData = @"beaconKey";
static NSString *const mk_bx_slotConfig_infoData = @"infoKey";
static NSString *const mk_bx_slotConfig_uidData = @"uidKey";
static NSString *const mk_bx_slotConfig_urlData = @"urlKey";

@protocol MKBXSlotConfigCellProtocol <NSObject>

- (NSDictionary *)mk_bx_slotConfigCell_params;

@end

NS_ASSUME_NONNULL_END
