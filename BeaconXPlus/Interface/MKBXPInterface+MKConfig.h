//
//  MKBXPInterface+MKConfig.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/25.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPInterface.h"
#import "MKBXPEnumeration.h"

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

/**
 Resetting to factory state (RESET).NOTE:When resetting the device, the connection password will not be restored which shall remain set to its current value.

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)BXPFactoryDataResetWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;
/**
 设置lockState

 @param lockState MKBXPLockState
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPLockState:(MKBXPLockState)lockState
               sucBlock:(void (^)(id returnData))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPPowerOffWithSucBlockWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;
/**
 Setting device’s connection status.
 NOTE: Be careful to set device’s connection statue .Once the device is set to not connectable, it may not be connected, and other parameters cannot be configured.
 
 @param connectEnable YES：Connectable，NO：Not Connectable
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPConnectStatus:(BOOL)connectEnable
                   sucBlock:(void (^)(id returnData))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock;
/**
 MokoBeaconX provides up to 6 SLOTs for users to configure advertisement frame. Before configering the SLOT’s parameter， you should switch the SLOT to target SLOT fristly; otherwise the configuration is only for the currently active SLOT.

 @param slotNo Target SLOT number to switch to
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)setBXPActiveSlot:(bxpActiveSlotNo)slotNo
                sucBlock:(void (^)(id returnData))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
