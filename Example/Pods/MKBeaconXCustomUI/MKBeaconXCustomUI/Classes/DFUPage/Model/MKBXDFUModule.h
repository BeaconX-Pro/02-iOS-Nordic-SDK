//
//  MKBXDFUModule.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/17.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXDFUProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXDFUModule : NSObject

/// DFU升级
/// @param protocol protocol
/// @param fileUrl 本地的文件路径
/// @param progressBlock 升级进度回调
/// @param sucBlock 升级成功回调
/// @param failedBlock 升级失败回调
- (void)updateWithDFUProtocol:(id <MKBXDFUProtocol>)protocol
                      fileUrl:(NSString *)fileUrl
                progressBlock:(void (^)(CGFloat progress))progressBlock
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
