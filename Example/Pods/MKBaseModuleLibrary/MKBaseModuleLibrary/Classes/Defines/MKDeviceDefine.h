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
#define kScreenRect                 ([UIScreen mainScreen].bounds)            //屏幕frame
#define kViewWidth                  ([UIScreen mainScreen].bounds.size.width)   //屏幕宽度
#define kViewHeight                 ([UIScreen mainScreen].bounds.size.height)  //屏幕高度

#define kScreenMaxLength            (MAX(kViewWidth, kViewHeight))          //获取屏幕宽高最大者
#define kScreenMinLength            (MIN(kViewWidth, kViewHeight))          //获取屏幕宽高最小者

#pragma mark - *************************  系统相关  *************************

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kAppWindow ({ \
    UIWindow *topWindow = nil; \
    if (@available(iOS 13.0, *)) { \
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes; \
        UIWindowScene *activeScene = (UIWindowScene *)connectedScenes.anyObject; \
        topWindow = activeScene.windows.lastObject; \
    } else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        topWindow = [[UIApplication sharedApplication].windows lastObject]; \
_Pragma("clang diagnostic pop") \
    } \
    topWindow; \
})

#define kAppRootController ({ \
    UIViewController *rootController = nil; \
    if (@available(iOS 15.0, *)) { \
        UIWindowScene *activeScene = nil; \
        for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) { \
            if (scene.activationState == UISceneActivationStateForegroundActive) { \
                activeScene = scene; \
                break; \
            } \
        } \
        if (activeScene) { \
            rootController = activeScene.windows.firstObject.rootViewController; \
        } \
    } else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        rootController = [UIApplication sharedApplication].windows.firstObject.rootViewController; \
_Pragma("clang diagnostic pop") \
    } \
    rootController; \
})

/** 获取系统版本 */
#define kSystemVersionString ({ \
    NSString *systemVersion = nil; \
    if (@available(iOS 15.0, *)) { \
        systemVersion = [NSProcessInfo processInfo].operatingSystemVersionString; \
    } else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        systemVersion = [[UIDevice currentDevice] systemVersion]; \
_Pragma("clang diagnostic pop") \
    } \
    systemVersion; \
})

/** 获取APP名称 */

#define kAppName ({ \
    NSString *appName = nil; \
    if (@available(iOS 15.0, *)) { \
        appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]; \
        if (!appName) { \
            appName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"]; \
        } \
    } else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]; \
_Pragma("clang diagnostic pop") \
    } \
    appName; \
})

/** 获取APP版本 */
#define kAppVersion ({ \
    NSString *appVersion = nil; \
    if (@available(iOS 15.0, *)) { \
        appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]; \
    } else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
        appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; \
_Pragma("clang diagnostic pop") \
    } \
    appVersion; \
})

#define iOS(x) ({ \
    BOOL isIOS = NO; \
    if (@available(iOS x, *)) { \
        isIOS = YES; \
    } \
    isIOS; \
})

//获取系统时间戳
#define  kSystemTimeStamp [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

#pragma mark - *************************  状态栏、导航栏、标签栏相关  *************************

/*
    状态栏
 */

#define kStatusBarHeight kAppWindow.windowScene.statusBarManager.statusBarFrame.size.height

/**
 *  导航栏
 */
#define kNavigationBarHeight [[UINavigationController alloc] init].navigationBar.frame.size.height

/**
 *  标签栏(底部)
 */
#define kTabBarHeight [[UITabBarController alloc] init].tabBar.frame.size.height




/*
    顶部导航栏+导航栏高度
 */
#define kTopBarHeight (kStatusBarHeight + kNavigationBarHeight)

/**
 *  竖屏底部安全区域
 */
#define kSafeAreaHeight ({\
    CGFloat bottom=0.0;\
    if (@available(iOS 11.0, *)) {\
        bottom = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;\
    } else { \
        bottom=0;\
    }\
    (bottom);\
})


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
#define MKFont(a) ({  \
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:a];  \
    if (!font) {    \
        font = [UIFont systemFontOfSize:a]; \
    }   \
    font;   \
})

#pragma mark - **************************  国际化相关  *********************************
#define LS(a)                           NSLocalizedString(a, nil)

//线的高度
#define CUTTING_LINE_HEIGHT             ([[UIScreen mainScreen] scale] == 2.f ? 0.5 : 0.34)

//图片的宏定义,注意该方法只对取mainBundle下面的图片有效，如果是自建的bundle，则该方法取不到。
#define LOADIMAGE(file,ext) ({ \
    NSBundle *bundle = [NSBundle mainBundle]; \
    NSString *imageName = [NSString stringWithFormat:@"%@%@", file, \
                           (UIScreen.mainScreen.nativeScale > 2.0) ? @"@3x" : @"@2x"]; \
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil]; \
    if (!image) { \
        NSString *imagePath = [bundle pathForResource:file ofType:ext]; \
        image = [UIImage imageWithContentsOfFile:imagePath]; \
    } \
    image; \
})

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
