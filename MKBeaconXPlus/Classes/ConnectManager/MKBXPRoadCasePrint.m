//
//  MKBXPRoadCasePrint.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2024/5/19.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPRoadCasePrint.h"

#import "MKMacroDefines.h"

/**
 * 字体高度单行等于字体的font+4，宽度通过sizeWithAttributes方法获取
 */

#define WIDTH 1240  ///< 页面的宽度

#define HEIGHT 1754 ///< 页面的高度

#define INIT_X 80    ///< 正文初始x值

#define INIT_Y 115    ///< 正文初始y值

#define TITLE_FONT 40.0f  ///< 标题字体大小

#define TITLE_Y 70.0f   ///< 标题Y值

#define TITLE_FONT_HEIGHT TITLE_FONT + 4.0f ///< 正文单行字体的高度

#define FONT 15.0f  ///< 正文字体大小

#define FONT_HEIGHT FONT + 4.0f ///< 正文单行字体的高度

#define TEXT_WIDTH(__X) [self getTextWidthWithText:__X]  ///< 文字宽度



#define LINESPACING 3.0f    ///< 多行文字行间距

#define TEXT_TWO_ROW_HEIGHT 2 * FONT + 4 + LINESPACING  ///< 两行文字带行间距的高度

#define PART_ONE_ROW_HEIGHT 40.0f   ///< 第一行高

#define PART_ONE_COLUMNWIDTH 80.0f   ///< 第一列宽

@implementation MKBXPDataReportModel
@end

@implementation MKBXPRoadCasePrint

/// 绘制详细数据报告 pdf
/// - Parameter origenData: 原始数据
- (NSString *)drawDetailDataReport:(NSDictionary *)origenData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *pathPDF =  [documentPath stringByAppendingPathComponent:@"Detail_Report.pdf"];
    
    NSMutableData *data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, NULL);
    
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);

    [self drawDetailDataReportPage];

    UIGraphicsEndPDFContext();
    
    if ([data writeToFile:pathPDF atomically:YES]) {
        return pathPDF;
    }
    
    return @"";
}

/// 生成数据列表报告 pdf
/// - Parameter dataList: 数据列表
- (NSString *)drawDataListReport:(NSArray <MKBXPDataReportModel *>*)dataList {
    //一页最多150条数据
    NSInteger batchSize = 150;
    NSInteger count = dataList.count;
    NSInteger groupCount = (count + batchSize - 1) / batchSize; // 计算小组的数量
        
    NSMutableArray <NSMutableArray *>*groupList = [NSMutableArray array];
    // 将数据按照列数分组
    for (NSInteger i = 0; i < groupCount; i++) {
        NSInteger startIndex = i * batchSize;
        NSInteger endIndex = MIN(startIndex + batchSize, count);
        NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
        [groupList addObject:[dataList subarrayWithRange:range]];
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *pathPDF =  [documentPath stringByAppendingPathComponent:@"dataList.pdf"];
    
    NSMutableData *data = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(data, CGRectZero, NULL);
    
    for (NSInteger i = 0; i < groupList.count; i ++) {
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 1240, 1754), nil);
        [self drawDataListPage:groupList[i] index:i];
    }

    UIGraphicsEndPDFContext();
    
    if ([data writeToFile:pathPDF atomically:YES]) {
        return pathPDF;
    }
    
    return @"";
}

#pragma mark - private method

- (void)drawDetailDataReportPage {
    //绘制标题
    [self drawPageTitle];
    
    //绘制Order表
    [self drawOrderTable];
    
    //绘制Logger Configuration表
    [self drawLoggerConfigTable];
    
    //绘制Logged Data Summary表
    [self drawLoggedDataSummaryTable];
    
    //绘制Statistical Summary表
    [self drawStatisticalSummaryTable];
    
    //绘制Alarm Summary表格
    [self drawAlarmSummaryTable];
    
    //绘制Notes
    [self drawNotesTable];
    
    //绘制图标
    [self drawTemperatureIllustrate];
    
    //绘制页脚
    [self drawPageFooter:@"Page 1"];
}

#define listTableTopLineOffsetY (INIT_Y + 20.f)

/// 绘制单页的列表数据
/// - Parameters:
///   - dataList: 数据列表
///   - index: 当前为第几页
- (void)drawDataListPage:(NSArray <MKBXPDataReportModel *>*)dataList index:(NSInteger)index {
    [self drawPageTitle];
    
    CGFloat startRowWidth = 80.f;
    CGFloat unitRowWidth = 120.f;
    CGFloat rowWidth = (WIDTH - 2 * INIT_X - 3 * startRowWidth - 3 * unitRowWidth) / 3;
    
    CGFloat headerRowHeight = 40.f;
    
    ///< 下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, listTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, listTableTopLineOffsetY)];
    ///< 下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, listTableTopLineOffsetY + headerRowHeight) toPoint:CGPointMake(WIDTH - INIT_X, listTableTopLineOffsetY + headerRowHeight)];

    
    ///< 第一行列左线
    CGFloat lineOffsetX = INIT_X;
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += startRowWidth;
    ///< 第二行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += rowWidth;
    ///< 第三行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += unitRowWidth;
    ///< 第四行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += startRowWidth;
    ///< 第五行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += rowWidth;
    ///< 第六行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += unitRowWidth;
    ///< 第七行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += startRowWidth;
    ///< 第八行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += rowWidth;
    ///< 第九行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    lineOffsetX += unitRowWidth;
    ///< 第十行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY) toPoint:CGPointMake(lineOffsetX, listTableTopLineOffsetY + headerRowHeight)];
    
    ///< 第一列第一行文字
    CGFloat firstRowOffsetX = INIT_X;
    [[MKBXPPdfManager shared] printTipsStr:@"#" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), startRowWidth, headerRowHeight)];
    ///< y第二列第一行文字
    firstRowOffsetX += startRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Time" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), rowWidth, headerRowHeight)];
    ///< 第三列第一行文字
    firstRowOffsetX += rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"°C/°F" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), unitRowWidth, headerRowHeight)];
    ///< 第四列第一行文字
    firstRowOffsetX += unitRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"#" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), startRowWidth, headerRowHeight)];
    ///< 第五列第一行文字
    firstRowOffsetX += startRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Time" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), rowWidth, headerRowHeight)];
    ///< 第六列第一行文字
    firstRowOffsetX += rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"°C/°F" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), unitRowWidth, headerRowHeight)];
    ///< 第七列第一行文字
    firstRowOffsetX += unitRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"#" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), startRowWidth, headerRowHeight)];
    ///< 第八列第一行文字
    firstRowOffsetX += startRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Time" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), startRowWidth, headerRowHeight)];
    ///< 第九列第一行文字
    firstRowOffsetX += rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"°C/°F" CGRect:CGRectMake(firstRowOffsetX, listTableTopLineOffsetY + ((headerRowHeight - FONT) / 2), startRowWidth, headerRowHeight)];
    
    //总共需要几组，每组占3列，50行共50个数据
    NSInteger batchSize = 50;
    NSInteger count = dataList.count;
    NSInteger groupCount = (count + batchSize - 1) / batchSize; // 计算小组的数量
        
    NSMutableArray <NSMutableArray *>*groupList = [NSMutableArray array];
    // 将数据按照列数分组
    for (NSInteger i = 0; i < groupCount; i++) {
        NSInteger startIndex = i * batchSize;
        NSInteger endIndex = MIN(startIndex + batchSize, count);
        NSRange range = NSMakeRange(startIndex, endIndex - startIndex);
        [groupList addObject:[dataList subarrayWithRange:range]];
    }
    CGFloat offsetY = listTableTopLineOffsetY + headerRowHeight;
    CGFloat dataRowHeight = 30.f;
    for (NSInteger i = 0; i < groupList.count; i ++) {
        
        NSMutableArray *tempList = groupList[i];
        
        for (NSInteger j = 0; j < tempList.count; j ++) {
            ///< 第一列文字
            CGFloat offsetX = INIT_X + i * (startRowWidth + rowWidth + unitRowWidth);
            CGFloat tempY = offsetY + j * dataRowHeight + ((dataRowHeight - FONT) / 2);
            MKBXPDataReportModel *dataModel = tempList[j];
            NSString *index = [NSString stringWithFormat:@"%ld",(long)dataModel.index];
            if (index.length == 1) {
                index = [@"0000" stringByAppendingString:index];
            }else if (index.length == 2) {
                index = [@"000" stringByAppendingString:index];
            }else if (index.length == 3) {
                index = [@"00" stringByAppendingString:index];
            }else if (index.length == 4) {
                index = [@"0" stringByAppendingString:index];
            }
            [[MKBXPPdfManager shared] printTipsStr:index CGRect:CGRectMake(offsetX, tempY, startRowWidth, dataRowHeight)];
            ///< 第二列文字
            offsetX += startRowWidth;
            [[MKBXPPdfManager shared] printTipsStr:dataModel.timestamp CGRect:CGRectMake(offsetX, tempY, rowWidth, headerRowHeight)];
            ///< 第三列文字
            offsetX += rowWidth;
            [[MKBXPPdfManager shared] printTipsStr:dataModel.temperature CGRect:CGRectMake(offsetX, tempY, unitRowWidth, headerRowHeight)];
        }
    }
    
    [self drawPageFooter:[NSString stringWithFormat:@"Page %ld",(long)(index + 1)]];
}

#define tableTitleHeight 20.f
#define shadowHeight (1.5 * tableTitleHeight)

#pragma mark - 页眉

- (void)drawPageTitle {
    UIImage *image = LOADICON(@"MKBeaconXPlus", @"MKBXPRoadCasePrint", @"deltaTrakIcon.png");
    CGFloat imageWidth = 200.f;
    [[MKBXPPdfManager shared] drawImage:image rect:CGRectMake(INIT_X, TITLE_Y, imageWidth, TITLE_FONT_HEIGHT)];
    [[MKBXPPdfManager shared] printStr:@"FlashLink® PDF Report" CGRect:CGRectMake(INIT_X + imageWidth + 10.f, TITLE_Y, WIDTH - 2 * INIT_X - 100.f, TITLE_FONT_HEIGHT) Font:45.f lineSpacing:0.0f lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    
    ///< 第一行线
    [[MKBXPPdfManager shared] drawBoldLineFromPoint:CGPointMake(INIT_X, INIT_Y) toPoint:CGPointMake(WIDTH - INIT_X, INIT_Y)];
}

#pragma mark - 页脚

- (void)drawPageFooter:(NSString *)footerMsg {
    ///< 第一行线
    [[MKBXPPdfManager shared] drawBoldLineFromPoint:CGPointMake(INIT_X, HEIGHT - 3 * tableTitleHeight) toPoint:CGPointMake(WIDTH - INIT_X, HEIGHT - 3 * tableTitleHeight)];
    
    [[MKBXPPdfManager shared] printStr:footerMsg CGRect:CGRectMake(0, HEIGHT - 3 * tableTitleHeight, WIDTH, 2 * tableTitleHeight) Font:20 lineSpacing:0.0f lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}


#pragma mark - 第一页

/*
    绘制Order表格
 */
#define orderWidth (WIDTH / 2)
#define orderLeftMsgRowWidth 125.f
#define orderTableOffsetY (INIT_Y + 20.f)
#define orderTableTopLineOffsetY (orderTableOffsetY + shadowHeight)
#define orderRightMsgOffsetX (INIT_X + orderLeftMsgRowWidth + 3.f)
#define orderRightMsgWidth (orderWidth - INIT_X - 5.f - 3.f - orderLeftMsgRowWidth)
- (void)drawOrderTable {
    
    ///< Order阴影
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(INIT_X - 1, orderTableOffsetY, PART_ONE_COLUMNWIDTH + 10.f, shadowHeight)];
    ///< Order
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Order" CGRect:CGRectMake(INIT_X, orderTableOffsetY + (shadowHeight - tableTitleHeight) / 2, PART_ONE_COLUMNWIDTH, tableTitleHeight)];
    ///< Order下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY)];
    ///< Order下方左侧第一行文字
//    [[MKBXPPdfManager shared] printTipsStr:@"Shipper/Carrier" CGRect:CGRectMake(INIT_X, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderLeftMsgRowWidth, TEXT_TWO_ROW_HEIGHT)];
    [[MKBXPPdfManager shared] printStr:@"Shipper/Carrier" CGRect:CGRectMake(INIT_X, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderLeftMsgRowWidth, TEXT_TWO_ROW_HEIGHT) Font:15 lineSpacing:0.0f lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
    ///< Order下方右侧第一行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(orderRightMsgOffsetX, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderRightMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Order下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT)];
    ///< Order下方左侧第二行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Receiver" CGRect:CGRectMake(INIT_X, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderLeftMsgRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Order下方右侧第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(orderRightMsgOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderRightMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Order下方第三行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Order下方左侧第三行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Product" CGRect:CGRectMake(INIT_X, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderLeftMsgRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Order下方右侧第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(orderRightMsgOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderRightMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Order下方第四行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT)];
    ///< Order下方左侧第四行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Signature" CGRect:CGRectMake(INIT_X, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderLeftMsgRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Order下方右侧第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(orderRightMsgOffsetX, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), orderRightMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Order下方第五行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    
    ///< Order第一行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY) toPoint:CGPointMake(INIT_X, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    ///< Order第二行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + orderLeftMsgRowWidth, orderTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + orderLeftMsgRowWidth, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    ///< Order第三行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY) toPoint:CGPointMake(orderWidth - 5.f, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
}

/*
    绘制Logger Configuration表格
 */
#define loggerConfigWidth (WIDTH / 2)
#define loggerOffsetX (loggerConfigWidth + 5)
- (void)drawLoggerConfigTable {
    CGFloat tipMsgWidth = 100.f;
    CGFloat msgWidth = (loggerConfigWidth - INIT_X - 5.f - 2 * tipMsgWidth) / 2;
    CGFloat leftMsgOffsetX = loggerConfigWidth + 5.f + tipMsgWidth;
    CGFloat rightTipMsgOffsetX = leftMsgOffsetX + msgWidth;
    CGFloat rightMsgOffsetX = leftMsgOffsetX + msgWidth + tipMsgWidth;
        
    ///< Logger Configuration阴影
    CGFloat shadowWidth = 2.5 * PART_ONE_COLUMNWIDTH;
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(loggerConfigWidth + 4.f, orderTableOffsetY, shadowWidth, shadowHeight)];
    ///< Logger Configuration
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Logger Configuration" CGRect:CGRectMake(loggerConfigWidth + 5.f, orderTableOffsetY + (shadowHeight - tableTitleHeight) / 2, shadowWidth, tableTitleHeight)];
    
    ///< Logger Configuration下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY)];
    ///< Logger Configuration下方左侧Tips第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Trip #" CGRect:CGRectMake(loggerOffsetX, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧第一行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(leftMsgOffsetX, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧Tips第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Start Delay" CGRect:CGRectMake(rightTipMsgOffsetX, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧第一行文字
    [[MKBXPPdfManager shared] printMessageStr:@"000 Days 00 Hrs 00 Mins" CGRect:CGRectMake(rightMsgOffsetX, orderTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logger Configuration下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧Tips第二行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Model #" CGRect:CGRectMake(loggerOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"F0255" CGRect:CGRectMake(leftMsgOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧Tips第二行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Alarm Skip" CGRect:CGRectMake(rightTipMsgOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"0 pts" CGRect:CGRectMake(rightMsgOffsetX, orderTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logger Configuration下方第三行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧Tips第三行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Interval" CGRect:CGRectMake(loggerOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 05 Secs" CGRect:CGRectMake(leftMsgOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧Tips第三行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Alarm Delay" CGRect:CGRectMake(rightTipMsgOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方右侧第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"000 Days 00 Hrs 00 Mins" CGRect:CGRectMake(rightMsgOffsetX, orderTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logger Configuration下方第四行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧Tips第四行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Time Zone" CGRect:CGRectMake(loggerOffsetX, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), tipMsgWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logger Configuration下方左侧第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"GMT +00" CGRect:CGRectMake(leftMsgOffsetX, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), msgWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logger Configuration下方第五行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(rightTipMsgOffsetX, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    
    
    ///< Logger Configuration第一列线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY) toPoint:CGPointMake(loggerOffsetX, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration第二列线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX + tipMsgWidth, orderTableTopLineOffsetY) toPoint:CGPointMake(loggerOffsetX + tipMsgWidth, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration第三列线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX + tipMsgWidth + msgWidth, orderTableTopLineOffsetY) toPoint:CGPointMake(loggerOffsetX + tipMsgWidth + msgWidth, orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration第四列线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(loggerOffsetX + 2 * tipMsgWidth + msgWidth, orderTableTopLineOffsetY) toPoint:CGPointMake(loggerOffsetX + 2 * tipMsgWidth + msgWidth, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT)];
    ///< Logger Configuration第五列线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, orderTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT)];
}

/*
    绘制Loggged Data Summary表格
 */
#define loggedTableOffsetY (orderTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + 20.f)
#define loggedTableTopLineOffsetY (loggedTableOffsetY + shadowHeight)
- (void)drawLoggedDataSummaryTable {
    CGFloat rowWidth = (WIDTH - 2 * INIT_X) / 5;
        
    ///< Logged Data Summary阴影
    CGFloat shadowWidth = 2.5 * PART_ONE_COLUMNWIDTH;
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(INIT_X - 1, loggedTableOffsetY, shadowWidth, shadowHeight)];
    ///< Logged Data Summary
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Logged Data Summary" CGRect:CGRectMake(INIT_X, loggedTableOffsetY + (shadowHeight - tableTitleHeight) / 2, shadowWidth, tableTitleHeight)];
    
    ///< Logged Data Summary下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, loggedTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, loggedTableTopLineOffsetY)];
    ///< Logged Data Summary下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary下方第三行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    
    ///< Logged Data Summary第一行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary第二行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + rowWidth, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + rowWidth, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary第三行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 2 * rowWidth, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 2 * rowWidth, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary第四行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 3 * rowWidth, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 3 * rowWidth, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary第五行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 4 * rowWidth, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 4 * rowWidth, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Logged Data Summary第六行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 5 * rowWidth, loggedTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 5 * rowWidth, loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    
    ///< Logged Data Summary第一列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Type" CGRect:CGRectMake(INIT_X, loggedTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logged Data Summary第一列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Normal" CGRect:CGRectMake(INIT_X, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logged Data Summary第二列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Start Time" CGRect:CGRectMake(INIT_X + rowWidth, loggedTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logged Data Summary第二列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"06/13/2019 12:51:18" CGRect:CGRectMake(INIT_X + rowWidth, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logged Data Summary第三列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Stop Time" CGRect:CGRectMake(INIT_X + 2 * rowWidth, loggedTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logged Data Summary第三列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"06/13/2019 14:06:08" CGRect:CGRectMake(INIT_X + 2 * rowWidth, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logged Data Summary第四列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Trip Length" CGRect:CGRectMake(INIT_X + 3 * rowWidth, loggedTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logged Data Summary第四列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"01 Hrs 14 Mins 50 Secs" CGRect:CGRectMake(INIT_X + 3 * rowWidth, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Logged Data Summary第五列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Data Points" CGRect:CGRectMake(INIT_X + 4 * rowWidth, loggedTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Logged Data Summary第五列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"899" CGRect:CGRectMake(INIT_X + 4 * rowWidth, loggedTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
}

/*
    绘制Statistical Summary表格
 */
#define statisticalTableOffsetY (loggedTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + 20.f)
#define statisticalTableTopLineOffsetY (statisticalTableOffsetY + shadowHeight)
#define thirdLineMultiple 2.5
- (void)drawStatisticalSummaryTable {
    CGFloat lastRowWidth = 230.f;
    CGFloat rowWidth = (WIDTH - 2 * INIT_X - 2 * lastRowWidth) / 4;
    
    ///< Statistical Summary阴影
    CGFloat shadowWidth = 2.5 * PART_ONE_COLUMNWIDTH;
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(INIT_X - 1, statisticalTableOffsetY, shadowWidth, shadowHeight)];
    ///< Statistical Summary
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Statistical Summary" CGRect:CGRectMake(INIT_X, statisticalTableOffsetY + (shadowHeight - tableTitleHeight) / 2, shadowWidth, tableTitleHeight)];
            
    ///< Statistical Summary下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, statisticalTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, statisticalTableTopLineOffsetY)];
    ///< Statistical Summary下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT)];
    ///< Statistical Summary下方第三行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, statisticalTableTopLineOffsetY + thirdLineMultiple * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, statisticalTableTopLineOffsetY + thirdLineMultiple * PART_ONE_ROW_HEIGHT)];
    
    ///< Statistical Summary第一行列左线
    ///< 竖线
    for (NSInteger i = 0; i < 5; i ++) {
        [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + i * rowWidth, statisticalTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + i * rowWidth, statisticalTableTopLineOffsetY + thirdLineMultiple * PART_ONE_ROW_HEIGHT)];
    }
    
    ///< Statistical Summary第六行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 4 * rowWidth + lastRowWidth, statisticalTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 4 * rowWidth + lastRowWidth, statisticalTableTopLineOffsetY + thirdLineMultiple * PART_ONE_ROW_HEIGHT)];
    ///< Statistical Summary第七行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 4 * rowWidth + 2 * lastRowWidth, statisticalTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 4 * rowWidth + 2 * lastRowWidth, statisticalTableTopLineOffsetY + thirdLineMultiple * PART_ONE_ROW_HEIGHT)];
    
    ///< Statistical Summary第一列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Maximum" CGRect:CGRectMake(INIT_X, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第一列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"29.5°C / 85.1°F" CGRect:CGRectMake(INIT_X, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 8.f, rowWidth, 40.f)];
    ///< Statistical Summary第一列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"06/13/2019 12:52:28" CGRect:CGRectMake(INIT_X, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 40.f, rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Statistical Summary第二列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Minimum" CGRect:CGRectMake(INIT_X + rowWidth, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第二列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"23.8°C / 74.8°F" CGRect:CGRectMake(INIT_X + rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 8.f, rowWidth, 40.f)];
    ///< Statistical Summary第二列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"06/13/2019 13:08:03" CGRect:CGRectMake(INIT_X + rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 40.f, rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Statistical Summary第三列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Average" CGRect:CGRectMake(INIT_X + 2 * rowWidth, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第三列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"24.0°C / 75.2°F" CGRect:CGRectMake(INIT_X + 2 * rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((1.5 * PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    
    ///< Statistical Summary第四列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Degree Minutes" CGRect:CGRectMake(INIT_X + 3 * rowWidth, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第四列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"    ---.-°C x           Mins" CGRect:CGRectMake(INIT_X + 3 * rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 8.f, rowWidth, 40.f)];
    ///< Statistical Summary第四列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"    ---.-°F x           Mins" CGRect:CGRectMake(INIT_X + 3 * rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 40.f, rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Statistical Summary第五列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Mean +-- Standard Deviation" CGRect:CGRectMake(INIT_X + 4 * rowWidth, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), lastRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第五列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"24.0°C +-- 0.4°C" CGRect:CGRectMake(INIT_X + 4 * rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 8.f, lastRowWidth, 40.f)];
    ///< Statistical Summary第五列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"75.2°F +-- 0.7°F" CGRect:CGRectMake(INIT_X + 4 * rowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 40.f, lastRowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Statistical Summary第六列第一行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Mean Kinetic Temperature" CGRect:CGRectMake(INIT_X + 4 * rowWidth + lastRowWidth, statisticalTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), lastRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Statistical Summary第六列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"24.0°C / 75.2°F" CGRect:CGRectMake(INIT_X + 4 * rowWidth + lastRowWidth, statisticalTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((1.5 * PART_ONE_ROW_HEIGHT - FONT) / 2), lastRowWidth, TEXT_TWO_ROW_HEIGHT)];
}

/*
    绘制Alarm Summary表格
 */
#define alarmTableOffsetY (statisticalTableTopLineOffsetY + 3.5 * PART_ONE_ROW_HEIGHT)
#define alarmTableTopLineOffsetY (alarmTableOffsetY + shadowHeight)
- (void)drawAlarmSummaryTable {
    CGFloat eventRowWidth = 70.f;
    CGFloat statusRowWidth = 120.f;
    CGFloat firstEventRowWidth = 100.f;
    CGFloat rowWidth = (WIDTH - 2 * INIT_X - eventRowWidth - statusRowWidth - firstEventRowWidth) / 4;
    
    ///< Alarm Summary阴影
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(INIT_X - 1, alarmTableOffsetY, PART_ONE_COLUMNWIDTH + 10.f, shadowHeight)];
    ///< Alarm Summary
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Alarm Summary" CGRect:CGRectMake(INIT_X, alarmTableOffsetY + (shadowHeight - tableTitleHeight) / 2, PART_ONE_COLUMNWIDTH, tableTitleHeight)];
        
    ///< 绘制行线
    for (NSInteger i = 0; i < 7; i ++) {
        [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, alarmTableTopLineOffsetY + i * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, alarmTableTopLineOffsetY + i * PART_ONE_ROW_HEIGHT)];
    }
        
    ///< Alarm Summary第一行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第二行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + rowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + rowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第三行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 2 * rowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 2 * rowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第四行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 3 * rowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 3 * rowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第五行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 3 * rowWidth + firstEventRowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 3 * rowWidth + firstEventRowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第六行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 3 * rowWidth + firstEventRowWidth + eventRowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 3 * rowWidth + firstEventRowWidth + eventRowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第七行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X + 4 * rowWidth + firstEventRowWidth + eventRowWidth, alarmTableTopLineOffsetY) toPoint:CGPointMake(INIT_X + 4 * rowWidth + firstEventRowWidth + eventRowWidth, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第八行列左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(WIDTH - INIT_X, alarmTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT)];
    
    ///< Alarm Summary第一列第一行文字
    CGFloat firstRowOffsetX = INIT_X;
    [[MKBXPPdfManager shared] printTipsStr:@"" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第一列第二行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Ideal Range" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第一列第三行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Extreme High Alarm" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第一列第四行文字
    [[MKBXPPdfManager shared] printTipsStr:@"High Alarm" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第一列第五行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Low Alarm" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第一列第六行文字
    [[MKBXPPdfManager shared] printTipsStr:@"Extreme Low Alarm" CGRect:CGRectMake(firstRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    ///< Alarm Summary第二列第一行文字
    CGFloat secondRowOffsetX = firstRowOffsetX + rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Limits" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第二列第二行上文字
    [[MKBXPPdfManager shared] printMessageStr:@"≥ -25.0°C/-13.0°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 5.f, rowWidth, 15.f)];
    ///< Alarm Summary第二列第二行下文字
    [[MKBXPPdfManager shared] printMessageStr:@"≤ 30.0°C/ 86.0°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + 5.f + 15.f, rowWidth, 15.f)];
    ///< Alarm Summary第二列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Over 33.0°C/ 91.4°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第二列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Over 30.0°C/ 86.0°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第二列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Under -25.0°C/-13.0°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第二列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Under -30.0°C/-22.0°F" CGRect:CGRectMake(secondRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    
    
    ///< Alarm Summary第三列第一行文字
    CGFloat thirdRowOffsetX = secondRowOffsetX + rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Cumulative Limit" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第三列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"Unlimited" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第三列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 50 Secs" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第三列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 45 Secs" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第三列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 40 Secs" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第三列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 35 Secs" CGRect:CGRectMake(thirdRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    
    ///< Alarm Summary第四列第一行文字
    CGFloat forthRowOffsetX = thirdRowOffsetX + rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"First Event" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第四列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第四列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"NONE" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第四列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"NONE" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第四列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"NONE" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第四列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"NONE" CGRect:CGRectMake(forthRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), firstEventRowWidth, PART_ONE_ROW_HEIGHT)];
    
    ///< Alarm Summary第五列第一行文字
    CGFloat fivthRowOffsetX = forthRowOffsetX + firstEventRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Event" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第五列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第五列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"0" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第五列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"0" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第五列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"0" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第五列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"0" CGRect:CGRectMake(fivthRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), eventRowWidth, PART_ONE_ROW_HEIGHT)];
    
    ///< Alarm Summary第六列第一行文字
    CGFloat sixthRowOffsetX = fivthRowOffsetX + eventRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Total Time" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第六列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第六列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 00 Secs" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第六列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 00 Secs" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第六列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 00 Secs" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第六列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"00 Hrs 00 Mins 00 Secs" CGRect:CGRectMake(sixthRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), rowWidth, PART_ONE_ROW_HEIGHT)];
    
    ///< Alarm Summary第七列第一行文字
    CGFloat seventhRowOffsetX = sixthRowOffsetX + rowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"Alarm Status" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, TEXT_TWO_ROW_HEIGHT)];
    ///< Alarm Summary第七列第二行文字
    [[MKBXPPdfManager shared] printMessageStr:@"" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第七列第三行文字
    [[MKBXPPdfManager shared] printMessageStr:@"✅" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第七列第四行文字
    [[MKBXPPdfManager shared] printMessageStr:@"✅" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + 3 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第七列第五行文字
    [[MKBXPPdfManager shared] printMessageStr:@"✅" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + 4 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, PART_ONE_ROW_HEIGHT)];
    ///< Alarm Summary第七列第六行文字
    [[MKBXPPdfManager shared] printMessageStr:@"✅" CGRect:CGRectMake(seventhRowOffsetX, alarmTableTopLineOffsetY + 5 * PART_ONE_ROW_HEIGHT + ((PART_ONE_ROW_HEIGHT - FONT) / 2), statusRowWidth, PART_ONE_ROW_HEIGHT)];
}

/*
    绘制Notes Summary表格
 */
#define noteTableOffsetY (alarmTableTopLineOffsetY + 6 * PART_ONE_ROW_HEIGHT + 20.f)
#define noteTableTopLineOffsetY (noteTableOffsetY + shadowHeight)
- (void)drawNotesTable {
    ///< Notes阴影
    [[MKBXPPdfManager shared] drawRoundedRectWithRect:CGRectMake(INIT_X - 1, noteTableOffsetY, PART_ONE_COLUMNWIDTH + 10.f, shadowHeight)];
    ///< Notes
    [[MKBXPPdfManager shared] printTableHeaderStr:@"Notes" CGRect:CGRectMake(INIT_X, noteTableOffsetY + (shadowHeight - tableTitleHeight) / 2, PART_ONE_COLUMNWIDTH, tableTitleHeight)];
    
    ///< Notes下方第一行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, noteTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, noteTableTopLineOffsetY)];
    ///< Notes下方第二行线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, noteTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT) toPoint:CGPointMake(WIDTH - INIT_X, noteTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    
    ///< Notes左线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(INIT_X, noteTableTopLineOffsetY) toPoint:CGPointMake(INIT_X, noteTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
    ///< Notes右线
    [[MKBXPPdfManager shared] drawLineFromPoint:CGPointMake(WIDTH - INIT_X, noteTableTopLineOffsetY) toPoint:CGPointMake(WIDTH - INIT_X, noteTableTopLineOffsetY + 2 * PART_ONE_ROW_HEIGHT)];
}

#define temperatureTopLineOffsetY (noteTableTopLineOffsetY + 2.5 * PART_ONE_ROW_HEIGHT)

- (void)drawTemperatureIllustrate {
    //绘制标题
//    [self drawPageTitle];
    
    NSArray *cDataList = @[@"30.8",@"30.0",@"29.2",@"28.4",@"27.6",@"26.8",@"26.0",@"25.2",@"24.4",@"23.6",@"22.8"];
    NSArray *fDataList = @[@"87.4",@"86.0",@"84.5",@"83.1",@"81.6",@"80.2",@"78.8",@"77.3",@"75.9",@"74.4",@"73.0"];
    
    CGFloat unitRowWidth = 50.f;
    CGFloat unitRowHeight = 40.f;
    
    ///< 第一列第一行文字
    CGFloat firstRowOffsetX = INIT_X;
    [[MKBXPPdfManager shared] printTipsStr:@"[°C]" CGRect:CGRectMake(firstRowOffsetX, temperatureTopLineOffsetY + ((unitRowHeight - FONT) / 2), unitRowWidth, unitRowHeight)];
    
    ///< 第二列第一行文字
    CGFloat secondRowOffsetX = firstRowOffsetX + unitRowWidth;
    [[MKBXPPdfManager shared] printTipsStr:@"[°F]" CGRect:CGRectMake(secondRowOffsetX, temperatureTopLineOffsetY + ((unitRowHeight - FONT) / 2), unitRowWidth, unitRowHeight)];
    
    ///< 最右边顶部文字
    [[MKBXPPdfManager shared] printTipsStr:@"TIME SCALE [00 Hrs 07 Mins 29 Secs ]" CGRect:CGRectMake(WIDTH - INIT_X - 340.f - unitRowWidth - 5.f, temperatureTopLineOffsetY + ((unitRowHeight - FONT) / 2), 340, unitRowHeight)];
    
    ///< 绘制矩形外框
    CGFloat squareOffsetX = secondRowOffsetX + unitRowWidth + 5.f;
    CGFloat squareOffsetY = temperatureTopLineOffsetY + unitRowHeight + ((unitRowHeight - FONT) / 2) + 20.f;
    CGFloat squareWidth = WIDTH - 2 * INIT_X - firstRowOffsetX - unitRowWidth;
    CGFloat dataRowWidth = squareWidth / 10.f;
    CGFloat dataRowHeight = 40.f;
    CGRect squareRect = CGRectMake(squareOffsetX, squareOffsetY, squareWidth, dataRowHeight * 10);
    [[MKBXPPdfManager shared] drawEmptySquareWithCGRect:squareRect];
    
    CGFloat horizontalDashLineOffsetY = squareOffsetY + dataRowHeight;
    ///< 绘制第一行加粗红色虚线
    [[MKBXPPdfManager shared] drawDashBoldLineFromPoint:CGPointMake(squareOffsetX, horizontalDashLineOffsetY) toPoint:CGPointMake(squareOffsetX + squareWidth, horizontalDashLineOffsetY)];
    //绘制第一列第一行文字
    CGFloat dataValueOffsetY = squareOffsetY - (unitRowHeight / 2);
    [[MKBXPPdfManager shared] printMessageStr:cDataList[0] CGRect:CGRectMake(firstRowOffsetX, dataValueOffsetY, unitRowWidth, unitRowHeight)];
    //绘制第二列第一行文字
    [[MKBXPPdfManager shared] printMessageStr:fDataList[0] CGRect:CGRectMake(secondRowOffsetX, dataValueOffsetY, unitRowWidth, unitRowHeight)];

    ///< 绘制九行虚线 + 左侧两列数据值
    for (NSInteger i = 1; i < 10; i ++) {
        CGFloat tempOffsetY = squareOffsetY + i * dataRowHeight;
        [[MKBXPPdfManager shared] drawDashLineFromPoint:CGPointMake(squareOffsetX, tempOffsetY) toPoint:CGPointMake(squareOffsetX + squareWidth, tempOffsetY)];
        CGFloat tempDataValueOffsetY = dataValueOffsetY + i * dataRowHeight;
        [[MKBXPPdfManager shared] printMessageStr:cDataList[i] CGRect:CGRectMake(firstRowOffsetX, tempDataValueOffsetY, unitRowWidth, unitRowHeight)];
        [[MKBXPPdfManager shared] printMessageStr:fDataList[i] CGRect:CGRectMake(secondRowOffsetX, tempDataValueOffsetY, unitRowWidth, unitRowHeight)];
    }
    
    //绘制第一列最后一行文字
    [[MKBXPPdfManager shared] printMessageStr:cDataList[10] CGRect:CGRectMake(firstRowOffsetX, dataValueOffsetY + 10 * dataRowHeight, unitRowWidth, unitRowHeight)];
    //绘制第二列最后一行文字
    [[MKBXPPdfManager shared] printMessageStr:fDataList[10] CGRect:CGRectMake(secondRowOffsetX, dataValueOffsetY + 10 * dataRowHeight, unitRowWidth, unitRowHeight)];
    
    ///< 绘制九列虚线
    for (NSInteger i = 1; i < 10; i ++) {
        CGFloat tempOffsetX = squareOffsetX + i * dataRowWidth;
        [[MKBXPPdfManager shared] drawDashLineFromPoint:CGPointMake(tempOffsetX, squareOffsetY) toPoint:CGPointMake(tempOffsetX, squareOffsetY + dataRowHeight * 10)];
    }
    
    NSArray <NSDictionary *>* temperatureList = @[@{@"time":@"05/13/2024 12:51:18",@"temperature":@"75.9"},
                                                  @{@"time":@"05/13/2024 12:52:18",@"temperature":@"78.9"},
                                                  @{@"time":@"05/13/2024 12:53:18",@"temperature":@"80.9"},
                                                  @{@"time":@"05/13/2024 12:54:18",@"temperature":@"85.9"},
                                                  @{@"time":@"05/13/2024 12:55:18",@"temperature":@"77.9"},
                                                  @{@"time":@"05/13/2024 12:56:18",@"temperature":@"75.9"},
                                                  @{@"time":@"05/13/2024 12:57:18",@"temperature":@"76.9"},
                                                  @{@"time":@"05/13/2024 13:21:18",@"temperature":@"74.9"},
                                                  @{@"time":@"05/13/2024 13:23:18",@"temperature":@"77.9"},
                                                  @{@"time":@"05/13/2024 13:23:48",@"temperature":@"83.9"},
                                                  @{@"time":@"05/13/2024 13:24:58",@"temperature":@"77.9"},
                                                  @{@"time":@"05/13/2024 13:41:18",@"temperature":@"86.9"},
                                                  @{@"time":@"05/13/2024 13:51:18",@"temperature":@"77.9"},
                                                  @{@"time":@"05/13/2024 13:53:18",@"temperature":@"74.9"},
                                                  @{@"time":@"05/13/2024 14:06:08",@"temperature":@"74.9"}];
    [[MKBXPPdfManager shared] drawBezierPath:squareRect minY:[fDataList.lastObject floatValue] maxY:[fDataList.firstObject floatValue] pointList:temperatureList];
    
    //绘制页脚
//    [self drawPageFooter:@"Page 3"];
}

///< 获取字体大小18的宽度
- (CGFloat)getTextWidthWithText:(NSString *)text
{
    return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STSong" size:FONT], NSFontAttributeName, nil]].width;
}

@end
