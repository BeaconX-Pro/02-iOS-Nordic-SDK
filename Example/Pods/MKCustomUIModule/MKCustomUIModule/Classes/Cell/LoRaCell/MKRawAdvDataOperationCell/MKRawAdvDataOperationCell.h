//
//  MKRawAdvDataOperationCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/9.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKRawAdvDataOperationCellModel : NSObject

/// 开关状态
@property (nonatomic, assign)BOOL isOn;

/// 开关是否能用，默认YES
@property (nonatomic, assign)BOOL switchEnable;

/// 选中按钮状态
@property (nonatomic, assign)BOOL selected;

/// 选中按钮是否可用，默认YES
@property (nonatomic, assign)BOOL enabled;

/// 标签msg
@property (nonatomic, copy)NSString *msg;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKRawAdvDataOperationCellDelegate <NSObject>

/// +号按钮点击事件
- (void)mk_rawAdvDataOperation_addMethod;

/// -号按钮点击事件
- (void)mk_rawAdvDataOperation_subMethod;

/// 开关状态发生改变
/// @param isOn YES:打开，NO:关闭
- (void)mk_rawAdvDataOperation_switchStatusChanged:(BOOL)isOn;

/// 白名单按钮点击事件
/// @param selected YES:选中,NO:未选中
- (void)mk_rawAdvDataOperation_whiteListButtonSelected:(BOOL)selected;

@end

@interface MKRawAdvDataOperationCell : MKBaseCell

@property (nonatomic, strong)MKRawAdvDataOperationCellModel *dataModel;

@property (nonatomic, weak)id <MKRawAdvDataOperationCellDelegate>delegate;

+ (MKRawAdvDataOperationCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
