//
//  MKBXPPdfManager.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2024/5/16.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPPdfManager.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@implementation MKBXPPdfManager

+ (instancetype)shared {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)drawImage:(UIImage *)image rect:(CGRect)rect {
    if (!image || ![image isKindOfClass:UIImage.class]) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context); // 保存当前图形上下文的状态
    
    CGContextTranslateCTM(context, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(context, rect, image.CGImage);
    
        
    CGContextRestoreGState(context); // 恢复保存的图形上下文状态，即还原坐标系
}

- (void)drawEmptySquareWithCGRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat components[] = {10,5};
    CGContextSetLineDash(context, 0, components, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

- (void)drawSquareWithCGRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 193.0/255.0, 193.0/255.0,193.0/255.0, 1.0);
    CGContextFillRect(context, rect);
    CGContextStrokePath(context);
}

- (void)printTableHeaderStr:(NSString *)printStr CGRect:(CGRect)rect {
    UIFont *Font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attribute = @{
                               NSFontAttributeName:Font,
                               NSParagraphStyleAttributeName:paragraphStyle,
                               NSForegroundColorAttributeName:[UIColor whiteColor]
                               };
    [printStr drawWithRect:CGRectMake(rect.origin.x + 5, rect.origin.y, rect.size.width - 2 * 5.f, rect.size.height)
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:attribute
                   context:nil];
}

- (void)printTipsStr:(NSString *)printStr CGRect:(CGRect)rect {
    UIFont *Font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{
                               NSFontAttributeName:Font,
                               NSParagraphStyleAttributeName:paragraphStyle,
                               };
    [printStr drawWithRect:CGRectMake(rect.origin.x + 5, rect.origin.y, rect.size.width - 2 * 5.f, rect.size.height)
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:attribute
                   context:nil];
}

- (void)printMessageStr:(NSString *)printStr CGRect:(CGRect)rect {
    UIFont *Font = [UIFont fontWithName:@"Helvetica" size:14];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attribute = @{
                               NSFontAttributeName:Font,
                               NSParagraphStyleAttributeName:paragraphStyle,
                               };
    [printStr drawWithRect:CGRectMake(rect.origin.x + 5, rect.origin.y, rect.size.width - 2 * 5.f, rect.size.height)
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:attribute
                   context:nil];
}

- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment {
    [self printStr:printStr
            CGRect:rect
              Font:font
      fontWithName:@"Helvetica-Bold"
       lineSpacing:lineSpacing
     lineBreakMode:lineBreakMode
         alignment:alignment];
}

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}

- (void)drawBoldLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}


- (void)drawDashLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1);
    CGFloat components[] = {2,2};
    CGContextSetLineDash(context, 0, components, 1);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}

- (void)drawDashBoldLineFromPoint:(CGPoint)from toPoint:(CGPoint)to {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGFloat components[] = {2,2};
    CGContextSetLineDash(context, 0, components, 2);
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    CGContextStrokePath(context);
}

- (void)drawBezierPath:(CGRect)rect
                  minY:(CGFloat)minY
                  maxY:(CGFloat)maxY
             pointList:(NSArray <NSDictionary *>*)pointList {

    // 创建日期格式化器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";

    // 创建排序描述符
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES comparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSDate *date1 = [dateFormatter dateFromString:obj1];
        NSDate *date2 = [dateFormatter dateFromString:obj2];
        return [date1 compare:date2];
    }];

    // 对温度数据进行排序
    NSArray<NSDictionary*> *sortedTemperatureList = [pointList sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // 计算时间间隔
    NSDate *earliestDate = [dateFormatter dateFromString:sortedTemperatureList.firstObject[@"time"]];
    NSDate *latestDate = [dateFormatter dateFromString:sortedTemperatureList.lastObject[@"time"]];
    NSTimeInterval interval = [latestDate timeIntervalSinceDate:earliestDate];
    
    //计算温度总间隔
    CGFloat totalY = maxY - minY;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 将线条样式设置为实线
    CGFloat components[] = {0}; // 空数组表示实线
    CGContextSetLineDash(context, 0, components, 0);
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    // 绘制曲线
    for (NSInteger i = 0; i < sortedTemperatureList.count; i++) {
        NSDictionary *data = sortedTemperatureList[i];
        NSDate *tempDate = [dateFormatter dateFromString:data[@"time"]];
        NSString *temperatureString = data[@"temperature"];
        NSTimeInterval tempInterval = [tempDate timeIntervalSinceDate:earliestDate];
        
        CGFloat x = rect.origin.x + ((tempInterval * rect.size.width) / interval);
        CGFloat y = rect.origin.y + ((maxY - [temperatureString floatValue]) * rect.size.height) / totalY;
        
        NSLog(@"%.2f",y);
        
        if (i == 0) {
            CGContextMoveToPoint(context, x, y);
        } else {
            CGContextAddLineToPoint(context, x, y);
        }
    }

    CGContextStrokePath(context);
}

- (void)drawRoundedRectWithRect:(CGRect)rect {
    // 绘制矩形边框
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat radius = 8.0f;
    // 左上角
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
    
    // 右上角（带圆弧）
    [path addArcWithCenter:CGPointMake(rect.origin.x + rect.size.width - radius, rect.origin.y + radius)
                    radius:radius
                startAngle:-M_PI_2
                  endAngle:0.0
                 clockwise:YES];
    
    // 右下角
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    
    // 左下角
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
    
    // 闭合路径
    [path closePath];
    
    // 设置填充颜色
    UIColor *fillColor = [UIColor lightGrayColor];
    [fillColor setFill];
    
    // 填充带圆角的矩形
    [path fill];
}

#pragma mark - private method
- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
    fontWithName:(NSString *)fontName
     lineSpacing:(CGFloat)lineSpacing
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment
{
    UIFont *Font = [UIFont fontWithName:fontName size:font];
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    paragraphStyle.alignment = alignment;
    if (lineSpacing > 0) {
        paragraphStyle.lineSpacing = lineSpacing;
    }
    NSDictionary *attribute = @{
                               NSFontAttributeName:Font,
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [printStr drawWithRect:rect 
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:attribute
                   context:nil];
}

- (void)printStr:(NSString *)printStr
          CGRect:(CGRect)rect
            Font:(CGFloat)font
   lineBreakMode:(NSLineBreakMode)lineBreakMode
       alignment:(NSTextAlignment)alignment {
    [self printStr:printStr
            CGRect:rect
              Font:font
      fontWithName:@"Helvetica-Bold"
       lineSpacing:0.0f
     lineBreakMode:lineBreakMode
         alignment:alignment];

}

@end
