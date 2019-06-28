//
//  MKDFUAdopter.h
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDFUAdopter : NSObject

// 监听指定目录的文件改动
- (void)startMonitoringDirectory:(void (^)(void))dfuFileDatasChangedBlock;

/**
 获取dfu数据，zip格式的
 
 @return @[]
 */
- (NSArray *)getDfuFilesList;

/**
 dfu升级
 
 @param fileName 选取的固件名字
 @param controller 当前控制器
 */
- (void)dfuUpdateWithFileName:(NSString *)fileName target:(UIViewController *)controller;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
