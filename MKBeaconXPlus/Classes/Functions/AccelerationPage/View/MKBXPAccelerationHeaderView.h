//
//  MKBXPAccelerationHeaderView.h
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXPAccelerationHeaderViewDelegate <NSObject>

- (void)bxp_updateThreeAxisNotifyStatus:(BOOL)notify;

@end

@interface MKBXPAccelerationHeaderView : UIView

@property (nonatomic, weak)id <MKBXPAccelerationHeaderViewDelegate>delegate;

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData;

@end

NS_ASSUME_NONNULL_END
