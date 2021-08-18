//
//  MKBXDeviceInfoController.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKBXDeviceInfoDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDeviceInfoController : MKBaseViewController

@property (nonatomic, strong)id <MKBXDeviceInfoDataProtocol>dataModel;

/// 左侧按钮的点击事件
@property (nonatomic, copy)void (^leftButtonActionBlock)(void);

@end

NS_ASSUME_NONNULL_END
