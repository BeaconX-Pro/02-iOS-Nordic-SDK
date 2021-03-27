//
//  MKTrackerLogController.m
//  MKCustomUIModule_Example
//
//  Created by aa on 2020/12/22.
//  Copyright © 2020 aadyx2007@163.com. All rights reserved.
//

#import "MKTrackerLogController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"
#import "UIApplication+MKAdd.h"

@interface MKTrackerLogController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic, strong)id <MKTrackerLogPageProtocol>protocol;

@property (nonatomic, copy)NSString *localFileName;

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *sendButton;

@end

@implementation MKTrackerLogController

- (void)dealloc {
    NSLog(@"MKTrackerLogController销毁");
}

- (instancetype)initWithProtocol:(id <MKTrackerLogPageProtocol>)protocol localFileName:(NSString *)localFileName {
    self = [self init];
    if (self) {
        self.protocol = protocol;
        self.localFileName = localFileName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"Send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event method
- (void)sendButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"MESSAGE://"] options:@{} completionHandler:nil];
        return;
    }
    NSData *emailData = [self readLocalFileData];
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log file does not exist"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@ + phone: %@",
                         version,
                         kSystemVersionString,
                         [UIApplication currentIphoneType]];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    //设置抄送人
    //    [mailComposer setCcRecipients:@[@"814955458@qq.com"]];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:@"fileLog.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (NSData *)readLocalFileData {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)lastObject];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",self.localFileName];
    NSString *filePath = [path stringByAppendingString:localFileName];
    NSString *fileString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *fileData = [fileString dataUsingEncoding:NSUTF8StringEncoding];
    return fileData;
}

- (void)loadSubViews {
    if ([self.protocol conformsToProtocol:@protocol(MKTrackerLogPageProtocol)]) {
        return;
    }
    if (self.protocol.titleBarColor) {
        self.custom_naviBarColor = self.protocol.titleBarColor;
    }
    if (self.protocol.titleColor) {
        self.titleLabel.textColor = self.protocol.titleColor;
    }
    self.defaultTitle = self.defaultTitle = (ValidStr(self.protocol.title) ? self.protocol.title : @"Log");
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.icon];
    if (self.protocol.emailIcon) {
        UIImage *image = self.protocol.emailIcon;
        self.icon.image = image;
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(image.size.width);
            make.top.mas_equalTo(defaultTopInset + 40.f);
            make.height.mas_equalTo(image.size.height);
        }];
    }
    if (self.protocol.msgFont) {
        self.msgLabel.font = self.protocol.msgFont;
    }
    if (self.protocol.msgColor) {
        self.msgLabel.textColor = self.protocol.msgColor;
    }
    if (ValidStr(self.protocol.msg)) {
        self.msgLabel.text = self.protocol.msg;
    }
    [self.view addSubview:self.msgLabel];
    CGSize msgSize = [NSString sizeWithText:self.msgLabel.text
                                    andFont:self.msgLabel.font
                                 andMaxSize:CGSizeMake(self.view.frame.size.width - 30.f, MAXFLOAT)];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.protocol.emailIcon) {
            make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(30.f);
        }else {
            make.top.mas_equalTo(defaultTopInset + 40.f);
        }
        make.height.mas_equalTo(msgSize.height);
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
    }];
    [self.view addSubview:self.sendButton];
    if (self.protocol.buttonBackColor) {
        [self.sendButton setBackgroundColor:self.protocol.buttonBackColor];
    }
    if (self.protocol.buttonTitleColor) {
        [self.sendButton setTitleColor:self.protocol.buttonTitleColor forState:UIControlStateNormal];
    }
    if (self.protocol.buttonLabelFont) {
        [self.sendButton.titleLabel setFont:self.protocol.buttonLabelFont];
    }
    if (self.protocol.buttonTitle) {
        [self.sendButton setTitle:self.protocol.buttonTitle forState:UIControlStateNormal];
    }
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(50.f);
        make.height.mas_equalTo(50.f);
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
    }];
}

#pragma mark - setter & getter
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.numberOfLines = 0;
        _msgLabel.text = @"Send Log";
    }
    return _msgLabel;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"Email" forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_sendButton.layer setMasksToBounds:YES];
        [_sendButton.layer setCornerRadius:6.f];
        [_sendButton addTapAction:self selector:@selector(sendButtonPressed)];
    }
    return _sendButton;
}

@end
