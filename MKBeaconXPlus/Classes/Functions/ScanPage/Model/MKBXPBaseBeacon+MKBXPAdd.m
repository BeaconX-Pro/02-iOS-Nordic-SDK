//
//  MKBXPBaseBeacon+MKBXPAdd.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/2/23.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPBaseBeacon+MKBXPAdd.h"

#import <objc/runtime.h>

static const char *indexKey = "indexKey";

@implementation MKBXPBaseBeacon (MKBXPAdd)

- (void)setIndex:(NSInteger)index{
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index{
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

@end
