//
//  MKPickerView.m
//  mokoLibrary
//
//  Created by aa on 2020/10/7.
//

#import "MKPickerView.h"
#import "MKMacroDefines.h"
#import "MKCustomUIAdopter.h"

static NSTimeInterval const animationDuration = .3f;
static CGFloat const kDatePickerH = 270;
static CGFloat const pickViewRowHeight = 30;

@interface MKPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UIPickerView *pickView;

@property (nonatomic, copy)void (^rowPickBlock)(NSInteger currentRow);

@property (nonatomic, assign)NSInteger currentRow;

@end

@implementation MKPickerView

- (void)dealloc {
    NSLog(@"MKDeviceSettingPickView销毁");
}

- (instancetype)init{
    if (self = [super init]) {
        self.frame = kAppWindow.bounds;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.pickView];
        [self addTapAction];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dismiss)
                                                     name:@"mk_customUIModule_dismissPickView"
                                                   object:nil];
    }
    return self;
}

#pragma mark - 代理方法

#pragma mark - UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return pickViewRowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataList.count;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleString = self.dataList[row];
    NSAttributedString *attributedString = [MKCustomUIAdopter attributedString:@[titleString] fonts:@[MKFont(15.f)] colors:@[DEFAULT_TEXT_COLOR]];
    return attributedString;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.currentRow = row;
}

#pragma mark - event Method

/**
 取消选择
 */
- (void)cancelButtonPressed{
    [self dismiss];
}

/**
 确认选择
 */
- (void)confirmButtonPressed{
    if (self.rowPickBlock) {
        self.rowPickBlock(self.currentRow);
    }
    [self dismiss];
}

- (void)dismiss
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark - Public Method

- (void)showPickViewWithIndex:(NSInteger)row block:(void (^)(NSInteger currentRow))block {
    [kAppWindow addSubview:self];
    self.rowPickBlock = block;
    self.currentRow = row;
    [self.pickView reloadAllComponents];
    [self.pickView selectRow:self.currentRow inComponent:0 animated:NO];
    [UIView animateWithDuration:animationDuration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -kDatePickerH);
    }];
}

#pragma mark - Private method
- (void)addTapAction {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - setter & getter
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               [UIScreen mainScreen].bounds.size.height,
                                                               [UIScreen mainScreen].bounds.size.width,
                                                               kDatePickerH)];
        _bottomView.backgroundColor = RGBCOLOR(244, 244, 244);
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        topView.backgroundColor = COLOR_WHITE_MACROS;
        [_bottomView addSubview:topView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(10, 10, 60, 30);
        [cancelButton setBackgroundColor:COLOR_CLEAR_MACROS];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:MKFont(16)];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancelButton];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 60, 10, 60, 30);
        [confirmBtn setBackgroundColor:COLOR_CLEAR_MACROS];
        [confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [confirmBtn.titleLabel setFont:MKFont(16)];
        [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:confirmBtn];
    }
    return _bottomView;
}

- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(10,
                                                                   kDatePickerH - 216,
                                                                   self.frame.size.width - 2 * 10,
                                                                   216)];
        // 显示选中框,iOS10以后分割线默认的是透明的，并且默认是显示的，设置该属性没有意义了，
        _pickView.showsSelectionIndicator = YES;
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.backgroundColor = COLOR_CLEAR_MACROS;
    }
    return _pickView;
}

@end
