//
//  MKBXQuickSwitchCell.h
//  MKBeaconXProTLA_Example
//
//  Created by aa on 2021/8/16.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXQuickSwitchCellLayout : UICollectionViewFlowLayout

@end

@interface MKBXQuickSwitchCellModel : NSObject

@property (nonatomic, copy)NSString *titleMsg;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKBXQuickSwitchCellDelegate <NSObject>

- (void)mk_bx_quickSwitchStatusChanged:(BOOL)isOn index:(NSInteger)index;

@end

@interface MKBXQuickSwitchCell : UICollectionViewCell

@property (nonatomic, strong)MKBXQuickSwitchCellModel *dataModel;

@property (nonatomic, weak)id <MKBXQuickSwitchCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
