//
//  MinewPeripheral.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/3/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//
#import <CoreFoundation/CoreFoundation.h>
#import "MTPublicHeader.h"


@interface MinewFrame : NSObject

// frameType of MinewFrame instance
@property (nonatomic, assign) FrameType frameType;

// slot number
@property (nonatomic, assign) NSInteger slotNumber;

// advertising interval
@property (nonatomic, assign) NSInteger slotAdvInterval;

// RSSI@0m
@property (nonatomic, assign) NSInteger slotAdvTxpower;

// radioTxpower 
@property (nonatomic, assign) NSInteger slotRadioTxpower;

// check two frame is the same or not
- (BOOL)isSameFrame:(MinewFrame *)frame;

// date of last updated.
@property (nonatomic, strong) NSDate *lastUpdate;

@end
