//
//  UIApplication+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (MKAdd)

/// "Documents" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *mk_documentsURL;
@property (nonatomic, readonly) NSString *mk_documentsPath;

/// "Caches" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *mk_cachesURL;
@property (nonatomic, readonly) NSString *mk_cachesPath;

/// "Library" folder in this app's sandbox.
@property (nonatomic, readonly) NSURL *mk_libraryURL;
@property (nonatomic, readonly) NSString *mk_libraryPath;

/// Application's Bundle Name (show in SpringBoard).
@property (nullable, nonatomic, readonly) NSString *mk_appBundleName;

/// Application's Bundle ID.  e.g. "com.ibireme.MyApp"
@property (nullable, nonatomic, readonly) NSString *mk_appBundleID;

/// Application's Version.  e.g. "1.2.0"
@property (nullable, nonatomic, readonly) NSString *mk_appVersion;

/// Application's Build number. e.g. "123"
@property (nullable, nonatomic, readonly) NSString *mk_appBuildVersion;

/// Whether this app is pirated (not install from appstore).
@property (nonatomic, readonly) BOOL mk_isPirated;

/// Whether this app is being debugged (debugger attached).
@property (nonatomic, readonly) BOOL mk_isBeingDebugged;

/// Current thread real memory used in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t mk_memoryUsage;

/// Current thread CPU usage, 1.0 means 100%. (-1 when error occurs)
@property (nonatomic, readonly) float mk_cpuUsage;

+ (void)skipToHome;

/**
 手机是否安装了某个应用

 @param appKey 应用的key
 @return YES:NO
 */
+ (BOOL)applicationInstall:(NSString *)appKey;

/**
 获取当前手机系统语言环境

 @return language
 */
+ (NSString *)currentSystemLanguage;

/// 获取当前手机型号
+ (NSString *)currentIphoneType;

/**
 Increments the number of active network requests.
 If this number was zero before incrementing, this will start animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)mk_incrementNetworkActivityCount;

/**
 Decrements the number of active network requests.
 If this number becomes zero after decrementing, this will stop animating the
 status bar network activity indicator.
 
 This method is thread safe.
 
 This method has no effect in App Extension.
 */
- (void)mk_decrementNetworkActivityCount;


/// Returns YES in App Extension.
+ (BOOL)mk_isAppExtension;

/// Same as sharedApplication, but returns nil in App Extension.
+ (nullable UIApplication *)mk_sharedExtensionApplication;

@end
