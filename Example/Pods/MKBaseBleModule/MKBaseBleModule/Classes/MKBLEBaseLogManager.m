//
//  MKBLEBaseLogManager.m
//  Pods-MKBLEBaseModule_Example
//
//  Created by aa on 2019/11/19.
//  Copyright © 2019 aadyx2007@163.com. All rights reserved.
//

#import "MKBLEBaseLogManager.h"
#import <objc/runtime.h>

#import "MKBLEBaseSDKDefines.h"

static const char *formatterKey = "formatterKey";

@implementation MKBLEBaseLogManager

+ (BOOL)saveDataWithFileName:(nonnull NSString *)fileName
                    dataList:(nonnull NSArray <NSString *>*)dataList {
    if (!MKValidStr(fileName) || !MKValidArray(dataList)) {
        return NO;
    }
    NSString *path = [self cachesDirectory];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",fileName];
    NSString *filePath = [path stringByAppendingString:localFileName];
    BOOL exit = [self fileExistInPath:filePath isDirectory:NO];
    if (!exit) {
        BOOL createResult = [self createFileInPath:path fileName:localFileName];
        if (!createResult) {
            return NO;
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (error || !MKValidDict(fileAttributes)) {
        return NO;
    }
    NSString *datestr = [self.formatter stringFromDate:[NSDate date]];
    @synchronized(self) {
        //写数据部分
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile];   //将节点跳到文件的末尾
        for (NSString *tempData in dataList) {
            NSString *stringToWrite = [NSString stringWithFormat:@"\n%@  %@",datestr,tempData];
            NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData];
        }
        [fileHandle closeFile];
    }
    return YES;
}

+ (NSData *)readDataWithFileName:(nonnull NSString *)fileName {
    NSString *path = [self cachesDirectory];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",fileName];
    NSString *filePath = [path stringByAppendingString:localFileName];
    NSString *fileString = [self readFileInPath:filePath];
    if (!MKValidStr(fileString)) {
        return nil;
    }
    NSData *fileData = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    return fileData;
}

+ (void)deleteLogWithFileName:(nonnull NSString *)fileName {
    NSString *path = [self cachesDirectory];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",fileName];
    NSString *filePath = [path stringByAppendingString:localFileName];
    [self deleteFileInPath:filePath];
}

#pragma mark - private method
+ (NSString *)cachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
}

/**
 指定路径下面是否存在文件或者文件夹
 
 @param path 指定的路径
 @param isDirectory 是否是文件夹，YES:文件夹,NO:文件
 @return YES:存在，NO:不存在
 */
+ (BOOL)fileExistInPath:(NSString *)path isDirectory:(BOOL)isDirectory{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    return existed;
}


/**
 创建文件
 
 @param path 要创建文件的路径
 @param fileName 文件名字
 @return YES:创建成功，NO:创建失败
 */
+ (BOOL)createFileInPath:(NSString *)path fileName:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *newFilePath = [path stringByAppendingPathComponent:fileName];
    BOOL res = [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
    return res;
}

/**
 删除文件
 
 @param path 文件路径
 @return YES:删除成功，NO:删除失败
 */
+ (BOOL)deleteFileInPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:path error:nil];
    return res;
}

/**
 读取文件
 
 @param path 文件路径
 @return 读取的数据
 */
+ (NSString *)readFileInPath:(NSString *)path{
    NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}

+ (NSDateFormatter *)formatter{
    NSDateFormatter *formatter = objc_getAssociatedObject(self, &formatterKey);
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        objc_setAssociatedObject(self, &formatterKey, formatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return formatter;
}

@end
