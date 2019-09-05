//
//  MKHexKeyboard.h
//  FitPolo
//
//  Created by aa on 2018/3/22.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MKHexKeyboardKeyPressedBlock)(NSString *key);
typedef void(^MKHexKeyboardDonePressedBlock)(void);
typedef void(^MKHexKeyboardDeletePressedBlock)(void);

@interface MKHexKeyboard : UIView

/**
 展示键盘
 
 @param keyBlock 按键按下回调
 @param deleteBlock 键盘删除键按下回调
 @param doneBlock 键盘Done键按下回调
 */
- (void)showHexKeyboardBlock:(MKHexKeyboardKeyPressedBlock)keyBlock
                 deleteBlock:(MKHexKeyboardDeletePressedBlock)deleteBlock
                   doneBlock:(MKHexKeyboardDonePressedBlock)doneBlock;

@end
