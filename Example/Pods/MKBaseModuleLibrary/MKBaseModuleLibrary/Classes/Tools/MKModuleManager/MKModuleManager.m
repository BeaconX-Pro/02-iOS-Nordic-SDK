//
//  MKModuleManager.m
//  MKModuleManager
//
//  Created by GUO Lin on 9/29/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

#import "MKModuleManager.h"

@interface MKModuleManager ()

@property (nonatomic, strong) NSMutableArray<id<MKModule>> *modules;

@end

@implementation MKModuleManager

+ (instancetype)sharedInstance
{
  static MKModuleManager *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[[self class] alloc] init];
  });
  return instance;
}


- (NSMutableArray<id<MKModule>> *)modules
{
  if (!_modules) {
    _modules = [NSMutableArray array];
  }
  return _modules;
}

- (void)addModule:(id<MKModule>) module
{
  if (![self.modules containsObject:module]) {
    [self.modules addObject:module];
  }
}

- (void)loadModulesWithPlistFile:(NSString *)plistFile
{
  NSArray<NSString *> *moduleNames = [NSArray arrayWithContentsOfFile:plistFile];
  for (NSString *moduleName in moduleNames) {
    id<MKModule> module = [[NSClassFromString(moduleName) alloc] init];
    [self addModule:module];
  }
}

- (NSArray<id<MKModule>> *)allModules
{
  return self.modules;
}

#pragma mark - UIApplicationDelegate's methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module application:application didFinishLaunchingWithOptions:launchOptions];
    }
  }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module applicationWillResignActive:application];
    }
  }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module applicationDidEnterBackground:application];
    }
  }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module applicationWillEnterForeground:application];
    }
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module applicationDidBecomeActive:application];
    }
  }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  for (id<MKModule> module in self.modules) {
    if ([module respondsToSelector:_cmd]) {
      [module applicationWillTerminate:application];
    }
  }
}

@end
