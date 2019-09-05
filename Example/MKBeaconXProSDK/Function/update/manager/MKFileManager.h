//
//  MKFileManager.h
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/3.
//  Copyright © 2019 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFileManager : NSObject

/**
 获取document目录
 
 @return document目录
 */
+ (NSString *)document;

/**
 获取document目录下面的所有文件
 
 @return @[]
 */
+ (NSArray *)getDocumentFiles;

@end

NS_ASSUME_NONNULL_END
