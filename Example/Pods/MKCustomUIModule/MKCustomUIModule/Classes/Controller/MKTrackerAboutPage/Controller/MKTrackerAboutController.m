/*
 
 
 */

#import "MKTrackerAboutController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

@interface MKTrackerAboutController ()

@property (nonatomic, strong)id <MKTrackerAboutParamsProtocol>protocol;

@property (nonatomic, strong)UIImageView *aboutIcon;

@property (nonatomic, strong)UILabel *appNameLabel;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UILabel *companyNameLabel;

@property (nonatomic, strong)UILabel *companyNetLabel;

@property (nonatomic, strong)UIImageView *bottomIcon;

@end

@implementation MKTrackerAboutController

- (void)dealloc {
    NSLog(@"MKTrackerAboutController销毁");
}

- (instancetype)initWithProtocol:(id<MKTrackerAboutParamsProtocol>)protocol {
    self = [self init];
    if (self) {
        self.protocol = protocol;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
}

#pragma mark - event method
- (void)openWebBrowser{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.mokosmart.com"]
                                       options:@{}
                             completionHandler:nil];
}

#pragma mark - ui
- (void)loadSubViews {
    if (![self.protocol conformsToProtocol:@protocol(MKTrackerAboutParamsProtocol)]) {
        return;
    }
    if (self.protocol.titleBarColor) {
        self.custom_naviBarColor = self.protocol.titleBarColor;
    }
    if (self.protocol.titleColor) {
        self.titleLabel.textColor = self.protocol.titleColor;
    }
    self.defaultTitle = (ValidStr(self.protocol.title) ? self.protocol.title : @"ABOUT");
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.aboutIcon];
    [self.view addSubview:self.appNameLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.bottomIcon];
    [self.view addSubview:self.companyNameLabel];
    [self.view addSubview:self.companyNetLabel];
    CGFloat aboutIconWidth = 0;
    CGFloat aboutIconHeight = 0;
    if (self.protocol.aboutIcon) {
        UIImage *image = self.protocol.aboutIcon;
        aboutIconWidth = image.size.width;
        aboutIconHeight = image.size.height;
        self.aboutIcon.image = self.protocol.aboutIcon;
    }
    CGFloat bottomIconWidth = 0;
    CGFloat bottomIconHeight = 0;
    if (self.protocol.bottomBackIcon) {
        UIImage *image = self.protocol.bottomBackIcon;
        bottomIconWidth = image.size.width;
        bottomIconHeight = image.size.height;
        self.bottomIcon.image = self.protocol.bottomBackIcon;
    }
    if (ValidStr(self.protocol.appName)) {
        self.appNameLabel.text = self.protocol.appName;
    }
    if (ValidStr(self.protocol.appVersion)) {
        self.versionLabel.text = [@"Version: V" stringByAppendingString:self.protocol.appVersion];
    }
    [self.aboutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(aboutIconWidth);
        make.top.mas_equalTo(defaultTopInset + 40.f);
        make.height.mas_equalTo(aboutIconHeight);
    }];
    [self.appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.aboutIcon.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(20.f).lineHeight);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.appNameLabel.mas_bottom).mas_offset(17.f);
        make.height.mas_equalTo(MKFont(16.f).lineHeight);
    }];
    [self.companyNetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.height.mas_equalTo(MKFont(16).lineHeight);
    }];
    [self.companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.companyNetLabel.mas_top).mas_offset(-17);
        make.height.mas_equalTo(MKFont(17).lineHeight);
    }];
    [self.bottomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(bottomIconWidth);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
        make.height.mas_equalTo(bottomIconHeight);
    }];
}

#pragma mark - setter & getter

- (UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc] init];
        _appNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.font = MKFont(20.f);
        _appNameLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    }
    return _appNameLabel;
}

- (UIImageView *)aboutIcon{
    if (!_aboutIcon) {
        _aboutIcon = [[UIImageView alloc] init];
    }
    return _aboutIcon;
}

- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = RGBCOLOR(189, 189, 189);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = MKFont(16.f);
        _versionLabel.text = [@"Version: V" stringByAppendingString:kAppVersion];
    }
    return _versionLabel;
}

- (UILabel *)companyNameLabel{
    if (!_companyNameLabel) {
        _companyNameLabel = [[UILabel alloc] init];
        _companyNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _companyNameLabel.textAlignment = NSTextAlignmentCenter;
        _companyNameLabel.font = MKFont(16.f);
        _companyNameLabel.text = @"MOKO TECHNOLOGY LTD.";
    }
    return _companyNameLabel;
}

- (UILabel *)companyNetLabel{
    if (!_companyNetLabel) {
        _companyNetLabel = [[UILabel alloc] init];
        _companyNetLabel.textAlignment = NSTextAlignmentCenter;
        _companyNetLabel.textColor = RGBCOLOR(3, 191, 234);
        _companyNetLabel.font = MKFont(16.f);
        _companyNetLabel.text = @"www.mokosmart.com";
        [_companyNetLabel addTapAction:self selector:@selector(openWebBrowser)];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = RGBCOLOR(3, 191, 234);
        [_companyNetLabel addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_companyNetLabel.mas_centerX);
            make.width.mas_equalTo(155);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _companyNetLabel;
}

- (UIImageView *)bottomIcon {
    if (!_bottomIcon) {
        _bottomIcon = [[UIImageView alloc] init];
        _bottomIcon.userInteractionEnabled = YES;
    }
    return _bottomIcon;
}

@end
