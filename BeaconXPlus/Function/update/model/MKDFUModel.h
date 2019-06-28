//
//  MKDFUModel.h
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDFUModel : NSObject

/**
 dfu升级
 
 @param url 固件url
 @param progressBlock 升级进度
 @param sucBlock 升级成功回调
 @param failedBlock 升级失败回调
 */
- (void)dfuUpdateWithFileUrl:(NSString *)url
               progressBlock:(void (^)(CGFloat progress))progressBlock
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
