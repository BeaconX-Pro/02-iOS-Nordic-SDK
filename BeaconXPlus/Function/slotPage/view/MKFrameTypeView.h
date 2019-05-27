//
//  MKFrameTypeView.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKFrameTypeView : UIView

@property (nonatomic, copy)void (^frameTypeChangedBlock)(slotFrameType frameType);

/**
 当前选中的行数
 */
@property (nonatomic, assign)NSInteger index;

@end

NS_ASSUME_NONNULL_END
