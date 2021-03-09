//
//  MKTextField.m
//  MKBaseModuleLibrary_Example
//
//  Created by aa on 2020/12/28.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTextField.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

@interface MKTextField ()

@property (nonatomic, assign)mk_textFieldType textType;

@property (nonatomic, copy)void (^changedBlock)(NSString *text);

@property (nonatomic, assign)NSUInteger inputLen;

@end

@implementation MKTextField

- (instancetype)initWithTextFieldType:(mk_textFieldType)textType textChangedBlock:(void (^)(NSString *text))block{
    if (self = [self init]) {
        self.textType = textType;
        self.changedBlock = block;
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
    NSString *tempString = self.text;
    if (!ValidStr(tempString)) {
        self.text = @"";
        if (self.changedBlock) {
            self.changedBlock(self.text);
        }
        return;
    }
    if (self.maxLength > 0 && tempString.length > self.maxLength && self.textType != mk_uuidMode) {
        self.text = [tempString substringToIndex:self.maxLength];
        if (self.changedBlock) {
            self.changedBlock(self.text);
        }
        return;
    }
    NSString *inputString = [tempString substringFromIndex:(self.text.length - 1)];
    BOOL legal = [self validation:inputString];
    self.text = (legal ? tempString : [tempString substringToIndex:self.text.length - 1]);
    if (self.textType != mk_uuidMode) {
        if (self.changedBlock) {
            self.changedBlock(self.text);
        }
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
            if (self.changedBlock) {
                self.changedBlock(self.text);
            }
        }
        if (self.text.length >= 36) {//输入完成
            self.text = [self.text substringToIndex:36];
            if (self.changedBlock) {
                self.changedBlock(self.text);
            }
        }
        self.inputLen = self.text.length;
        if (self.changedBlock) {
            self.changedBlock(self.text);
        }
    }else if (self.text.length < self.inputLen){//删除
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {
            self.text = [self.text substringToIndex:(self.text.length-1)];
            if (self.changedBlock) {
                self.changedBlock(self.text);
            }
        }
        self.inputLen = self.text.length;
        if (self.changedBlock) {
            self.changedBlock(self.text);
        }
    }
}

#pragma mark - private method
- (BOOL)validation:(NSString *)inputString{
    if (!ValidStr(inputString)) {
        return NO;
    }
    switch (self.textType) {
        case mk_normal:
            return YES;
            
        case mk_realNumberOnly:
            return [inputString regularExpressions:isRealNumbers];
            
        case mk_letterOnly:
            return [inputString regularExpressions:isLetter];
            
        case mk_reakNumberOrLetter:
            return [inputString regularExpressions:isLetterOrRealNumbers];
            
        case mk_hexCharOnly:
            return [inputString regularExpressions:isHexadecimal];
            
        case mk_uuidMode:
            return [inputString regularExpressions:isHexadecimal];
            
        default:
            return NO;
            break;
    }
}

- (UIKeyboardType)getKeyboardType{
    if (self.textType == mk_realNumberOnly) {
        return UIKeyboardTypeNumberPad;
    }
    return UIKeyboardTypeASCIICapable;
}

@end
