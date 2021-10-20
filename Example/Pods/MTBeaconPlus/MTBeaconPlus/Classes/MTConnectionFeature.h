//
//  MTConnectionGlobalSlot.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 6/26/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSInteger, FeatureSupported) {
    FeatureSupportedNone = 0,
    FeatureSupportedPerSlot,
    FeatureSupportedTxPower,
    FeatureSupportedPerSlotTxPower,
};

@interface MTConnectionFeature : NSObject

// atitude of slots
@property (nonatomic, assign, readonly) NSInteger slotAtitude;

// adv mode supported
@property (nonatomic, assign, readonly) FeatureSupported featureSupported;

// all supported frameTypes of current connection
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *supportedFrames;

// all supported triggerType of current connection
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *supportedTriggers;

// all supported RadioTxpowers of current connection
@property (nonatomic, strong, readonly) NSArray<NSNumber *> *supportedTxpowers;

@end
