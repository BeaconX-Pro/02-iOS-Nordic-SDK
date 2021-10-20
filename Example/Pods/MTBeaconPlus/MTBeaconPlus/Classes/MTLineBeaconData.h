//
//  MTLineBeaconData.h
//  MTBeaconPlus
//
//  Created by minew on 2020/1/15.
//  Copyright © 2020 MinewTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTLineBeaconData : NSObject

//HWID
@property (nonatomic, strong) NSString *hwId;

//VENDOR_KEY
@property (nonatomic, strong) NSString *vendorKey;

//LOT_KEY
@property (nonatomic, strong) NSString *lotKey;

- (void)updateData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
