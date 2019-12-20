//
//  MKPageControl.h
//  mokoBaseModule
//
//  Created by aa on 2018/10/15.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPageControl : UIPageControl

/**
 选中图标
 */
@property (nonatomic, strong)UIImage * activeImage;

/**
 未选中图标
 */
@property (nonatomic, strong)UIImage * inactiveImage;

@end
