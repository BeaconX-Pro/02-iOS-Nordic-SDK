//
//  MKAppDelegate.m
//  MKBeaconXProSDK
//
//  Created by aadyx2007@163.com on 09/04/2019.
//  Copyright (c) 2019 aadyx2007@163.com. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKScanViewController.h"
#import "MKMainTabBarController.h"

@interface MKAppDelegate ()

@property (nonatomic, copy)NSString *connectPassword;

@end

@implementation MKAppDelegate

- (void)dealloc {
    NSLog(@"AppDelegate dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = COLOR_WHITE_MACROS;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetRootControllerToTabBar:)
                                                 name:@"MKNeedResetRootControllerToTabBar"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetRootControllerToScanPage)
                                                 name:@"MKNeedResetRootControllerToScanPage"
                                               object:nil];
    [self setScanPage:NO];
    [_window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - note
- (void)resetRootControllerToTabBar:(NSNotification *)note {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    animation.type = kCATransitionPush;
    animation.removedOnCompletion = YES;
    animation.subtype = kCATransitionFromRight;
    self.connectPassword = [MKDataManager shared].password;
    [[[UIApplication sharedApplication] delegate].window.layer addAnimation:animation forKey:nil];
    _window.rootViewController = [[MKMainTabBarController alloc] init];
}

- (void)resetRootControllerToScanPage {
    [self setScanPage:YES];
}

#pragma mark - private method

- (void)setScanPage:(BOOL)needAnimation {
    if (needAnimation) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3f;
        animation.type = kCATransitionPush;
        animation.removedOnCompletion = YES;
        animation.subtype = kCATransitionFromLeft;
        [[[UIApplication sharedApplication] delegate].window.layer addAnimation:animation forKey:nil];
    }
    MKScanViewController *vc = [[MKScanViewController alloc] init];
    vc.localPassword = self.connectPassword;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    _window.rootViewController = nav;
}

@end
