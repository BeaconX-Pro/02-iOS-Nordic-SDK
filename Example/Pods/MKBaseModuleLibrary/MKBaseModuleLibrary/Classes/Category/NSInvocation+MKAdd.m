//
//  NSInvocation+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "NSInvocation+MKAdd.h"

@implementation NSInvocation (MKAdd)

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector
{
    return [[self class] invocationWithTarget:target selector:selector arguments:NULL];
}

+ (NSInvocation *)invocationWithTarget:(id)target selector:(SEL)selector arguments:(void*)firstArgument,...
{
    NSMethodSignature *signature = [[target class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invoction = [NSInvocation invocationWithMethodSignature:signature];
    [invoction setTarget:target];
    [invoction setSelector:selector];
    
    if (firstArgument)
        {
        va_list arg_list;
        va_start(arg_list, firstArgument);
        [invoction setArgument:firstArgument atIndex:2];
        
        for (NSUInteger i = 0; i < signature.numberOfArguments; i++) {
            void *argument = va_arg(arg_list, void *);
            [invoction setArgument:argument atIndex:i];
        }
        va_end(arg_list);
        }
    
    return invoction;
}

@end
