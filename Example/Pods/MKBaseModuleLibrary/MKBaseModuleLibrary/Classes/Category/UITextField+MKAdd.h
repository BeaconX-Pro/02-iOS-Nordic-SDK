//
//  UITextField+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MKAdd)
/*
 当前textField禁止使用的方法
 
 cut: // 剪切
 copy: // 拷贝
 select: // 选择
 selectAll: // 全选
 paste: // 粘贴
 delete: // 删除
 _promptForReplace: // Replace...
 _transliterateChinese: // 简<=>繁
 _showTextStyleOptions: // B/<u>U</u>
 _define: // Define
 _addShortcut: // Learn...
 _accessibilitySpeak: // Speak
 _accessibilitySpeakLanguageSelection: // Speak...
 _accessibilityPauseSpeaking: // Pause
 _share: // 共享...
 makeTextWritingDirectionRightToLeft: // 往右缩进
 makeTextWritingDirectionLeftToRight: // 往左缩进
 */
@property (nonatomic, strong)NSArray <NSString *>*prohibitedMethodsList;

/**
 Set all text selected.
 */
- (void)mk_selectAllText;

/**
 Set text in range selected.
 
 @param range  The range of selected text in a document.
 */
- (void)mk_setSelectedRange:(NSRange)range;

@end
