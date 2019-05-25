//
//  MKBXPInterface+MKConfig.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPInterface (MKConfig)

/**
 Modifying connection password.Only if the device’s LockState is in UNLOCKED state, the password can be modified.
 
 @param newPassword New password, 16 characters
 @param originalPassword Old password, 16 characters
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPNewPassword:(NSString *)newPassword
         originalPassword:(NSString *)originalPassword
                 sucBlock:(void (^)(id returnData))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
