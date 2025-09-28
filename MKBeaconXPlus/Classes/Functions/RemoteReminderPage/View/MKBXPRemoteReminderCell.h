//
//  MKBXPRemoteReminderCell.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2022/3/3.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXPRemoteReminderCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKBXPRemoteReminderCellDelegate <NSObject>

- (void)bxd_remindButtonPressed:(NSInteger)index;

@end

@interface MKBXPRemoteReminderCell : MKBaseCell

@property (nonatomic, strong)MKBXPRemoteReminderCellModel *dataModel;

@property (nonatomic, weak)id <MKBXPRemoteReminderCellDelegate>delegate;

+ (MKBXPRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
