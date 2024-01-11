//
//  MKDeviceInfoCell.h
//  MKCustomUIModule_Example
//
//  Created by aa on 2024/1/9.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKDeviceInfoCellModel : NSObject

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

- (CGFloat)cellHeightWithContentWidth:(CGFloat)width;

@end

@interface MKDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKDeviceInfoCellModel *dataModel;

+ (MKDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
