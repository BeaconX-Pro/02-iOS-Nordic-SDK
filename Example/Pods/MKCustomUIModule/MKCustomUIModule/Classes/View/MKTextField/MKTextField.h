//
//  MKTextField.h
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2020/12/28.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_textFieldType) {
    mk_normal,                    //默认输入，没有任何的输入校验规则
    mk_realNumberOnly,                 //只能输入数字
    mk_letterOnly,                     //只能输入字母
    mk_reakNumberOrLetter,             //可以输入字母或者数字
    mk_hexCharOnly,                    //十六进制字符
    mk_uuidMode,                       //当前输入框为UUID数据，自动加下划线，8-4-4-4-12
};

@interface MKTextField : UITextField

//最大输入长度,如果是默认0，则不限制输入长度
@property (nonatomic, assign)NSUInteger maxLength;

/// 初始化方法
/// @param textType 当前textField的输入类型
/// @param block textField值发生改变的时候回调
- (instancetype)initWithTextFieldType:(mk_textFieldType)textType textChangedBlock:(void (^)(NSString *text))block;

@end

NS_ASSUME_NONNULL_END
