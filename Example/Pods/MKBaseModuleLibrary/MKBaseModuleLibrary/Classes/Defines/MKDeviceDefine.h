/**
 头文件说明：
 1、与设备有关的宏定义
 */
#pragma mark - *************************  block弱引用强引用  *************************
//弱引用对象
#define WS(weakSelf)          __weak __typeof(&*self)weakSelf = self;

#pragma mark - ***************************    优雅的使用弱引用和强引用      **************************
/*
 @weakify(self)

 blcok = ^{
     @strongify(self)
     self.view = ...
 }
 */

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif


#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


#pragma mark - *************************  硬件相关  *************************
/** 获取屏幕尺寸、宽度、高度 */
#define kScreenRect                 ([[UIScreen mainScreen] bounds])            //屏幕frame
#define kViewWidth                ([UIScreen mainScreen].bounds.size.width)   //屏幕宽度
#define kViewHeight               ([UIScreen mainScreen].bounds.size.height)  //屏幕高度
#define kScreenCurrModeSize         [[UIScreen mainScreen] currentMode].size    //currentModel的size

#define kScreenMaxLength            (MAX(kViewWidth, kViewHeight))          //获取屏幕宽高最大者
#define kScreenMinLength            (MIN(kViewWidth, kViewHeight))          //获取屏幕宽高最小者
#define launchBounds(i) (CGRectMake(i * kViewWidth,0,kViewWidth,kViewHeight))

#define isIPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否是ipad设备
#define isIPhone                    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)  //是否是iPhone设备
#define isRetina                    (kScreenScale >= 2.0)                                     //是否是retina屏幕

//是否是垂直
#define isPortrait                  ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)

//UIScreen是否响应currentMode方法
#define isRespondCurrModel          [UIScreen instancesRespondToSelector:@selector(currentMode)]
#define isEqualToCurrModelSize(w,h) CGSizeEqualToSize(CGSizeMake(w,h), kScreenCurrModeSize)

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4                     (isRespondCurrModel ? isEqualToCurrModelSize(640,960) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5                     (isRespondCurrModel ? isEqualToCurrModelSize(640,1136) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6                     (isRespondCurrModel ? isEqualToCurrModelSize(750, 1334) || isEqualToCurrModelSize(640, 1136) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6Plus                 (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) || isEqualToCurrModelSize(1242, 2208) : NO)

#define iPhone6PlusZoom             (isRespondCurrModel ? isEqualToCurrModelSize(1125, 2001) : NO)

//判断iPHoneXr、iPhone 11
#define iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPHoneX、iPHoneXs、iPhone 11 Pro
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhoneXs Max、iPhone 11 Pro Max
#define iPhoneMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

/*
 判断当前手机有没有安全区域，iPhone X以后新出的设备都有安全区和留海屏.
 */
#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

//状态栏、导航栏、标签栏高度
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height

//底部虚拟home键高度 一般用于最底部view到底部的距离
#define VirtualHomeHeight (kIsBangsScreen ? 34.f : 0.f)

//默认顶部布局
#define defaultTopInset (Height_StatusBar + 44.f)

#pragma mark - *************************  系统相关  *************************
//delegate对象//AppWindow
#define kAppDelegate            ([[UIApplication sharedApplication] delegate])
#define kAppWindow              ([UIApplication sharedApplication].keyWindow)
#define kAppRootController      [UIApplication sharedApplication].keyWindow.rootViewController

/** 获取系统版本 */
#define kSystemVersionString    ([[UIDevice currentDevice] systemVersion])

/** 获取APP名称 */
#define kAppName                ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"])
/** 获取APP版本 */
#define kAppVersion             ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/** 获取APP build版本 */
#define kAppBuildVersion        ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

#define iOS(x)                  (([[[UIDevice currentDevice] systemVersion] floatValue] >= x) ? YES : NO)

//获取系统时间戳
#define  kSystemTimeStamp [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]


#pragma mark - *************************  本地文档相关  *************************
/** 获取Documents目录 */
#define kDocumentsPath          ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject])

/** 获得Documents下指定文件名的文件路径 */
#define kFilePath(filename)     ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:filename])

/** 获取Library目录 */
#define kLibraryPath            ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject])

/** 获取Caches目录 */
#define kCachesPath             ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])

/** 获取Tmp目录 */
#define kTmpPath                 NSTemporaryDirectory()

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

//图片的宏定义,注意该方法只对取mainBundle下面的图片有效，如果是自建的bundle，则该方法取不到。
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",file,(iPhone6Plus || iPhoneX || iPhoneMax) ? @"@3x" : @"@2x"] ofType:ext]]

/*
 podLibName:调用该方法的对象所在的bundle名称
 bundleClassName:调用该方法的对象在bundle里面的名称
 imageName:icon名称，xxx.png
 */
#define LOADICON(podLibName,bundleClassName,imageName) \
({\
NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(bundleClassName)];\
NSString *bundlePath = [bundle pathForResource:podLibName ofType:@"bundle"];\
UIImage *image = [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:imageName]];\
(image);\
})\
