//
//  UITextField+MKCategoryModule.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UITextField+MKCategoryModule.h"
#import <objc/runtime.h>
#import "MKMacroDefines.h"
#import "NSString+MKCategoryModule.h"

static const char *TextField_type = "TextField_type";
static const char *TextField_maxLength = "TextField_maxLength";
static const char *TextField_currentInputLength = "TextField_currentInputLength";

@interface UITextField()

@property (nonatomic, assign)NSInteger inputLen;

@end

@implementation UITextField (MKCategoryModule)

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

- (instancetype)initWithTextFieldType:(mk_CustomTextFieldType)type{
    if (self = [self init]) {
        objc_setAssociatedObject(self, &TextField_type, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &TextField_type, @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.keyboardType = [self getKeyboardType];
        //注意，这里的通知监听方法中的最后一个参数object，一定要传入当前MKTextField对象，才会监听对应的MKTextField，否则会监听所有MKTextField
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidBeginEditingNotifiction:)
                                                     name:UITextFieldTextDidBeginEditingNotification
                                                   object:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:self];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return self;
}

#pragma mark - Notification Methods
- (void)textFieldDidBeginEditingNotifiction:(NSNotification *)f{
    
}

- (void)textFieldChanged:(NSNotification *) noti
{
    NSString *tempString = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!ValidStr(tempString)) {
        self.text = @"";
        return;
    }
    if (self.maxLength > 0 && tempString.length > self.maxLength) {
        self.text = [tempString substringToIndex:self.maxLength];
        return;
    }
    NSString *inputString = [tempString substringFromIndex:(self.text.length - 1)];
    BOOL legal = [self validation:inputString];
    self.text = (legal ? tempString : [tempString substringToIndex:self.text.length - 1]);
    
    if ([objc_getAssociatedObject(self, &TextField_type) integerValue] != uuidMode) {
        return;
    }
    self.text = [self.text uppercaseString];
    //8-4-4-4-12,uuid校验
    if (self.text.length > self.inputLen) {
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {//输入
            NSMutableString * str = [[NSMutableString alloc ] initWithString:self.text];
            [str insertString:@"-" atIndex:(self.text.length-1)];
            self.text = str;
        }
        if (self.text.length >= 36) {//输入完成
            self.text = [self.text substringToIndex:36];
        }
        self.inputLen = self.text.length;
        
    }else if (self.text.length < self.inputLen){//删除
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {
            self.text = [self.text substringToIndex:(self.text.length-1)];
        }
        self.inputLen = self.text.length;
    }
}

#pragma mark - setter & getter
- (void)setMaxLength:(NSUInteger)maxLength{
    objc_setAssociatedObject(self, &TextField_maxLength, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &TextField_maxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)maxLength{
    NSNumber *maxLengthNumber = objc_getAssociatedObject(self, &TextField_maxLength);
    if (!maxLengthNumber || ![maxLengthNumber isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    return [maxLengthNumber integerValue];
}

- (void)setInputLen:(NSInteger)inputLen{
    objc_setAssociatedObject(self, &TextField_currentInputLength, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &TextField_currentInputLength, @(inputLen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)inputLen{
    NSNumber *currentInput = objc_getAssociatedObject(self, &TextField_currentInputLength);
    if (!currentInput || ![currentInput isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    return [currentInput integerValue];
}

#pragma mark - custom method
- (BOOL)validation:(NSString *)inputString{
    if (!ValidStr(inputString)) {
        return NO;
    }
    switch ([objc_getAssociatedObject(self, &TextField_type) integerValue]) {
        case normalInput:
            return YES;
            
        case realNumberOnly:
            return [inputString regularExpressions:isRealNumbers];
            
        case letterOnly:
            return [inputString regularExpressions:isLetter];
            
        case reakNumberOrLetter:
            return [inputString regularExpressions:isLetterOrRealNumbers];
            
        case hexCharOnly:
            return [inputString regularExpressions:isHexadecimal];
            
        case uuidMode:
            return [inputString regularExpressions:isHexadecimal];
            
        default:
            return NO;
            break;
    }
}

- (UIKeyboardType)getKeyboardType{
    if ([objc_getAssociatedObject(self, &TextField_type) integerValue] == realNumberOnly) {
        return UIKeyboardTypeNumberPad;
    }
    return UIKeyboardTypeASCIICapable;
}

@end
