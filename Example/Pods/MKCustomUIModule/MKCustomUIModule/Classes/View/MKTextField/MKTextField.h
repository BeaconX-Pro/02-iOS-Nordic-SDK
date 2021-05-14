/*
 输入框UIMenuController菜单目前只支持粘贴、拷贝、剪切、选中、全部选中
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, mk_textFieldType) {
    mk_normal,                         //默认输入，没有任何的输入校验规则
    mk_realNumberOnly,                 //只能输入数字
    mk_letterOnly,                     //只能输入字母
    mk_reakNumberOrLetter,             //可以输入字母或者数字
    mk_hexCharOnly,                    //十六进制字符
    mk_uuidMode,                       //当前输入框为UUID数据，自动加下划线，8-4-4-4-12
};

@interface MKTextField : UITextField

//最大输入长度,如果是默认0，则不限制输入长度
@property (nonatomic, assign)NSUInteger maxLength;

@property (nonatomic, assign)mk_textFieldType textType;

/// 文本内容发生改变触发的回调
@property (nonatomic, copy)void (^textChangedBlock)(NSString *text);

/// 初始化方法
/// @param textType 当前textField的输入类型
- (instancetype)initWithTextFieldType:(mk_textFieldType)textType;

@end

NS_ASSUME_NONNULL_END
