//
//  MKBXDFUProtocol.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@protocol MKBXDFUProtocol <NSObject>

/// 当前连接的设备
@property (nonatomic, strong)CBPeripheral *peripheral;

/// dfu开始的回调
@property (nonatomic, copy)void (^startDFUBlock)(void);

/// dfu完成的回调
@property (nonatomic, copy)void (^DFUCompleteBlock)(void);

/// DFU升级之后需要将原来的中心释放掉，重新初始化才能SDK数据交互
- (void)sharedDealloc;

@end

NS_ASSUME_NONNULL_END
