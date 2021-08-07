//
//  MKSettingTextCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/7/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSettingTextCellModel : NSObject

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

#pragma mark ------------------------- 左侧label和icon配置 ---------------------------------

/// 左侧的icon，如果不写则左侧不显示
@property (nonatomic, strong)UIImage *leftIcon;

/// 左侧msg字体大小，默认15
@property (nonatomic, strong)UIFont *leftMsgTextFont;

/// 左侧msg字体颜色,默认#353535
@property (nonatomic, strong)UIColor *leftMsgTextColor;

/// 左侧msg
@property (nonatomic, copy)NSString *leftMsg;

@end

@interface MKSettingTextCell : MKBaseCell

+ (MKSettingTextCell *)initCellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong)MKSettingTextCellModel *dataModel;

@end

NS_ASSUME_NONNULL_END
