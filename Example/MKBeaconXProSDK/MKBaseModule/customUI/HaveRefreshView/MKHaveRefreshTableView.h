//
//  MKHaveRefreshTableView.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/24.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKHaveRefreshViewProtocol.h"

@interface MKHaveRefreshTableView : UITableView<MKHaveRefreshViewProtocol>
/**
 顶部刷新图片数组
 */
@property (nonatomic, strong)NSArray <UIImage *>*idleImagesForHeader;
/**
 底部刷新图片数组
 */
@property (nonatomic, strong)NSArray <UIImage *>*idleImagesForFooter;

// 上拉下拉刷代理
@property (nonatomic,assign)id <MKHaveRefreshViewDelegate>refreshDelegate;

/**
 *  初始化，sourceType:指定显示的内容
 *
 */
- (instancetype)initWithFrame:(CGRect)frame sourceType:(PLHaveRefreshSourceType)sourceType;

- (void)footerAutomaticRefresh;

- (void)headerAutomaticRefresh;

@end
