//
//  MTFrameManager.h
//  BeaconPlusSwiftUI
//
//  Created by SACRELEE on 5/11/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MinewFrame.h"


@interface MTFrameHandler : NSObject

// name of device, sometimes available
@property (nonatomic, strong) NSString *name;

// current rssi value
@property (nonatomic, assign) NSInteger rssi;

// battery left, sometimes available
@property (nonatomic, assign) NSInteger battery;

// mac string, sometimes available
@property (nonatomic, strong) NSString *mac;

// can be connected or not, sometimes available
@property (nonatomic, assign) BOOL connectable;

// date of last updated.
@property (nonatomic, strong, readonly) NSDate *advLastUpdate;

// current advtising frames.
@property (nonatomic, strong, readonly) NSArray<MinewFrame *> *advFrames;


@end
