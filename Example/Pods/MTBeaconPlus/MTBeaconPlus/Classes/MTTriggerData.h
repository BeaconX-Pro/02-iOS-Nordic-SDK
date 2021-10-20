//
//  MTTriggerData.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 8/23/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TriggerType) {
    TriggerTypeUndefined = 0,
    TriggerTypeNone = 1,
    
    TriggerTypeMotionLater,         //Acceleration
    TriggerTypeBtnPushLater,
    TriggerTypeBtnReleaLater,
    TriggerTypeBtnStapLater,
    TriggerTypeBtnDtapLater,        //double tap
    TriggerTypeBtnTtapLater,        //three consecutive tap
    TriggerTypePIRLater,            //Infrared sensing

    TriggerTypeTempAbove,           //temperature above
    TriggerTypeTempBelow,           //temperature below
    TriggerTypeHumiAbove,           //humidity above
    TriggerTypeHumiBelow,           //humidity below
    TriggerTypeLuxAbove,            //lux above
    TriggerTypeLuxBelow,            //lux below
    TriggerTypeForceAbove,          //force above
    TriggerTypeForceBelow,          //force below
    TriggerTypeTVOCAbove,           //tvoc above
    TriggerTypeTVOCBelow,           //tvoc below
};

@interface MTTriggerData : NSObject

@property (nonatomic, assign, readonly) TriggerType type;

@property (nonatomic, assign, readonly) NSInteger slotNumber;

@property (nonatomic, assign, readonly) NSInteger value;

@property (nonatomic, assign, readonly) NSInteger maxValue;

@property (nonatomic, assign, readonly) NSInteger minValue;

@property (nonatomic, assign) NSUInteger advInterval;

@property (nonatomic, assign) NSInteger radioTxpower;

// if yes the correspond slot will advertise data even not in trigger condition
// default YES
@property (nonatomic, assign) BOOL always;

- (instancetype)initWithSlot:(NSInteger)slotNumber paramSupport:(BOOL)sup triggerType:(TriggerType)type value:(NSInteger)value;

- (instancetype)initWithType:(TriggerType)type;

@end


