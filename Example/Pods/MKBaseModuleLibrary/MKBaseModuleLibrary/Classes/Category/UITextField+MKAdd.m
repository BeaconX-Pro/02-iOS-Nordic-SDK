//
//  UITextField+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UITextField+MKAdd.h"
#import <objc/runtime.h>

static const char *prohibitedMethodsListKey = "prohibitedMethodsListKey";

@implementation UITextField (MKAdd)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(mk_init);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (instancetype)mk_init{
    [self mk_init];
    //去掉预测输入
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    return self;
}

#pragma mark - super method

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (!self.prohibitedMethodsList || ![self.prohibitedMethodsList isKindOfClass:NSArray.class] || [self.prohibitedMethodsList count] == 0) {
        return YES;
    }
    for (NSString *methodName in self.prohibitedMethodsList) {
        NSString *tempName = methodName;
        if (![tempName containsString:@":"]) {
            //textField的一系列方法都带有:字符
            tempName = [tempName stringByAppendingString:@":"];
        }
        if (action == NSSelectorFromString(tempName)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - setter & getter

- (void)setProhibitedMethodsList:(NSArray<NSString *> *)prohibitedMethodsList {
    if (!prohibitedMethodsList || ![prohibitedMethodsList isKindOfClass:NSArray.class] || [prohibitedMethodsList count] == 0) {
        return;
    }
    objc_setAssociatedObject(self, &prohibitedMethodsListKey, prohibitedMethodsList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<NSString *> *)prohibitedMethodsList {
    return objc_getAssociatedObject(self, &prohibitedMethodsListKey);
}

- (void)mk_selectAllText {
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.endOfDocument];
    [self setSelectedTextRange:range];
}

- (void)mk_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:NSMaxRange(range)];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

@end
