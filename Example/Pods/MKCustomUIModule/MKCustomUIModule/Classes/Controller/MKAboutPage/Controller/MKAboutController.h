//
//  MKAboutController.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAboutController : MKBaseViewController

/// 如果不填写，则取当前工程的版本号
@property (nonatomic, copy)NSString *appVersion;

@end

NS_ASSUME_NONNULL_END
