//
//  MKTriggerTapView.h
//  BeaconXPlus
//
//  Created by aa on 2019/6/1.
//  Copyright © 2019 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKTriggerTapViewType) {
    MKTriggerTapViewDouble,
    MKTriggerTapViewTriple,
    MKTriggerTapViewDeviceMoves,
};

@interface MKTriggerTapView : UIView

@property (nonatomic, strong, readonly)UITextField *startField;

@property (nonatomic, strong, readonly)UITextField *stopField;

@property (nonatomic, assign, readonly)NSInteger index;

- (instancetype)initWithType:(MKTriggerTapViewType)type;

- (void)updateIndex:(NSInteger)index timeValue:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
