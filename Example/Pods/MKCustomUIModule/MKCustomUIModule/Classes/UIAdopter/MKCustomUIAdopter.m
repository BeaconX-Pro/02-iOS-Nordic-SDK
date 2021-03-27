//
//  MKCustomUIAdopter.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/21.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKCustomUIAdopter.h"

#import "MKMacroDefines.h"

@implementation MKCustomUIAdopter

+ (UIButton *)customButtonWithTitle:(NSString *)title
                             target:(nonnull id)target
                             action:(nonnull SEL)action {
    return [self customButtonWithTitle:title
                            titleColor:COLOR_WHITE_MACROS
                       backgroundColor:NAVBAR_COLOR_MACROS
                                target:target action:action];
}

+ (UIButton *)customButtonWithTitle:(NSString *)title
                         titleColor:(UIColor *)titleColor
                    backgroundColor:(UIColor *)backgroundColor
                             target:(nonnull id)target
                             action:(nonnull SEL)action {
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton setTitleColor:titleColor forState:UIControlStateNormal];
    [customButton.titleLabel setFont:MKFont(15.f)];
    [customButton setBackgroundColor:backgroundColor];
    [customButton.layer setMasksToBounds:YES];
    [customButton.layer setCornerRadius:6.f];
    [customButton addTarget:target
                     action:action
           forControlEvents:UIControlEventTouchUpInside];
    return customButton;
}

+ (UILabel *)customTextLabel {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = DEFAULT_TEXT_COLOR;
    label.font = MKFont(15.f);
    return label;
}

+ (UILabel *)customLabelWithText:(NSString *)text
                       textColor:(UIColor *)textColor
                            font:(UIFont *)font
                   textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.font = font;
    label.text = text;
    return label;
}

+ (MKTextField *)customNormalTextFieldWithText:(NSString *)text
                                   placeHolder:(NSString *)placeHolder
                                      textType:(mk_textFieldType)textType {
    MKTextField *textField = [[MKTextField alloc] initWithTextFieldType:textType];
    textField.textColor = DEFAULT_TEXT_COLOR;
    textField.font = MKFont(15.f);
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = placeHolder;
    textField.text = text;
    
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = RGBCOLOR(162, 162, 162).CGColor;
    textField.layer.cornerRadius = 6.f;
    
    return textField;
}

+ (NSMutableAttributedString *)attributedString:(NSArray <NSString *>*)strings
                                          fonts:(NSArray <UIFont *>*)fonts
                                         colors:(NSArray <UIColor *>*)colors {
    if (!ValidArray(strings) || !ValidArray(fonts) || !ValidArray(colors)) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    if (strings.count != fonts.count || strings.count != colors.count || fonts.count != colors.count) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSString *sourceString = @"";
    for (NSString *str in strings) {
        sourceString = [sourceString stringByAppendingString:str];
    }
    if (sourceString.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:sourceString];
    CGFloat originPostion = 0;
    for (NSInteger i = 0; i < [strings count]; i ++) {
        NSString *tempString = strings[i];
        [resultString addAttribute:NSForegroundColorAttributeName
                             value:(id)colors[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        [resultString addAttribute:NSFontAttributeName
                             value:(id)fonts[i]
                             range:NSMakeRange(originPostion, tempString.length)];
        originPostion += tempString.length;
    }
    return resultString;
}

+ (CGFloat)strHeightForAttributeStr:(NSAttributedString *)string viewWidth:(CGFloat)viewWidth {
    if (string.length == 0) {
        return 0;
    }
    CGSize size  = [string boundingRectWithSize:CGSizeMake(viewWidth, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil].size;
    return ceil(size.height);
}
 
+ (CGFloat)strWidthForAttributeStr:(NSAttributedString *)string viewHeight:(CGFloat)viewHeight {
    if (string.length == 0) {
        return 0;
    }
    CGSize size  = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, viewHeight) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return ceil(size.width);
}

+ (CABasicAnimation *)refreshAnimation:(NSTimeInterval)duration {
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnima.duration = duration;
    transformAnima.fromValue = @(0);
    transformAnima.toValue = @(2 * M_PI);
    transformAnima.autoreverses = NO;
    transformAnima.repeatCount = MAXFLOAT;
    transformAnima.removedOnCompletion = NO;
    return transformAnima;
}

@end
