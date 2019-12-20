//
//  MKBaseViewController.m
//  FitPolo
//
//  Created by aa on 17/5/7.
//  Copyright © 2017年 MK. All rights reserved.
//

#import "MKBaseViewController.h"
#import "YYKit.h"
#import "WRNavigationBar.h"

#import "MKMacroDefines.h"
#import "MKCategoryModule.h"

@interface MKBaseViewController ()<UIGestureRecognizerDelegate>
/**
 *  标题label
 */
@property (nonatomic,strong) UILabel  *titleLabel;
/**
 *  左按钮
 */
@property (nonatomic,strong) UIButton *leftButton;
/**
 *  右按钮
 */
@property (nonatomic,strong) UIButton *rightButton;

@property (nonatomic, assign)MKNaviType naviType;

@end

@implementation MKBaseViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.naviType = MKNaviTypeShow;
    }
    return self;
}

- (instancetype)initWithNavigationType:(MKNaviType)type{
    self = [self init];
    if (self) {
        self.naviType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupNavigationParams];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:!(self.naviType == MKNaviTypeShow) animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - super method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([self isRootViewController]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - event method
-(void)leftButtonMethod{
    if (self.isPrensent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightButtonMethod{
    
}

#pragma mark - custom method

- (void)setupNavigationParams {
    self.view.backgroundColor = COLOR_WHITE_MACROS;
    [self wr_setNavBarBarTintColor:COLOR_BLUE_MARCROS];
    UIBarButtonItem *leftbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    [self.navigationItem setLeftBarButtonItem1:leftbuttonItem];
    UIBarButtonItem *rightbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem1:rightbuttonItem];
    self.navigationItem.titleView = self.titleLabel;
}

- (void)setDefaultTitle:(NSString *)defaultTitle {
    _defaultTitle = defaultTitle;
    self.titleLabel.text = (self.title == nil ? defaultTitle : self.title);
}

- (void)setCustom_naviBarColor:(UIColor *)custom_naviBarColor {
    [self wr_setNavBarBarTintColor:custom_naviBarColor];
}

- (UIColor *)custom_naviBarColor {
    return [self wr_navBarBarTintColor];
}

-(void)setNavigationBarImage:(UIImage*)image{
    if (iOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *image1 = [image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1)];
        [self.navigationController.navigationBar setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
    }
}

+ (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController{
    return (viewController.isViewLoaded && viewController.view.window);
}

- (void)popToViewControllerWithClassName:(NSString *)className{
    UIViewController *popController = nil;
    for (UIViewController *v in self.navigationController.viewControllers) {
        if ([v isKindOfClass:NSClassFromString(className)]) {
            popController = v;
            break;
        }
    }
    if (popController) {
        [self.navigationController popToViewController:popController animated:YES];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)isRootViewController{
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - setter & getter
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 2.0f, 40.0f, 40.0f)];
        
        NSBundle *curBundle = [NSBundle bundleForClass:self.class];
        //  *********** 重点 ***********   //
        NSString *curBundleName = curBundle.infoDictionary[@"CFBundleName"];
        NSString *curBundleDirectory = [NSString stringWithFormat:@"%@.bundle", curBundleName];
        NSString *normalImgPath = [curBundle pathForResource:@"navigation_back_button_white.png" ofType:nil inDirectory:curBundleDirectory];
        
        [_leftButton setImage:LOADICON(MKBASEBUNDLUEPATH, @"navigation_back_button_white.png")
                     forState:UIControlStateNormal];
        [_leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_leftButton.titleLabel setFont:MKFont(16)];
        [_leftButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_leftButton setTitleColor:RGBACOLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(leftButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.acceptEventInterval = 1.f;
        [_leftButton setNeedsLayout];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40.0f, 2.0f, 40.0f, 40.0f)];
        [_rightButton.titleLabel setFont:MKFont(16)];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGBACOLOR(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(rightButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.acceptEventInterval = 1.f;
        [_rightButton setNeedsLayout];
    }
    return _rightButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 7.0f, kScreenWidth - 120.0f, 30.0f)];
        _titleLabel.font = MKFont(18);
        _titleLabel.textColor = DEFAULT_TEXT_COLOR;
        _titleLabel.tintColor = DEFAULT_TEXT_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _titleLabel;
}

@end


