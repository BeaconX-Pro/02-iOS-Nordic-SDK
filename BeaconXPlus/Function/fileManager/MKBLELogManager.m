//
//  MKBLELogManager.m
//  MKLorawanGpsTracker
//
//  Created by aa on 2019/5/6.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBLELogManager.h"
#import <objc/runtime.h>

static const char *formatterKey = "formatterKey";
static NSString *const localFileName = @"/T&HDatas.txt";

@implementation MKBLELogManager

#pragma mark - Public method

/**
 写入命令到本地文件
 
 @param dataList 要写入的数据，可以写入一系列的数据，数组里面必须是字符串
 */
+ (void)writeCommandToLocalFile:(NSArray *)dataList{
    if (!ValidArray(dataList)) {
        return;
    }
    NSString *path = [self getCachesDirectory];
    NSString *filePath = [path stringByAppendingString:localFileName];
    BOOL exit = [self fileExistInPath:filePath isDirectory:NO];
    if (!exit) {
        BOOL createResult = [self createFileInPath:path fileName:localFileName];
        if (!createResult) {
            NSLog(@"创建文件出错");
            return;
        }
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (error || !ValidDict(fileAttributes)) {
        return;
    }
    NSDate *createDate = fileAttributes[@"NSFileCreationDate"];
    NSString *createTimeInfo = [[self formatter] stringFromDate:createDate];
    
    if (!ValidStr(createTimeInfo)) {
        NSLog(@"写入错误");
        return;
    }
    NSArray *timeArr = [createTimeInfo componentsSeparatedByString:@" "];
    if (!ValidArray(timeArr)) {
        NSLog(@"写入错误");
        return;
    }
    NSString *createTime = timeArr[0];
    if (!ValidStr(createTime)) {
        NSLog(@"写入错误");
        return;
    }
    //BOOL deleteResult = [self deleteFileInPath:filePath];
    NSString *datestr = [self.formatter stringFromDate:[NSDate date]];
    @synchronized(self) {
        //写数据部分
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile];   //将节点跳到文件的末尾
        for (NSString *tempData in dataList) {
            NSString *stringToWrite = [NSString stringWithFormat:@"\n%@  %@",datestr,tempData];
            //        NSLog(@"写入的数据:%@",stringToWrite);
            NSData *stringData = [stringToWrite dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData];
        }
        [fileHandle closeFile];
    }
}

/**
 读取本地存储的命令数据
 
 @return 存储的命令数据
 */
+ (NSData *)readCommandDataFromLocalFile{
    NSString *path = [self getCachesDirectory];
    NSString *filePath = [path stringByAppendingString:localFileName];
    NSString *fileString = [self readFileInPath:filePath];
    if (!ValidStr(fileString)) {
        return nil;
    }
    NSData *fileData = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    return fileData;
}

+ (void)deleteLog {
    NSString *path = [self getCachesDirectory];
    NSString *filePath = [path stringByAppendingString:localFileName];
    [self deleteFileInPath:filePath];
}

#pragma mark - Private method

/**
 获取Caches文件目录
 
 @return Caches文件目录
 */
+ (NSString *)getCachesDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)lastObject];
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
    if (res) {
        //文件创建成功
        return YES;
    }else{
        //文件创建失败
        return NO;
    }
}

/**
 删除文件
 
 @param path 文件路径
 @return YES:删除成功，NO:删除失败
 */
+ (BOOL)deleteFileInPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:path error:nil];
    if (res) {
        //文件删除成功
        return YES;
    }else{
        //文件删除失败
        return NO;
    }
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
