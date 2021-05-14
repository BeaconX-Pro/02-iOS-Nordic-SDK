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

@property (nonatomic, assign)mk_textFieldType currentTextType;

@property (nonatomic, assign)NSUInteger inputLen;

@end

@implementation MKTextField

- (instancetype)init {
    if (self = [super init]) {
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

- (instancetype)initWithTextFieldType:(mk_textFieldType)textType{
    if (self = [self init]) {
        self.currentTextType = textType;
        self.keyboardType = [self getKeyboardType];
    }
    return self;
}

#pragma mark - super method
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:) || action == @selector(copy:)
        || action == @selector(cut:) || action == @selector(select:)
        || action == @selector(selectAll:)){
        //允许粘贴、拷贝、剪切、选中、全部选中
        return YES;
    }
    return NO;
}

- (void)delete:(id)sender {
    //长按出现UIMenuController菜单，如果用户点击了删除，textField必须实现该方法，否则闪退
    NSLog(@"%@",sender);
}

#pragma mark - Notification Methods
- (void)textFieldDidBeginEditingNotifiction:(NSNotification *)f{
    
}

- (void)textFieldChanged:(NSNotification *) noti
{
    NSString *tempString = self.text;
    if (!ValidStr(tempString)) {
        self.text = @"";
        if (self.textChangedBlock) {
            self.textChangedBlock(self.text);
        }
        return;
    }
    if (self.maxLength > 0 && tempString.length > self.maxLength && self.currentTextType != mk_uuidMode) {
        self.text = [tempString substringToIndex:self.maxLength];
        if (self.textChangedBlock) {
            self.textChangedBlock(self.text);
        }
        return;
    }
    NSString *inputString = [tempString substringFromIndex:(self.text.length - 1)];
    BOOL legal = [self validation:inputString];
    self.text = (legal ? tempString : [tempString substringToIndex:self.text.length - 1]);
    if (self.currentTextType != mk_uuidMode) {
        if (self.textChangedBlock) {
            self.textChangedBlock(self.text);
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
            if (self.textChangedBlock) {
                self.textChangedBlock(self.text);
            }
        }
        if (self.text.length >= 36) {//输入完成
            self.text = [self.text substringToIndex:36];
            if (self.textChangedBlock) {
                self.textChangedBlock(self.text);
            }
        }
        self.inputLen = self.text.length;
        if (self.textChangedBlock) {
            self.textChangedBlock(self.text);
        }
    }else if (self.text.length < self.inputLen){//删除
        if (self.text.length == 9
            || self.text.length == 14
            || self.text.length == 19
            || self.text.length == 24) {
            self.text = [self.text substringToIndex:(self.text.length-1)];
            if (self.textChangedBlock) {
                self.textChangedBlock(self.text);
            }
        }
        self.inputLen = self.text.length;
        if (self.textChangedBlock) {
            self.textChangedBlock(self.text);
        }
    }
}

#pragma mark - setter
- (void)setTextType:(mk_textFieldType)textType {
    _textType = textType;
    self.currentTextType = _textType;
    self.keyboardType = [self getKeyboardType];
    self.text = @"";
}

#pragma mark - private method
- (BOOL)validation:(NSString *)inputString{
    if (!ValidStr(inputString)) {
        return NO;
    }
    switch (self.currentTextType) {
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
    if (self.currentTextType == mk_realNumberOnly) {
        return UIKeyboardTypeNumberPad;
    }
    return UIKeyboardTypeASCIICapable;
}

@end
