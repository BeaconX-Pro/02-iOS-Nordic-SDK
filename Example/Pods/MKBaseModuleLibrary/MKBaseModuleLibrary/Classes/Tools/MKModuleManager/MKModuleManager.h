//
//  MKModuleManager.h
//  MKModuleManager
//
//  Created by GUO Lin on 9/29/16.
//  Copyright © 2016 Douban Inc. All rights reserved.
//

@import UIKit;

@protocol MKModule <UIApplicationDelegate>

@end


@interface MKModuleManager : NSObject<UIApplicationDelegate>

+ (instancetype)sharedInstance;

- (void)loadModulesWithPlistFile:(NSString *)plistFile;

- (NSArray<id<MKModule>> *)allModules;

@end
