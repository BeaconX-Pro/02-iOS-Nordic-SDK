//
//  MKLoRaAdvancedSettingCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2021/1/8.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKLoRaAdvancedSettingCellModel : NSObject

/// 开关状态
@property (nonatomic, assign)BOOL isOn;

/// 开关是否可改变状态,默认YES
@property (nonatomic, assign)BOOL switchEnable;

/// 背景颜色，默认白色
@property (nonatomic, strong)UIColor *contentColor;

@end

@protocol MKLoRaAdvancedSettingCellDelegate <NSObject>

- (void)mk_loraSetting_advanceCell_switchStatusChanged:(BOOL)isOn;

@end

@interface MKLoRaAdvancedSettingCell : MKBaseCell

@property (nonatomic, strong)MKLoRaAdvancedSettingCellModel *dataModel;

@property (nonatomic, weak)id <MKLoRaAdvancedSettingCellDelegate>delegate;

+ (MKLoRaAdvancedSettingCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
