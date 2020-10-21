//
//  MKBXPPeripheral.h
//  tempasdfjasd
//
//  Created by aa on 2020/9/26.
//

#import <Foundation/Foundation.h>

#import "MKBLEBaseDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPPeripheral : NSObject<MKBLEBasePeripheralProtocol>

@property (nonatomic, strong, nonnull)CBPeripheral *peripheral;

@end

NS_ASSUME_NONNULL_END
