//
//  MKBXPQuickSwitchModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPQuickSwitchModel : NSObject

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)BOOL supportLED;

@property (nonatomic, assign)BOOL triggerLED;

@property (nonatomic, assign)BOOL turnOffByButton;

@property (nonatomic, assign)BOOL supportResetByButton;

@property (nonatomic, assign)BOOL resetByButton;

@property (nonatomic, assign)BOOL passwordVerification;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
