//
//  MinewURL.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MinewFrame.h"

@interface MinewURL : MinewFrame

// urlString of this frame
@property (nonatomic, strong) NSString *urlString;

// rssi@0m
@property (nonatomic, assign) NSInteger txPower;

@end
