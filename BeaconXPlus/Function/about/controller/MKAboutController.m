//
//  MKAboutController.m
//  BeaconXPlus
//
//  Created by aa on 2019/5/23.
//  Copyright © 2019 MK. All rights reserved.
//

#import "MKAboutController.h"

static CGFloat const aboutIconWidth = 110.f;
static CGFloat const aboutIconHeight = 110.f;

@interface MKAboutController ()

@property (nonatomic, strong)UIImageView *aboutIcon;

@property (nonatomic, strong)UILabel *appNameLabel;

@property (nonatomic, strong)UILabel *versionLabel;

@property (nonatomic, strong)UILabel *companyNameLabel;

@property (nonatomic, strong)UILabel *companyNetLabel;

@end

@implementation MKAboutController

- (void)dealloc{
    NSLog(@"MKAboutController销毁");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    // Do any additional setup after loading the view.
}

#pragma mark - event method
- (void)openWebBrowser{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.mokosmart.com"]];
}

#pragma mark - ui
- (void)loadSubViews {
    self.custom_naviBarColor = UIColorFromRGB(0x2F84D0);
    self.defaultTitle = @"About";
    [self.rightButton setHidden:YES];
    [self.view addSubview:self.aboutIcon];
    [self.view addSubview:self.appNameLabel];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.companyNameLabel];
    [self.view addSubview:self.companyNetLabel];
    
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
}

#pragma mark - setter & getter

- (UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc] init];
        _appNameLabel.textColor = RGBCOLOR(5, 47, 115);
        _appNameLabel.textAlignment = NSTextAlignmentCenter;
        _appNameLabel.font = MKFont(20.f);
        _appNameLabel.text = [[NSBundle mainBundle].localizedInfoDictionary objectForKey:@"CFBundleDisplayName"];
    }
    return _appNameLabel;
}

- (UIImageView *)aboutIcon{
    if (!_aboutIcon) {
        _aboutIcon = [[UIImageView alloc] init];
        _aboutIcon.image = LOADIMAGE(@"aboutIcon", @"png");
    }
    return _aboutIcon;
}

- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = RGBCOLOR(189, 189, 189);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.font = MKFont(16.f);
        _versionLabel.text = [@"Version:" stringByAppendingString:kAppVersion];
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
        _companyNetLabel.textColor = RGBCOLOR(86, 145, 252);
        _companyNetLabel.font = MKFont(16.f);
        _companyNetLabel.text = @"www.mokosmart.com";
        [_companyNetLabel addTapAction:self selector:@selector(openWebBrowser)];
    }
    return _companyNetLabel;
}

@end
