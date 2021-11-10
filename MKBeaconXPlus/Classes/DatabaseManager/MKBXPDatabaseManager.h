//
//  MKBXPDatabaseManager.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/11/9.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPDatabaseManager : NSObject

+ (void)insertDeviceList:(NSArray <NSDictionary *>*)htList
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)readLocalDeviceWithSucBlock:(void (^)(NSArray <NSDictionary *>*htList))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

+ (void)deleteDatasWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
