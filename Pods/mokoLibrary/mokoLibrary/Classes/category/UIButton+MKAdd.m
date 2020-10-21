//
//  UIButton+MKAdd.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/27.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "UIButton+MKAdd.h"
#import <objc/runtime.h>

#import "MKMacroDefines.h"
#import "UIImage+MKAdd.h"

@interface UIControl()

@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@end

@implementation UIButton (MKAdd)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(cjr_sendAction:to:forEvent:));
    SEL mySEL = @selector(cjr_sendAction:to:forEvent:);
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
    }
}

#pragma mark - 设置倒计时时间

- (void)startCountdown:(NSUInteger)seconds{
    NSString *originalTitle = [self titleForState:UIControlStateNormal];
    UIImage *originalImage = [self backgroundImageForState:UIControlStateNormal];
    UIColor *titleColor = [self titleColorForState:UIControlStateNormal];
    
    //倒计时代码
    __block NSUInteger timeout = seconds; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.userInteractionEnabled = YES;
                [self setTitle:originalTitle forState:UIControlStateNormal];
                [self setBackgroundImage:originalImage forState:UIControlStateNormal];
                self.backgroundColor = [UIColor clearColor];
                [self setTitleColor:titleColor forState:UIControlStateNormal];
            });
        }else{
            //倒计时执行时
            int residueSeconds = ((int)timeout/10)*10 + timeout%10;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.userInteractionEnabled = NO;
                self.titleLabel.lineBreakMode = 0;
                self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self setTitle:[NSString stringWithFormat:@"%d秒",residueSeconds] forState:UIControlStateNormal];
                [self setTitleColor:RGBCOLOR(51, 61, 81) forState:UIControlStateNormal];
                [self setBackgroundImage:nil forState:UIControlStateNormal];
                self.backgroundColor = RGBCOLOR(239, 239, 246);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Runtime解决UIButton重复点击问题

- (NSTimeInterval)acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - custom method

- (void)cjr_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if([NSStringFromClass(self.class)isEqualToString:@"UIButton"]) {
        self.acceptEventInterval = (!self.acceptEventInterval || self.acceptEventInterval == 0) ? 0.001 : self.acceptEventInterval;
        NSTimeInterval sapceTime = NSDate.date.timeIntervalSince1970 - self.acceptEventTime;
        if (sapceTime < 0) {
            //解决跨时区问题，一旦跨越时区，就可能出现按钮点击事件不响应的问题。改成取取绝对值的方式解决跨时区问题
            sapceTime = self.acceptEventTime - NSDate.date.timeIntervalSince1970;
        }
        if (sapceTime < self.acceptEventInterval) {
            return;
            
        }
    }
    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self cjr_sendAction:action to:target forEvent:event];
}

@end
