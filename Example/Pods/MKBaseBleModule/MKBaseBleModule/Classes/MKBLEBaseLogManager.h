//
//  MKBLEBaseLogManager.h
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/19.
//  Copyright © 2019 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBLEBaseLogManager : NSObject

/// 将数据写到本地,最终生成的文件名字:"/fileName.txt",位于沙盒Library/Caches/fileName.txt
/// @param fileName 数据要写入的文件名称
/// @param dataList 要写入的数据
+ (BOOL)saveDataWithFileName:(nonnull NSString *)fileName
                    dataList:(nonnull NSArray <NSString *>*)dataList;

/// 读取本地文件数据,最终文件名称是"/fileName.txt"
/// @param fileName 文件名称
+ (NSData *)readDataWithFileName:(nonnull NSString *)fileName;

/// 删除本地指定名称的文件,最终文件名称是"/fileName.txt"
/// @param fileName 文件名称
+ (void)deleteLogWithFileName:(nonnull NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
