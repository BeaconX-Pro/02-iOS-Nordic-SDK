//
//  MKDeviceInfoDfuCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDeviceInfoDfuCellModel : NSObject

/// cell唯一识别号
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

@property (nonatomic, copy)NSString *rightButtonTitle;

@end

@protocol MKDeviceInfoDfuCellDelegate <NSObject>

/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)mk_textButtonCell_buttonAction:(NSInteger)index;

@end

@interface MKDeviceInfoDfuCell : MKBaseCell

@property (nonatomic, strong)MKDeviceInfoDfuCellModel *dataModel;

@property (nonatomic, weak)id <MKDeviceInfoDfuCellDelegate>delegate;

+ (MKDeviceInfoDfuCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
