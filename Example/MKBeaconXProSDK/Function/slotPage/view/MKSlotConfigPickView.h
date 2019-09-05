//
//  MKSlotConfigPickView.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/30.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKSlotConfigPickView : UIView

@property (nonatomic, strong)NSArray <NSString *>*dataList;
- (void)showPickViewWithIndex:(NSInteger)row block:(void (^)(NSInteger currentRow))block;

@end

NS_ASSUME_NONNULL_END
