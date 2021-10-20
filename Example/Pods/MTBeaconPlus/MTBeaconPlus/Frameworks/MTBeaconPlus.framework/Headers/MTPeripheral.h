//
//  MTPeripheral.h
//  BeaconPlusCoreDemo
//
//  Created by SACRELEE on 5/2/17.
//  Copyright © 2017 MinewTech. All rights reserved.
//

#import "MTFrameHandler.h"
#import "MTConnectionHandler.h"

@interface MTPeripheral : NSObject

// Uniquely identifier like "MAC address"
@property (nonatomic, strong) NSString *identifier;

// advertising stage handler
@property (nonatomic, strong) MTFrameHandler *framer;

// connection stage handler
@property (nonatomic, strong) MTConnectionHandler *connector;


@end
