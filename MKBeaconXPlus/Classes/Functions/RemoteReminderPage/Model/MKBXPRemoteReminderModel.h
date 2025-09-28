//
//  MKBXPRemoteReminderModel.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPRemoteReminderModel : NSObject

#pragma mark - LED notification

/// 0:Red 1:Green 2:Blue
@property (nonatomic, assign)NSInteger color;

@property (nonatomic, copy)NSString *blinkingTime;

@property (nonatomic, copy)NSString *blinkingInterval;

#pragma mark - Buzzer notification
@property (nonatomic, copy)NSString *frequent;

@property (nonatomic, copy)NSString *ringingTime;

@property (nonatomic, copy)NSString *ringingInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
