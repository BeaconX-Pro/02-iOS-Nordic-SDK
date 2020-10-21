//
//  UIView+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/21.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UIView+MKAdd.h"
#import "Toast.h"

@implementation UIView (MKAdd)

- (void)addTapAction:(id)target selector:(SEL)selector
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)addLongPressAction:(id)target selector:(SEL)selector
{
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:recognizer];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

/**
 屏幕中间提示，黑条白字
 
 @param message 提示内容
 */
- (void)showCentralToast:(NSString *)message{
    [self makeToast:message duration:0.8 position:CSToastPositionCenter style:nil];
}

@end
