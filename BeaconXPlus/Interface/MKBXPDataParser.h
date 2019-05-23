//
//  MKBXPDataParser.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MKBXPDataNum;

@interface MKBXPDataParser : NSObject

+ (NSDictionary *)parseReadDataFromCharacteristic:(CBCharacteristic *)characteristic;

+ (NSDictionary *)parseWriteDataFromCharacteristic:(CBCharacteristic *)characteristic;

@end

NS_ASSUME_NONNULL_END
