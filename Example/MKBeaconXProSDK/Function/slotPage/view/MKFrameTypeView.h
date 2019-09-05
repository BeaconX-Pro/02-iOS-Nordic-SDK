//
//  MKFrameTypeView.h
//  BeaconXPlus
//
//  Created by aa on 2019/5/27.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKFrameTypeViewDelegate <NSObject>

- (void)frameTypeChangedMethod:(slotFrameType)frameType;

@end

@interface MKFrameTypeView : UIView

@property (nonatomic, weak)id <MKFrameTypeViewDelegate>delegate;

- (void)updateFrameType:(slotFrameType)frameType;

@end

NS_ASSUME_NONNULL_END
