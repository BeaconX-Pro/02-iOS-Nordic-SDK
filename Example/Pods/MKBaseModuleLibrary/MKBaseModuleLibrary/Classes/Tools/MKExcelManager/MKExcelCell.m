//
//  MKExcelCell.m
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2023/7/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKExcelCell.h"

#import "MKMacroDefines.h"

@implementation MKExcelCell

- (void)setCellDic:(NSDictionary *)cellDic {
    _cellDic = nil;
    _cellDic = cellDic;
    if (!ValidDict(_cellDic)) {
        return;
    }
    [self refreshData];
}

- (void)refreshData {
    NSDictionary *v = [self.cellDic objectForKey:@"v"];
    
    //解析下标
    if(ValidDict(v)) {
        self.stringValueIndex = [[v objectForKey:@"text"] integerValue];
        self.indexAnalysisSuccess = YES;
    }
    
    NSString *r = [self.cellDic objectForKey:@"r"];
    
    NSString *rowStr = [MKExcelCell getNumberFromStr:r];
    
    self.row = [rowStr integerValue];
    
    NSString *column = [MKExcelCell getLetterFromStr:r];
    
    self.column = column;
}


- (void)setStringValue:(NSString *)stringValue {
    if(self.indexAnalysisSuccess) {
        _stringValue = stringValue;
    }
}


/**
 获取字符串内数字
 */
+ (NSString *)getNumberFromStr:(NSString *)str {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}



/**
 获取字符串内字母
 */
+ (NSString *)getLetterFromStr:(NSString *)str {
    NSString *numStr = [self getNumberFromStr:str];
    NSString *letterStr = [str substringWithRange:NSMakeRange(0, str.length - numStr.length)];
    
    return letterStr;
    
}

@end
