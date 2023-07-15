//
//  MKExcelSheet.m
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2023/7/15.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKExcelSheet.h"

#import "MKMacroDefines.h"

#import "MKExcelCell.h"

@implementation MKExcelSheet

/**
 根据 横竖坐标 查找cell
 @param column 竖坐标 例：A、H
 @param row 横坐标 例：1、15
 @param error 错误信息
 @return 单元格数据
 */
- (MKExcelCell *)getCellWithColumn:(NSString *)column
                               row:(NSInteger )row
                             error:(NSError **)error {
    MKExcelCell *cell = nil;

    for(NSInteger i = 0 ; i < self.cellArray.count ;i++) {
        MKExcelCell *originCell = self.cellArray[i];
        if([originCell.column isEqualToString:column] && originCell.row == row) {
            cell = originCell;
            break;
        }
    }
    return cell;
}

/**
 解析单表数据
 @param sheetDic 单表字典
 @param sharedStringsArray 公共字符串数组
 @return sheet里所有cell数组
 */
+ (NSMutableArray <MKExcelCell *>*)analysisSheetDataWithSheetDic:(NSDictionary *)sheetDic
                                              sharedStringsArray:(NSArray *)sharedStringsArray {
    NSMutableArray <MKExcelCell *>*oneSheetAllCellArray = [self getCellArrayWithSheetDic:sheetDic
                                                                      sharedStringsArray:sharedStringsArray];
    return oneSheetAllCellArray;
}





+(NSMutableArray <MKExcelCell *>*)getCellArrayWithSheetDic:(NSDictionary *)sheetDic
                                        sharedStringsArray:(NSArray *)sharedStringsArray {
    NSMutableArray <MKExcelCell *>*oneSheetAllCellArray = nil;
    
    if(sharedStringsArray.count <= 0) {
        return oneSheetAllCellArray;
    }
    
    NSDictionary *oneSheetData = sheetDic[@"oneSheetData"];
    
    if(ValidDict(oneSheetData)) {
        NSDictionary *worksheet = oneSheetData[@"worksheet"];
        
        if(ValidDict(worksheet)) {
            NSArray *mergeCellInfoArray = nil;
            
            NSDictionary *mergeCells = worksheet[@"mergeCells"];
            
            if(ValidDict(mergeCells)) {
                mergeCellInfoArray = [mergeCells objectForKey:@"mergeCell"];
            }
            
            NSDictionary *sheetData = worksheet[@"sheetData"];
            
            if(ValidDict(sheetData)) {
                NSArray *row = sheetData[@"row"];
                
                for(NSInteger i = 0 ; i < row.count ;i++)
                {
                    if(oneSheetAllCellArray == nil)
                    {
                        oneSheetAllCellArray = [[NSMutableArray alloc]init];
                    }
                    NSDictionary *oneRowDic = [row objectAtIndex:i];
                    
                    if(oneRowDic && [oneRowDic isKindOfClass:[NSDictionary class]])
                    {
                        id c = [oneRowDic objectForKey:@"c"];
                        
                        if ([c isKindOfClass:[NSDictionary class]]) {
                            //一列的情况
                            MKExcelCell *cell = [[MKExcelCell alloc]init];
                            
                            cell.cellDic = (NSDictionary *)c;
                            
                            if(cell.indexAnalysisSuccess && (sharedStringsArray.count > cell.stringValueIndex))
                            {
                                cell.stringValue = [sharedStringsArray objectAtIndex:cell.stringValueIndex];
                            }
                            

                            NSString *mergeCellColumAndRowStr = [self getMergeCellColumAndRowStrWithCell:cell mergeCellInfoArray:mergeCellInfoArray];
                            
                            cell.mergeCellColumAndRowStr = mergeCellColumAndRowStr;
                            
                            [oneSheetAllCellArray addObject:cell];
                        }else if ([c isKindOfClass:[NSArray class]]) {
                            NSArray *tempList = (NSArray *)c;
                            for(NSInteger j = 0 ; j < tempList.count ; j ++)
                            {
                                NSDictionary *cellDic = tempList[j];
                                
                                MKExcelCell *cell = [[MKExcelCell alloc]init];
                                
                                cell.cellDic = cellDic;
                                
                                if(cell.indexAnalysisSuccess && (sharedStringsArray.count > cell.stringValueIndex))
                                {
                                    cell.stringValue = [sharedStringsArray objectAtIndex:cell.stringValueIndex];
                                }
                                

                                NSString *mergeCellColumAndRowStr = [self getMergeCellColumAndRowStrWithCell:cell mergeCellInfoArray:mergeCellInfoArray];
                                
                                cell.mergeCellColumAndRowStr = mergeCellColumAndRowStr;
                                
                                [oneSheetAllCellArray addObject:cell];
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    return oneSheetAllCellArray;
}


+ (NSString *)getMergeCellColumAndRowStrWithCell:(MKExcelCell *)cell
                             mergeCellInfoArray:(NSArray *)mergeCellInfoArray {
    if (ValidDict(mergeCellInfoArray)) {
        return [self getMergeStrWithMergeInfoDic:mergeCellInfoArray column:cell.column row:cell.row];
    }
    if (ValidArray(mergeCellInfoArray)) {
        for(NSInteger i = 0 ;i < mergeCellInfoArray.count ;i ++) {
            NSDictionary *mergeInfoDic = mergeCellInfoArray[i];
            
            NSString *value = [self getMergeStrWithMergeInfoDic:mergeInfoDic column:cell.column row:cell.row];
            
            if(ValidStr(value)) {
                return value;
            }
        }
    }
    
    return @"";
}



+ (NSString *)getMergeStrWithMergeInfoDic:(NSDictionary *)mergeInfoDic
                                   column:(NSString *)column
                                      row:(NSInteger )row {
    if (!ValidDict(mergeInfoDic)) {
        return @"";
    }
    NSString *ref = mergeInfoDic[@"ref"];
    
    if(!ValidStr(ref)) {
        return @"";
    }

    NSArray *array = [ref componentsSeparatedByString:@":"]; //从字符A中分隔成2个元素的数组
    
    if (!ValidArray(array) && array.count != 2) {
        return @"";
    }
  
    NSString *startStr = array.firstObject;
    
    NSString *endStr = array.lastObject;
    
    NSInteger startRow = [[MKExcelCell getNumberFromStr:startStr] integerValue];
    
    NSInteger endRow = [[MKExcelCell getNumberFromStr:endStr] integerValue];
    
    NSString *tempStartColumnStr = [MKExcelCell getLetterFromStr:startStr];
    
    NSString *tempEndColumnStr = [MKExcelCell getLetterFromStr:endStr];
    
    if([tempStartColumnStr isEqualToString:tempEndColumnStr]) {
        //竖合并单元格
        if(startRow <= row && endRow >= row) {
            return startStr;
        }
    } else {
        //横合并单元格
        if(startRow == row) {
            if(tempStartColumnStr <= column && tempEndColumnStr >= column) {
                return startStr;
            }
        }
    }
    return @"";
}

@end
