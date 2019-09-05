//
//  MKBXPBaseBeacon+MKAdd.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKBXPBaseBeacon+MKAdd.h"
#import <objc/runtime.h>

static const char *indexKey = "indexKey";

@implementation MKBXPBaseBeacon (MKAdd)

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index{
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
