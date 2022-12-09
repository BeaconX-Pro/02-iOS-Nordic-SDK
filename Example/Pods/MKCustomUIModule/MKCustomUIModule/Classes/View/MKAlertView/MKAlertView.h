//
//  MKAlertView.h
//  MKNBPlugApp
//
//  Created by aa on 2022/6/15.
//

#import <UIKit/UIKit.h>

#import <MKCustomUIModule/MKTextField.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAlertViewAction : NSObject

@property (nonatomic, copy, readonly)NSString *title;

@property (nonatomic, copy, readonly)void (^handler)(void);

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(void))handler;

@end

@interface MKAlertViewTextField : NSObject

/// 当前textField的值
@property (nonatomic, copy, readonly)NSString *textValue;

/// textField的占位符
@property (nonatomic, copy, readonly)NSString *placeholder;

/// 当前textField的输入类型
@property (nonatomic, assign, readonly)mk_textFieldType textFieldType;

/// textField的最大输入长度,对于textFieldType == mk_uuidMode无效
@property (nonatomic, assign, readonly)NSInteger maxLength;

@property (nonatomic, copy, readonly)void (^handler)(NSString *text);

/// init
/// @param textValue 当前输入框的内容
/// @param placeholder 输入框占位符
/// @param textFieldType 输入框键盘类型
/// @param maxLength textField的最大输入长度,对于textFieldType == mk_uuidMode无效
/// @param handler 输入框内容发生改变时的回调
- (instancetype)initWithTextValue:(NSString *)textValue
                      placeholder:(NSString *)placeholder
                    textFieldType:(mk_textFieldType)textFieldType
                        maxLength:(NSInteger)maxLength
                          handler:(void (^)(NSString *text))handler;

@end

@interface MKAlertView : UIView

/// 添加底部按钮，目前支持最多两组
/// @param action 按钮
- (void)addAction:(MKAlertViewAction *)action;

- (void)addTextField:(MKAlertViewTextField *)textModel;

/// 弹出窗口
/// @param title 窗口Title
/// @param message 窗口Message
/// @param notificationName 收到该通知自动让弹窗消失
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
          notificationName:(NSString *)notificationName;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
