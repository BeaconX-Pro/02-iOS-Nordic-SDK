//
//  UINavigationItem+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/24.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (MKAdd)

- (void)setLeftBarButtonItem1:(UIBarButtonItem *)leftBarButtonItem;
- (void)setLeftBarButtonItemsCustom:(NSArray *)leftBarButtonItems;
- (void)setRightBarButtonItem1:(UIBarButtonItem *)rightBarButtonItem;
- (void)setRightBarButtonItemsCustom:(NSArray *)rightBarButtonItems;

@end
