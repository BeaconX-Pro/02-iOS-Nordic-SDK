//
//  UIApplication+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/29.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UIApplication+MKAdd.h"
#import <sys/utsname.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <objc/runtime.h>

#import "NSArray+MKAdd.h"
#import "NSObject+MKAdd.h"

#ifndef MKSYNTH_DYNAMIC_PROPERTY_OBJECT
#define MKSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
    [self willChangeValueForKey:@#_getter_]; \
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
    [self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
    return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif

#define kNetworkIndicatorDelay (1/30.0)
@interface _MKUIApplicationNetworkIndicatorInfo : NSObject
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation _MKUIApplicationNetworkIndicatorInfo
@end

@implementation UIApplication (MKAdd)

+ (void)skipToHome{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]
                                       options:@{}
                             completionHandler:nil];
}

+ (BOOL)applicationInstall:(NSString *)appKey{
    if (!appKey || ![appKey isKindOfClass:[NSString class]] || appKey.length == 0) {
        return NO;
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appKey]];
}

+ (NSString *)currentSystemLanguage{
    // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        //英文
        return @"en";
    }
    if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            // 简体中文
            return @"zh-Hans";
        } else {
            // zh-Hant\zh-HK\zh-TW,繁體中文
            return @"zh-Hant";
        }
    }
    if ([language hasPrefix:@"ja"]) {
        //日本
        return @"ja";
    }
    if ([language hasPrefix:@"cs"]) {
        //捷克
        return @"cs";
    }
    if ([language hasPrefix:@"de"]) {
        //德语
        return @"de";
    }
    if ([language hasPrefix:@"fr"]) {
        //法语
        return @"fr";
    }
    if ([language hasPrefix:@"it"]) {
        //意大利
        return @"it";
    }
    if ([language hasPrefix:@"ko"]) {
        //韩语
        return @"ko";
    }
    if ([language hasPrefix:@"es"]) {
        //西班牙
        return @"es";
    }
    if ([language hasPrefix:@"pt"]) {
        //葡萄牙
        return @"pt";
    }
    if ([language hasPrefix:@"ru"]) {
        //俄语
        return @"ru";
    }
    
    if ([language hasPrefix:@"th"]) {
        //泰语
        return @"th";
    }
    
    return @"en";
}

+ (NSString *)currentIphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([deviceString isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if([deviceString isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max (China)";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])    return @"iPhone SE2";
    if ([deviceString isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,4"])    return @"iPhone 13 mini";
    if ([deviceString isEqualToString:@"iPhone14,5"])    return @"iPhone 13";
    if ([deviceString isEqualToString:@"iPhone14,2"])    return @"iPhone 13 Pro";
    if ([deviceString isEqualToString:@"iPhone14,3"])    return @"iPhone 13 Pro Max";
    
    if([deviceString isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if([deviceString isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if([deviceString isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if([deviceString isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if([deviceString isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if([deviceString isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if([deviceString isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if([deviceString isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if([deviceString isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if([deviceString isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if([deviceString isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if([deviceString isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if([deviceString isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if([deviceString isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    if([deviceString isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    if([deviceString isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if([deviceString isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if([deviceString isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if([deviceString isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if([deviceString isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if([deviceString isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if([deviceString isEqualToString:@"i386"]) return @"iPhone Simulator";
    if([deviceString isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return deviceString;
    
}

- (NSURL *)mk_documentsURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)mk_documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)mk_cachesURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)mk_cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)mk_libraryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)mk_libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

- (BOOL)mk_isPirated {
    if ([self mk_isSimulator]) return YES; // Simulator is not from appstore
    
    if (getgid() <= 10) return YES; // process ID shouldn't be root
    
    if ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SignerIdentity"]) {
        return YES;
    }
    
    if (![self _mk_fileExistInMainBundle:@"_CodeSignature"]) {
        return YES;
    }
    
    if (![self _mk_fileExistInMainBundle:@"SC_Info"]) {
        return YES;
    }
    
    //if someone really want to crack your app, this method is useless..
    //you may change this method's name, encrypt the code and do more check..
    return NO;
}

- (BOOL)_mk_fileExistInMainBundle:(NSString *)name {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/%@", bundlePath, name];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (NSString *)mk_appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)mk_appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)mk_appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)mk_appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (BOOL)mk_isBeingDebugged {
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret = 0, name[4];
    memset(&info, 0, sizeof(struct kinfo_proc));
    
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID; name[3] = getpid();
    
    if (ret == (sysctl(name, 4, &info, &size, NULL, 0))) {
        return ret != 0;
    }
    return (info.kp_proc.p_flag & P_TRACED) ? YES : NO;
}

- (int64_t)mk_memoryUsage {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kern = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kern != KERN_SUCCESS) return -1;
    return info.resident_size;
}

- (float)mk_cpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

MKSYNTH_DYNAMIC_PROPERTY_OBJECT(networkActivityInfo, setNetworkActivityInfo, RETAIN_NONATOMIC, _MKUIApplicationNetworkIndicatorInfo *);

- (void)_delaySetActivity:(NSTimer *)timer {
    NSNumber *visiable = timer.userInfo;
    if (self.networkActivityIndicatorVisible != visiable.boolValue) {
        [self setNetworkActivityIndicatorVisible:visiable.boolValue];
    }
    [timer invalidate];
}

- (void)_changeNetworkActivityCount:(NSInteger)delta {
    @synchronized(self){
        dispatch_async(dispatch_get_main_queue(), ^{
            _MKUIApplicationNetworkIndicatorInfo *info = [self networkActivityInfo];
            if (!info) {
                info = [_MKUIApplicationNetworkIndicatorInfo new];
                [self setNetworkActivityInfo:info];
            }
            NSInteger count = info.count;
            count += delta;
            info.count = count;
            [info.timer invalidate];
            info.timer = [NSTimer timerWithTimeInterval:kNetworkIndicatorDelay target:self selector:@selector(_delaySetActivity:) userInfo:@(info.count > 0) repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:info.timer forMode:NSRunLoopCommonModes];
        });
    }
}

- (void)mk_incrementNetworkActivityCount {
    [self _changeNetworkActivityCount:1];
}

- (void)mk_decrementNetworkActivityCount {
    [self _changeNetworkActivityCount:-1];
}

+ (BOOL)mk_isAppExtension {
    static BOOL isAppExtension = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIApplication");
        if(!cls || ![cls respondsToSelector:@selector(sharedApplication)]) isAppExtension = YES;
        if ([[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]) isAppExtension = YES;
    });
    return isAppExtension;
}

+ (UIApplication *)mk_sharedExtensionApplication {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return [self mk_isAppExtension] ? nil : [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
}

- (BOOL)mk_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end
