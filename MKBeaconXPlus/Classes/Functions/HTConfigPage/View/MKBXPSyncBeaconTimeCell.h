//
//  MKBXPSyncBeaconTimeCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPSyncBeaconTimeCellModel : NSObject

@property (nonatomic, copy)NSString *date;

@property (nonatomic, copy)NSString *time;

@end

@protocol MKBXPSyncBeaconTimeCellDelegate <NSObject>

- (void)bxp_needUpdateDate;

@end

@interface MKBXPSyncBeaconTimeCell : MKBaseCell

@property (nonatomic, weak)id <MKBXPSyncBeaconTimeCellDelegate>delegate;

@property (nonatomic, strong)MKBXPSyncBeaconTimeCellModel *dataModel;

+ (MKBXPSyncBeaconTimeCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
