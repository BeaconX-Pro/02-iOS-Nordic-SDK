//
//  MKScanViewController.h
//  BeaconXPlus
//
//  Created by aa on 2019/4/19.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKScanViewController : MKBaseViewController

/**
 缓存用户输入的密码。只有连接成功设备之后才会缓存
 */
@property (nonatomic, copy)NSString *localPassword;

@end

NS_ASSUME_NONNULL_END
