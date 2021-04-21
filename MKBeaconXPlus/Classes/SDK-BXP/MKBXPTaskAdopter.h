//
//  MKBXPTaskAdopter.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/22.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CBCharacteristic;

@interface MKBXPTaskAdopter : NSObject

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
