//
//  NSInvocation+MKAdd.h
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (MKAdd)

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector;

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(void*)firstArgument,...;

@end
