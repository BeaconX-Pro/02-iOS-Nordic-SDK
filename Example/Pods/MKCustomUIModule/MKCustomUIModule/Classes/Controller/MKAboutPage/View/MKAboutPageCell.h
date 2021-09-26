//
//  MKAboutPageCell.h
//  MokoLifeX_Example
//
//  Created by aa on 2021/8/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class MKAboutCellModel;
@interface MKAboutPageCell : MKBaseCell

@property (nonatomic, strong)MKAboutCellModel *dataModel;

+ (MKAboutPageCell *)initCellWithTableView:(UITableView *)table;

@end

NS_ASSUME_NONNULL_END
