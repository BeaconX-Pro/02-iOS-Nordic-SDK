//
//  Target_BXP_Module.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/14.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_BXP_Module : NSObject

/// 扫描页面
- (UIViewController *)Action_BXP_Module_ScanController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
