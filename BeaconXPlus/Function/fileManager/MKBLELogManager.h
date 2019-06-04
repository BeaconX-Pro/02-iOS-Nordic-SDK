//
//  MKBLELogManager.h
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/6.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBLELogManager : NSObject

/**
 写入命令到本地文件
 
 @param dataList 要写入的数据，可以写入一系列的数据，数组里面必须是字符串
 */
+ (void)writeCommandToLocalFile:(NSArray *)dataList;

/**
 读取本地存储的命令数据
 
 @return 存储的命令数据
 */
+ (NSData *)readCommandDataFromLocalFile;

+ (void)deleteLog;

@end

NS_ASSUME_NONNULL_END
