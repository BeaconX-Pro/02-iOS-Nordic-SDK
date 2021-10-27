//
//  MKBXPDFUModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MKBeaconXCustomUI/MKBXDFUProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPDFUModel : NSObject<MKBXDFUProtocol>

/// 当前连接的设备
@property (nonatomic, strong)CBPeripheral *peripheral;

/// dfu开始的回调
@property (nonatomic, copy)void (^startDFUBlock)(void);

/// dfu完成的回调
@property (nonatomic, copy)void (^DFUCompleteBlock)(void);

@end

NS_ASSUME_NONNULL_END
