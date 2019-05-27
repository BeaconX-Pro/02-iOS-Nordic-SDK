//
//  MKAdvContentBaseCell.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKSlotBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKAdvContentBaseCell : MKSlotBaseCell

/**
 子类控件距离顶部最小距离
 */
@property (nonatomic, assign)CGFloat minTopOffset;

/**
 子控件距离左右最小距离
 */
@property (nonatomic, assign)CGFloat minOffset_X;

@end

NS_ASSUME_NONNULL_END
