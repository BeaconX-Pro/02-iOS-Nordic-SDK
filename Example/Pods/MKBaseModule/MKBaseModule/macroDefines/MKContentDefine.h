#import "MKDeviceDefine.h"
#ifndef moko_dispatch_main_safe
#define moko_dispatch_main_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}
#endif
#pragma mark - **************************  字体相关  *********************************
#define MKFont(a)                      [UIFont systemFontOfSize:a]

#pragma mark - **************************  国际化相关  *********************************
#define LS(a)                           NSLocalizedString(a, nil)

//线的高度
#define CUTTING_LINE_HEIGHT             ([[UIScreen mainScreen] scale] == 2.f ? 0.5 : 0.34)

#pragma mark - ************************** 图片加载 *********************************
//图片的宏定义
#define MKBASEBUNDLUE [NSBundle bundleForClass:NSClassFromString(@"MKBaseModule")]
#define MKBASEBUNDLUEPATH [MKBASEBUNDLUE pathForResource:@"MKBaseModule" ofType:@"bundle"]
#define LOADICON(bundlePath,file) [[UIImage alloc] initWithContentsOfFile:[bundlePath stringByAppendingPathComponent:file]]
