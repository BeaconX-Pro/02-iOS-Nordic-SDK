//
//  MKBXSlotConfigURLCell.h
//  MKBeaconXCustomUI_Example
//
//  Created by aa on 2021/8/13.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXSlotConfigCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXSlotConfigURLCellModel : NSObject

/// 广播的数据
@property (nonatomic, strong)NSData *advData;

/// 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
@property (nonatomic, assign)NSInteger urlType;

@property (nonatomic, copy)NSString *urlContent;

@end

@interface MKBXSlotConfigURLCell : MKBaseCell<MKBXSlotConfigCellProtocol>

@property (nonatomic, strong)MKBXSlotConfigURLCellModel *dataModel;

+ (MKBXSlotConfigURLCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
