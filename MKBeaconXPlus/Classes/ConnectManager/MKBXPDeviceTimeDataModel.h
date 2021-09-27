//
//  MKBXPDeviceTimeDataModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/9/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXPInterface+MKBXPConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPDeviceTimeDataModel : NSObject<MKBXPDeviceTimeProtocol>

@property (nonatomic, assign)NSInteger year;

@property (nonatomic, assign)NSInteger month;

@property (nonatomic, assign)NSInteger day;

@property (nonatomic, assign)NSInteger hour;

@property (nonatomic, assign)NSInteger minutes;

@property (nonatomic, assign)NSInteger seconds;

@end

NS_ASSUME_NONNULL_END
