//
//  MKMainTabBarController.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const peripheralIdenty;
extern NSString *const passwordIdenty;

@interface MKMainTabBarController : UITabBarController

@property (nonatomic, strong)NSDictionary *params;

@end

NS_ASSUME_NONNULL_END
