//
//  MKExcelWookbook.m
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2023/7/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKExcelWookbook.h"

#import "ZipArchive.h"
#import "MKXMLReader.h"

#import "MKMacroDefines.h"

@interface MKExcelWookbook()

@property(nonatomic,copy)NSString *originFileFolderPath;//原excel文件的文件夹路径

@property(nonatomic,copy)NSString *originFileName;//原excel文件名

@end

@implementation MKExcelWookbook

/**
 根据excel文件路径解析
 
 @param pathUrl 文件路径
 @return 解析好的工作簿模型
 */
-(instancetype)initWithExcelFilePathUrl:(NSURL *)pathUrl
{
    self = [super init];
    if(self) {
        BOOL analysisSuccess = [self analysisPathAndFileNameWithPath:pathUrl.path];

        //获取原文件二进制
        NSError *error = nil;
        NSData * data = [self getOriginFileDataWithUrl:pathUrl error:&error];
        
        if(analysisSuccess && data.length > 0)
        {
            //创建临时文件夹
            NSString *tempFolderPath = [self getTempFolderPathWithOriginFolderPath:self.originFileFolderPath];
            
            if(tempFolderPath && tempFolderPath.length > 0)
            {
                NSString *tempZipPath = [tempFolderPath stringByAppendingString:@"/MYCExcelWookbookTemp.zip"];
                
                BOOL writeSuccess = [self writeOriginFileTempZipWithData:data path:tempZipPath];
                
                if(writeSuccess)
                {
                    //解压ZIP
                    BOOL uncompressionSuccess = [SSZipArchive unzipFileAtPath:tempZipPath toDestination:tempFolderPath];
                    
                    if(uncompressionSuccess)
                    {
                        //删除临时压缩包
                        [self deleteOriginTempZIPWithPath:tempZipPath];
                        
                        //获取公共字符串字典
                        NSDictionary *sharedStringsDic = [self getSharedStringsWithPath:tempFolderPath];
                        
                        NSMutableArray *stringValueArray = [self getSharedStringsValueWithDic:sharedStringsDic];
                        
                        //获取sheet字典数组
                        NSMutableArray *array = [self getSheetXmlDicArrayWithPath:tempFolderPath];
                        
                        NSMutableArray *sheetArray = [[NSMutableArray alloc]init];
                        
                        for(NSInteger i = 0 ; i < array.count ; i ++)
                        {
                            NSDictionary *sheetDic = [array objectAtIndex:i];
                            
                            MKExcelSheet *sheet = [[MKExcelSheet alloc]init];
                            
                            sheet.sheetId = [[sheetDic objectForKey:@"sheetId"] integerValue];
                            
                            sheet.cellArray = [MKExcelSheet analysisSheetDataWithSheetDic:sheetDic sharedStringsArray:stringValueArray];
                            
                            sheet.sheetName = [self getSheetNameWithSheetId:sheet.sheetId path:tempFolderPath];
                            
                            [sheetArray addObject:sheet];
                        }

                        if(sheetArray.count > 0)
                        {
                            self.sheetArray = sheetArray;
                        }
                    }
                }
                
                [self clearTempFileWithPath:tempFolderPath];
            }
        }
    }
    return self;
}



/**
 根据工作表名获取工作表
 
 @param sheetName 工作表名
 @return 工作表
 */
-(MKExcelSheet *)getSheetWithSheetName:(NSString *)sheetName
{
    MKExcelSheet *sheet = nil;
    
    
    return sheet;
}




/**
 
 
 @return 是否整理成功
 */

/**
 解析路径，解析出文件夹当前路径 和  文件名
 @param path excel文件路径
 @return 是否解析成功
 */
-(BOOL)analysisPathAndFileNameWithPath:(NSString *)path {
    BOOL analysisSuccess = NO;
    
    self.wookbookName = [[path lastPathComponent] stringByDeletingPathExtension];
    
    self.originFileFolderPath = [path stringByDeletingLastPathComponent];
    
    NSString *fileSuffix = [path pathExtension];
    
    if(self.wookbookName.length > 0 && self.originFileFolderPath.length > 0 && [fileSuffix isEqualToString: @"xlsx"])
    {
        analysisSuccess = YES;
    }
    return analysisSuccess;
}


/**
 获取原文件二进制数据
 @param originFileUrl 原文件URL
 @param error 错误信息
 @return 二进制数据
 */
-(NSData *)getOriginFileDataWithUrl:(NSURL *)originFileUrl error:(NSError **)error
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:originFileUrl error:error];
    
    NSData * data = fileHandle.readDataToEndOfFile;

    return data;
}





/**
 获取临时文件夹路径
 @param originFolderPath 原文件夹路径
 @return 创建好的临时文件夹
 */
-(NSString *)getTempFolderPathWithOriginFolderPath:(NSString *)originFolderPath
{
    NSString *tempFolderPath = nil;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    originFolderPath = documentPath;
    
    if(originFolderPath && [originFolderPath isKindOfClass:[NSString class]] && originFolderPath.length > 0)
    {
        tempFolderPath = [originFolderPath stringByAppendingString:@"/MYCExcelAnalysisTemp"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];

        if(![fileManager fileExistsAtPath:tempFolderPath]){
            
            NSError *error = nil;
            
          BOOL creatSuccess =  [fileManager createDirectoryAtPath:tempFolderPath withIntermediateDirectories:YES attributes:nil error:&error];

            if(!creatSuccess)
            {
                tempFolderPath = nil;
            }
        }
    }
    return tempFolderPath;
}


//将原文件写成压缩包
-(BOOL)writeOriginFileTempZipWithData:(NSData *)data path:(NSString *)path
{
    BOOL writeSuccess = NO;
    
    NSError *error = nil;
    
    writeSuccess = [data writeToFile:path options:NSDataWritingWithoutOverwriting error:&error];
    
    return writeSuccess;
}


//删除原文件临时压缩包
-(BOOL)deleteOriginTempZIPWithPath:(NSString *)tempZipPath
{
    BOOL deleteSuccess = YES;
    
    NSError *removeError = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:tempZipPath error:&removeError];
    
    if(removeError != nil)
    {
        deleteSuccess = NO;
    }
    return deleteSuccess;
}


//获取xml公共字符串字典
-(NSDictionary *)getSharedStringsWithPath:(NSString *)path
{
    NSDictionary *xmlDic = nil;
    
    NSString *sharedStringsXmlPath = [path stringByAppendingString:@"/xl/sharedStrings.xml"];
    
    NSData *xmlData = [NSData dataWithContentsOfFile:sharedStringsXmlPath];
    
    if(xmlData && xmlData.length > 0)
    {
        NSError *error = nil;
        
        xmlDic = [MKXMLReader dictionaryForXMLData:xmlData error:&error];
    }
    return xmlDic;
}


//获取公共字符串值数组
-(NSMutableArray *)getSharedStringsValueWithDic:(NSDictionary *)sharedStringsDic
{
    NSMutableArray *valueArray = nil;
    
    if(sharedStringsDic)
    {
        NSDictionary *sst = [sharedStringsDic objectForKey:@"sst"];
        
        if(sst && [sst isKindOfClass:[NSDictionary class]])
        {
            NSArray *si = [sst objectForKey:@"si"];
            
            if(si && [si isKindOfClass:[NSArray class]] && si.count > 0)
            {
                valueArray = [[NSMutableArray alloc]init];
                
                for(NSInteger i = 0 ; i < si.count ;i ++ )
                {
                    NSDictionary *oneStringValueDic = [si objectAtIndex:i];
                    
                    if(oneStringValueDic && [oneStringValueDic isKindOfClass:[NSDictionary class]])
                    {
                        NSDictionary *t = [oneStringValueDic objectForKey:@"t"];
                        
                        if(t && [t isKindOfClass:[NSDictionary class]])
                        {
                            NSString *oneStringValue = [t objectForKey:@"text"];
                            
                            if(oneStringValue && [oneStringValue isKindOfClass:[NSString class]] && oneStringValue.length > 0)
                            {
                                oneStringValue = [oneStringValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                
                                [valueArray addObject:oneStringValue];
                            }
                        }
                    }
                }
            }
        }
    }
    return valueArray;
}



//获取sheet数据
-(NSMutableArray *)getSheetXmlDicArrayWithPath:(NSString *)path
{
    NSMutableArray *xmlDicArray = nil;
    
    NSString *sheetsFolderPath = [path stringByAppendingString:@"/xl/worksheets/"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:sheetsFolderPath];
    NSString *fileName;
    
    while (fileName = [dirEnum nextObject]) {
        
        if ([fileName hasSuffix:@".xml"]) {
            
            if(xmlDicArray == nil)
            {
                xmlDicArray = [[NSMutableArray alloc]init];
            }
            
            NSLog(@"全路径:%@", [sheetsFolderPath stringByAppendingPathComponent:fileName]);
            
            NSString *xmlPath = [sheetsFolderPath stringByAppendingPathComponent:fileName];
            
            NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
            
            if(xmlData && xmlData.length > 0)
            {
                NSError *error = nil;
                
                NSInteger sheetId = [[MKExcelCell getNumberFromStr:fileName] integerValue];
                
                NSMutableDictionary *sheetDic = [[NSMutableDictionary alloc]init];
                
                NSDictionary *xmlDic = [MKXMLReader dictionaryForXMLData:xmlData error:&error];
                
                [sheetDic setObject:[NSNumber numberWithInteger:sheetId] forKey:@"sheetId"];
                
                [sheetDic setObject:xmlDic forKey:@"oneSheetData"];
                
                [xmlDicArray addObject:sheetDic];
            }
        }
    }
    return xmlDicArray;
}


//获取表名
-(NSString *)getSheetNameWithSheetId:(NSInteger )sheetId path:(NSString *)path
{
    NSString *sheetName = nil;
    
    NSArray *infoArray = [self getSheedNameInfoArrayWithPath:path];
    
    if([infoArray isKindOfClass:[NSArray class]])
    {
        for(NSInteger i = 0 ;i < infoArray.count ;i ++)
        {
            NSDictionary *dic = [infoArray objectAtIndex:i];
            
            NSInteger oldSheetId = [[dic objectForKey:@"sheetId"] integerValue];
            
            if(oldSheetId == sheetId)
            {
                sheetName = [dic objectForKey:@"name"];
            }
        }
    }
    else
    {
        NSDictionary *dic = (NSDictionary *)infoArray;
        
        NSInteger oldSheetId = [[dic objectForKey:@"sheetId"] integerValue];
        
        if(oldSheetId == sheetId)
        {
            sheetName = [dic objectForKey:@"name"];
        }
    }
    
    
    return sheetName;
}


/**
 获取sheet名信息
 */
-(NSArray *)getSheedNameInfoArrayWithPath:(NSString *)path
{
    NSArray *sheetNameInfoArray = nil;
    
    NSString *sharedStringsXmlPath = [path stringByAppendingString:@"/xl/workbook.xml"];
    
    NSData *xmlData = [NSData dataWithContentsOfFile:sharedStringsXmlPath];
    
    NSError *error = nil;
    
    NSDictionary *sheetNameInfoDic = [MKXMLReader dictionaryForXMLData:xmlData error:&error];
    
    if(sheetNameInfoDic && [sheetNameInfoDic isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *workbook = [sheetNameInfoDic objectForKey:@"workbook"];
        
        if(workbook && [workbook isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *sheets = [workbook objectForKey:@"sheets"];
            
            if(sheets && [sheets isKindOfClass:[NSDictionary class]])
            {
                sheetNameInfoArray = [sheets objectForKey:@"sheet"];
            }
        }
    }
    return sheetNameInfoArray;
}




-(void)clearTempFileWithPath:(NSString *)path
{
    NSString *str1 = [path stringByAppendingString:@"/_rels"];
    NSString *str2 = [path stringByAppendingString:@"/[Content_Types].xml"];
    NSString *str3 = [path stringByAppendingString:@"/docProps"];
    NSString *str4 = [path stringByAppendingString:@"/xl"];
    
    [[NSFileManager defaultManager] removeItemAtPath:str1 error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:str2 error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:str3 error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:str4 error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
