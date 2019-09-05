//
//  MKSlotBaseCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSlotBaseCell : UITableViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;

@property (nonatomic, strong, readonly)UIImageView *backView;

@property (nonatomic, assign)CGFloat cellHeight;

/**
 获取当前cell上面的信息。先查状态位@"code",当@"code":@"1"的时候说明数据都有，可以进行设置，
 当@"code":@"2"的时候，表明某些必填项没有设置，报错
 
 @return dic
 */
- (NSDictionary *)getContentData;

@end

NS_ASSUME_NONNULL_END
