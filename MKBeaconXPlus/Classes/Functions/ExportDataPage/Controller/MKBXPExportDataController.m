//
//  MKBXPExportDataController.m
//  MKBeaconXPlus_Example
//
//  Created by aa on 2021/3/5.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXPExportDataController.h"

#import <MessageUI/MessageUI.h>
#import <sys/utsname.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXPCentralManager.h"
#import "MKBXPInterface+MKBXPConfig.h"

#import "MKBXPExportDataCurveView.h"

@interface MKBXPExportDataController ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UIView *topView;

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UILabel *deleteLabel;

@property (nonatomic, strong)UIButton *exportButton;

@property (nonatomic, strong)UILabel *exportLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *switchLabel;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)MKBXPExportDataCurveView *curveView;

/// 接收数据定时器，10s内没有新的数据到来就认为温湿度数据接收完毕
@property (nonatomic, strong)dispatch_source_t receiveTimer;

/// 10s内没有新的数据到来就认为温湿度数据接收完毕
@property (nonatomic, assign)NSInteger receiveCount;

@property (nonatomic, strong)NSMutableArray *temperatureList;

@property (nonatomic, strong)NSMutableArray *humidityList;

@end

@implementation MKBXPExportDataController

- (void)dealloc {
    NSLog(@"MKBXPExportDataController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:mk_bxp_receiveRecordHTDataNotification
                                                  object:nil];
    [[MKBXPCentralManager shared] notifyRecordTHData:NO];
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
    [MKBLEBaseLogManager deleteLogWithFileName:@"T&HDatas"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveRecordHTData:)
                                                 name:mk_bxp_receiveRecordHTDataNotification
                                               object:nil];
    // Do any additional setup after loading the view.
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

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    self.receiveCount = 0;
    //如果是开启监听，则不可切换列表和曲线
    self.switchButton.enabled = !self.syncButton.selected;
    if (self.syncButton.selected) {
        //开始旋转
        [self.temperatureList removeAllObjects];
        [self.humidityList removeAllObjects];
        [[MKBXPCentralManager shared] notifyRecordTHData:YES];
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        [self startReceiveTimer];
        if (self.switchButton.selected) {
            //已经显示了曲线图，再开始同步数据的时候必须显示列表
            [self switchButtonPressed];
        }
        return;
    }
    [[MKBXPCentralManager shared] notifyRecordTHData:NO];
    self.syncLabel.text = @"Sync";
    if (self.receiveTimer) {
        dispatch_cancel(self.receiveTimer);
    }
}

- (void)deleteButtonPressed {
    NSString *msg = @"Are you sure to empty the saved T&H datas？";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning!"
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteRecordDatas];
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
    NSData *emailData = [MKBLEBaseLogManager readDataWithFileName:@"/T&HDatas"];
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
                           fileName:@"T&HDatas.txt"];
    [mailComposer setMessageBody:bodyMsg isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_exportHT_curveSelected.png") : LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_exportHT_tableSelected.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
    if (self.switchButton.selected) {
        //显示曲线图
        [UIView animateWithDuration:.3f animations:^{
            self.textView.frame = CGRectMake(-(kViewWidth - 10.f), 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f);
            self.curveView.frame = CGRectMake(10.f, 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f);
        } completion:^(BOOL finished) {
            [self drawHTCurveView];
        }];
        return;
    }
    //显示textView
    [UIView animateWithDuration:.3f animations:^{
        self.textView.frame = CGRectMake(10.f, 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f);
        self.curveView.frame = CGRectMake(kViewWidth - 10.f, 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - note
- (void)receiveRecordHTData:(NSNotification *)note {
    NSArray *dataList = note.userInfo[@"dataList"];
    NSDictionary *dic = [dataList lastObject];
    NSString *temperature = [NSString stringWithFormat:@"%@%@",dic[@"temperature"],@"℃"];
    if (ValidStr(dic[@"temperature"])) {
        [self.temperatureList addObject:dic[@"temperature"]];
    }
    NSString *humidity = [NSString stringWithFormat:@"%@%@",dic[@"humidity"],@"%"];
    if (ValidStr(dic[@"humidity"])) {
        [self.humidityList addObject:dic[@"humidity"]];
    }
    NSArray *dateList = [dic[@"date"] componentsSeparatedByString:@"-"];
    NSString *dateString = [NSString stringWithFormat:@"%@/%@/%@    %@:%@:%@",dateList[0],dateList[1],dateList[2],dateList[3],dateList[4],dateList[5]];
    NSString *text = [NSString stringWithFormat:@"\n%@  %@  %@",dateString,temperature,humidity];
    [MKBLEBaseLogManager saveDataWithFileName:@"T&HDatas" dataList:@[text]];
    self.textView.text = [self.textView.text stringByAppendingString:text];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    self.receiveCount = 0;
}

#pragma mark - interface
- (void)deleteRecordDatas {
    [MKBLEBaseLogManager deleteLogWithFileName:@"/T&HDatas"];
    [self.textView setText:@""];
    self.syncButton.selected = NO;
    [self.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
    [[MKBXPCentralManager shared] notifyRecordTHData:self.syncButton.selected];
    self.syncLabel.text = @"Sync";
    [[MKHudManager share] showHUDWithTitle:@"Setting..." inView:self.view isPenetration:NO];
    [MKBXPInterface bxp_deleteBXPRecordHTDatasWithSucBlock:^(id  _Nonnull returnData) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Empty successfully!"];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (void)startReceiveTimer {
    self.receiveTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.receiveTimer, dispatch_time(DISPATCH_TIME_NOW, 1.f * NSEC_PER_SEC),  1.f * NSEC_PER_SEC, 0);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.receiveTimer, ^{
        __strong typeof(self) sself = weakSelf;
        sself.receiveCount ++;
        if (sself.receiveCount == 10) {
            //超时没有接收到数据，认为数据接收完毕
            moko_dispatch_main_safe(^{
                dispatch_cancel(sself.receiveTimer);
                sself.syncButton.selected = !sself.syncButton.selected;
                [sself.synIcon.layer removeAnimationForKey:@"synIconAnimationKey"];
                [[MKBXPCentralManager shared] notifyRecordTHData:sself.syncButton.selected];
                sself.syncLabel.text = @"Sync";
                sself.switchButton.enabled = YES;
            });
            return;
        }
    });
    dispatch_resume(self.receiveTimer);
}

- (void)drawHTCurveView {
    [[MKHudManager share] showHUDWithTitle:@"Loading..." inView:self.view isPenetration:NO];
    [self.curveView updateTemperatureDatas:self.temperatureList
                            temperatureMax:[[self.temperatureList valueForKeyPath:@"@max.floatValue"] floatValue]
                            temperatureMin:[[self.temperatureList valueForKeyPath:@"@min.floatValue"] floatValue]
                              humidityList:self.humidityList
                               humidityMax:[[self.humidityList valueForKeyPath:@"@max.floatValue"] floatValue]
                               humidityMin:[[self.humidityList valueForKeyPath:@"@min.floatValue"] floatValue]
                             completeBlock:^{
        [[MKHudManager share] hide];
    }];
}

#pragma mark - UI

- (void)loadSubViews {
    self.defaultTitle = @"Export T&H Data";
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self.view addSubview:self.backView];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(defaultTopInset + 10.f);
        make.bottom.mas_equalTo(-VirtualHomeHeight - 10.f);
    }];
    [self.backView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(50.f);
    }];
    [self.topView addSubview:self.syncButton];
    [self.syncButton addSubview:self.synIcon];
    [self.topView addSubview:self.syncLabel];
    [self.topView addSubview:self.switchButton];
    [self.topView addSubview:self.switchLabel];
    [self.topView addSubview:self.deleteButton];
    [self.topView addSubview:self.deleteLabel];
    [self.topView addSubview:self.exportButton];
    [self.topView addSubview:self.exportLabel];
    [self.syncButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.switchButton.mas_left);
        make.right.mas_equalTo(self.switchButton.mas_right);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.exportButton.mas_left).mas_offset(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.deleteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteButton.mas_left);
        make.right.mas_equalTo(self.deleteButton.mas_right);
        make.top.mas_equalTo(self.deleteButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.exportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.exportButton.mas_left);
        make.right.mas_equalTo(self.exportButton.mas_right);
        make.top.mas_equalTo(self.exportButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    
    [self.backView addSubview:self.textView];
    [self.backView addSubview:self.curveView];
}

#pragma mark - setter & getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _topView;
}

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTapAction:self selector:@selector(syncButtonPressed)];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_threeAxisAcceLoadingIcon.png");
        _synIcon.userInteractionEnabled = YES;
    }
    return _synIcon;
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

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_switchButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_exportHT_tableSelected.png") forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] init];
        _switchLabel.textColor = DEFAULT_TEXT_COLOR;
        _switchLabel.textAlignment = NSTextAlignmentCenter;
        _switchLabel.font = MKFont(10.f);
        _switchLabel.text = @"Display";
    }
    return _switchLabel;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_slotExportDeleteIcon.png") forState:UIControlStateNormal];
        [_deleteButton addTapAction:self selector:@selector(deleteButtonPressed)];
    }
    return _deleteButton;
}

- (UILabel *)deleteLabel {
    if (!_deleteLabel) {
        _deleteLabel = [[UILabel alloc] init];
        _deleteLabel.textColor = DEFAULT_TEXT_COLOR;
        _deleteLabel.textAlignment = NSTextAlignmentCenter;
        _deleteLabel.font = MKFont(10.f);
        _deleteLabel.text = @"Empty";
    }
    return _deleteLabel;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportButton setImage:LOADICON(@"MKBeaconXPlus", @"MKBXPExportDataController", @"bxp_slotExportEnableIcon.png") forState:UIControlStateNormal];
        [_exportButton addTapAction:self selector:@selector(exportButtonPressed)];
    }
    return _exportButton;
}

- (UILabel *)exportLabel {
    if (!_exportLabel) {
        _exportLabel = [[UILabel alloc] init];
        _exportLabel.textColor = DEFAULT_TEXT_COLOR;
        _exportLabel.textAlignment = NSTextAlignmentCenter;
        _exportLabel.font = MKFont(10.f);
        _exportLabel.text = @"Export";
    }
    return _exportLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10.f, 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f)];
        _textView.font = [UIFont systemFontOfSize:13.f];
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.editable = NO;
        _textView.textColor = [UIColor blackColor];
        
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.cornerRadius = 2.f;
        _textView.layer.borderColor = [UIColor colorWithRed:227.0 / 255 green:227.0 / 255 blue:227.0 / 255 alpha:1].CGColor;
    }
    return _textView;
}

- (MKBXPExportDataCurveView *)curveView {
    if (!_curveView) {
        _curveView = [[MKBXPExportDataCurveView alloc] initWithFrame:CGRectMake(kViewWidth - 10.f, 60.f, kViewWidth - 30.f, kViewHeight - defaultTopInset - 70.f)];
    }
    return _curveView;
}

- (NSMutableArray *)temperatureList {
    if (!_temperatureList) {
        _temperatureList = [NSMutableArray array];
    }
    return _temperatureList;
}

- (NSMutableArray *)humidityList {
    if (!_humidityList) {
        _humidityList = [NSMutableArray array];
    }
    return _humidityList;
}

@end