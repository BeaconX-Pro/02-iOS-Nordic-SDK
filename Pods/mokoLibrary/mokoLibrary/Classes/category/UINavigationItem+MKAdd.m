//
//  UINavigationItem+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/24.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UINavigationItem+MKAdd.h"

@implementation UINavigationItem (MKAdd)

- (void)setLeftBarButtonItem1:(UIBarButtonItem *)leftBarButtonItem{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    spaceButtonItem.width = -5;
    if (leftBarButtonItem){
        [self setLeftBarButtonItems:@[spaceButtonItem, leftBarButtonItem]];
    }else{
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
}

- (void)setLeftBarButtonItemsCustom:(NSArray *)leftBarButtonItems{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    spaceButtonItem.width = -20;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:leftBarButtonItems];
    [mutableArray insertObject:spaceButtonItem atIndex:0];
    [self setLeftBarButtonItems:mutableArray];
}

- (void)setRightBarButtonItem1:(UIBarButtonItem *)rightBarButtonItem{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    spaceButtonItem.width = -10;
    if (rightBarButtonItem){
        [self setRightBarButtonItems:@[spaceButtonItem, rightBarButtonItem]];
    }else{
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
}

- (void)setRightBarButtonItemsCustom:(NSArray *)rightBarButtonItems{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                     target:nil
                                                                                     action:nil];
    spaceButtonItem.width = -15;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:rightBarButtonItems];
    [mutableArray insertObject:spaceButtonItem atIndex:0];
    [self setRightBarButtonItems:mutableArray];
}

@end
