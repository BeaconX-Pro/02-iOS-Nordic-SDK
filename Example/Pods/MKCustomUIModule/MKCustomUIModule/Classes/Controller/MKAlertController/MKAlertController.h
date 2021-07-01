//
//  MKAlertController.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/7/1.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAlertController : UIAlertController

/// 当收到该通知的时候，如果alert被弹出，则自动消失
@property (nonatomic, copy)NSString *notificationName;

@end

NS_ASSUME_NONNULL_END
