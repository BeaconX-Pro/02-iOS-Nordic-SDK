//
//  UIScrollView+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Provides extensions for `UIScrollView`.
 */

@interface UIScrollView (MKAdd)

/**
 Scroll content to top with animation.
 */
- (void)mk_scrollToTop;

/**
 Scroll content to bottom with animation.
 */
- (void)mk_scrollToBottom;

/**
 Scroll content to left with animation.
 */
- (void)mk_scrollToLeft;

/**
 Scroll content to right with animation.
 */
- (void)mk_scrollToRight;

/**
 Scroll content to top.
 
 @param animated  Use animation.
 */
- (void)mk_scrollToTopAnimated:(BOOL)animated;

/**
 Scroll content to bottom.
 
 @param animated  Use animation.
 */
- (void)mk_scrollToBottomAnimated:(BOOL)animated;

/**
 Scroll content to left.
 
 @param animated  Use animation.
 */
- (void)mk_scrollToLeftAnimated:(BOOL)animated;

/**
 Scroll content to right.
 
 @param animated  Use animation.
 */
- (void)mk_scrollToRightAnimated:(BOOL)animated;

@end
