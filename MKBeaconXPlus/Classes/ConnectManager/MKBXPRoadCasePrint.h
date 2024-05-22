//
//  MKBXPRoadCasePrint.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2024/5/19.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXPPdfManager.h"

@interface MKBXPDataReportModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timestamp;

@property (nonatomic, copy)NSString *temperature;

@end

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPRoadCasePrint : NSObject

/// 绘制详细数据报告 并返回沙盒路径
/// - Parameter origenData: 原始数据
- (NSString *)drawDetailDataReport:(NSDictionary *)origenData;

/// 生成数据列表报告 pdf 并返回沙盒路径
/// - Parameter dataList: 数据列表
- (NSString *)drawDataListReport:(NSArray <MKBXPDataReportModel *>*)dataList;

@end

NS_ASSUME_NONNULL_END
