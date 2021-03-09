//
//  MKBXPHTConfigNormalCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/4.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPHTConfigNormalCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@interface MKBXPHTConfigNormalCell : MKBaseCell

@property (nonatomic, strong)MKBXPHTConfigNormalCellModel *dataModel;

+ (MKBXPHTConfigNormalCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
