//
//  MKBXPLightSensorController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/8/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPLightSensorController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKAlertController.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXPDeviceTimeDataModel.h"

#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPLightSensorHeaderView.h"
#import "MKBXPLightSensorButtonView.h"

#import "MKBXPLightSensorDataModel.h"

@interface MKBXPLightSensorController ()<MKBXPLightSensorHeaderViewDelegate>

@property (nonatomic, strong)MKBXPLightSensorHeaderView *headerView;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIImageView *syncIcon;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)MKBXPLightSensorButtonView *deleteButton;

@property (nonatomic, strong)MKBXPLightSensorButtonView *exportButton;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)MKBXPLightSensorDataModel *dataModel;

@end

@implementation MKBXPLightSensorController

- (void)dealloc {
    NSLog(@"MKBXPLightSensorController销毁");
    [[MKBXPCentralManager shared] notifyLightSensorData:NO];
    [[MKBXPCentralManager shared] notifyLightStatusData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self addNotifications];
    [self readDatasFromDevice];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:  //取消
            break;
        case MFMailComposeResultSaved:      //用户保存
            break;
        case MFMailComposeResultSent:       //用户点击发送
            [self.view showCentralToast:@"send success"];
            break;
        case MFMailComposeResultFailed: //用户尝试保存或发送邮件失败
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MKBXPLightSensorHeaderViewDelegate
- (void)bxp_lightSensorSyncTime {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *dateList = [date componentsSeparatedByString:@"-"];
    
    MKBXPDeviceTimeDataModel *dateModel = [[MKBXPDeviceTimeDataModel alloc] init];
    dateModel.year = [dateList[0] integerValue];
    dateModel.month = [dateList[1] integerValue];
    dateModel.day = [dateList[2] integerValue];
    dateModel.hour = [dateList[3] integerValue];
    dateModel.minutes = [dateList[4] integerValue];
    dateModel.seconds = [dateList[5] integerValue];
    
    [MKBXPInterface bxp_configDeviceTime:dateModel sucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        NSString *dateString = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",dateList[2],dateList[1],dateList[0],dateList[3],dateList[4],dateList[5]];
        [self.headerView updateCurrentTime:dateString];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - note
- (void)receiveLightSensorDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSString *state = @"Ambient light NOT detected";
    if ([dic[@"state"] isEqualToString:@"01"]) {
        state = @"Ambient light detected";
    }
    NSArray *dateList = [dic[@"date"] componentsSeparatedByString:@"-"];
    NSString *dateString = [NSString stringWithFormat:@"%@/%@/%@ %@:%@:%@",dateList[2],dateList[1],dateList[0],dateList[3],dateList[4],dateList[5]];
    NSString *text = [NSString stringWithFormat:@"\n%@\t\t%@",dateString,state];
    [self saveDataToLocal:text];
    self.textView.text = [self.textView.text stringByAppendingString:text];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}

- (void)receiveLightSensorStatus:(NSNotification *)note {
    [self.headerView updateSensorStatus:[note.userInfo[@"status"] isEqualToString:@"01"]];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    
    if (self.syncButton.selected) {
        //开始旋转
        [[MKBXPCentralManager shared] notifyLightSensorData:YES];
        [self.syncIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    [[MKBXPCentralManager shared] notifyLightSensorData:NO];
    self.syncLabel.text = @"Sync";
}

- (void)deleteButtonPressed {
    NSString *msg = @"Are you sure to erase all the saved light sensor status data？";
    MKAlertController *alertController = [MKAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    alertController.notificationName = @"mk_bxp_needDismissAlert";
    @weakify(self);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self deleteRecordDatas];
    }];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)exportButtonPressed {
    if (![MFMailComposeViewController canSendMail]) {
        //如果是未绑定有效的邮箱，则跳转到系统自带的邮箱去处理
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"MESSAGE://"]
                                           options:@{}
                                 completionHandler:nil];
        return;
    }
    NSData *emailData = [MKBLEBaseLogManager readDataWithFileName:@"LightSensorDatas"];
    if (!ValidData(emailData)) {
        [self.view showCentralToast:@"Log file does not exist"];
        return;
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *bodyMsg = [NSString stringWithFormat:@"APP Version: %@ + + OS: %@",
                         version,
                         kSystemVersionString];
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    //收件人
    [mailComposer setToRecipients:@[@"Development@mokotechnology.com"]];
    //邮件主题
    [mailComposer setSubject:@"Feedback of mail"];
    [mailComposer addAttachmentData:emailData
                           mimeType:@"application/txt"
                           fileName:@"LightSensorDatas.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

#pragma mark - interface
- (void)readDatasFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [[MKBXPCentralManager shared] notifyLightStatusData:YES];
        [self.headerView updateSensorStatus:self.dataModel.detected];
        [self.headerView updateCurrentTime:self.dataModel.date];
        NSData *localData = [MKBLEBaseLogManager readDataWithFileName:@"LightSensorDatas"];
        self.textView.text = [[NSString alloc] initWithData:localData encoding:NSUTF8StringEncoding];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)deleteRecordDatas {
    [MKBLEBaseLogManager deleteLogWithFileName:@"LightSensorDatas"];
    [self.textView setText:@""];
    self.syncButton.selected = NO;
    [self.syncIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    [[MKBXPCentralManager shared] notifyLightSensorData:self.syncButton.selected];
    self.syncLabel.text = @"Sync";
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_clearLightSensorDatasWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Empty successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (BOOL)saveDataToLocal:(NSString *)text {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject];
    NSString *localFileName = [NSString stringWithFormat:@"/%@.txt",@"LightSensorDatas"];
    NSString *filePath = [path stringByAppendingString:localFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
        
    BOOL directory = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&directory];
    
    if (!existed) {
        
        NSString *newFilePath = [path stringByAppendingPathComponent:localFileName];
        BOOL createResult = [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
        if (!createResult) {
            return NO;
        }
    }
    
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (error || !ValidDict(fileAttributes)) {
        return NO;
    }
    //写数据部分
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];   //将节点跳到文件的末尾
    NSData *stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData];
    [fileHandle closeFile];
    return YES;
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLightSensorDatas:)
                                                 name:mk_bxp_receiveLightSensorDataNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLightSensorStatus:)
                                                 name:mk_bxp_receiveLightSensorStatusDataNotification
                                               object:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Light sensor";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.right.mas_equalTo(0.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(200.f);
    }];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(self.headerView.mas_bottom).mas_offset(5.f);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10.f);
    }];
    [self.bottomView addSubview:self.syncButton];
    [self.bottomView addSubview:self.syncLabel];
    [self.syncButton addSubview:self.syncIcon];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.syncIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.bottomView addSubview:self.exportButton];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(50.f);
    }];
    [self.bottomView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-10.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.exportButton.mas_centerY);
        make.height.mas_equalTo(50.f);
    }];
    
    UILabel *timeLabel = [self loadTextLabel:@"Time"];
    UILabel *statusLabel = [self loadTextLabel:@"Sensor status"];
    
    [self.bottomView addSubview:timeLabel];
    [self.bottomView addSubview:statusLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(self.bottomView.mas_centerX).mas_offset(-15.f);
        make.top.mas_equalTo(self.syncLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomView.mas_centerX).mas_offset(-5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.syncLabel.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.bottomView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(timeLabel.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-10.f);
    }];
}

#pragma mark - getter
- (MKBXPLightSensorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXPLightSensorHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WHITE_MACROS;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 6.f;
    }
    return _bottomView;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTapAction:self selector:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UIImageView *)syncIcon {
    if (!_syncIcon) {
        _syncIcon = [[UIImageView alloc] init];
        _syncIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPLightSensorController", @"bxp_threeAxisAcceLoadingIcon.png");
    }
    return _syncIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (MKBXPLightSensorButtonView *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[MKBXPLightSensorButtonView alloc] init];
        MKBXPLightSensorButtonViewModel *model = [[MKBXPLightSensorButtonViewModel alloc] init];
        model.msg = @"Erase all";
        model.icon = LOADICON(@"MKBeaconXPlus", @"MKBXPLightSensorController", @"bxp_slotExportDeleteIcon.png");
        _deleteButton.dataModel = model;
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (MKBXPLightSensorButtonView *)exportButton {
    if (!_exportButton) {
        _exportButton = [[MKBXPLightSensorButtonView alloc] init];
        MKBXPLightSensorButtonViewModel *model = [[MKBXPLightSensorButtonViewModel alloc] init];
        model.msg = @"Export";
        model.icon = LOADICON(@"MKBeaconXPlus", @"MKBXPLightSensorController", @"bxp_slotExportEnableIcon.png");
        _exportButton.dataModel = model;
        [_exportButton addTarget:self
                          action:@selector(exportButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = COLOR_WHITE_MACROS;
        _textView.font = MKFont(12.f);
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = DEFAULT_TEXT_COLOR;
    }
    return _textView;
}

- (MKBXPLightSensorDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXPLightSensorDataModel alloc] init];
    }
    return _dataModel;
}

- (UILabel *)loadTextLabel:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.font = MKFont(13.f);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    return label;
}

@end
