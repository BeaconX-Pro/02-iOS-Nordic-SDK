/*
 抛出mk_customUIModule_dismissPickView通知可以让当前pickView消失
 [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPickerView : UIView

/// 当前pickView的数据源
@property (nonatomic, strong)NSArray <NSString *>*dataList;

/// 显示pickView
/// @param row 当前pickView选中的数据
/// @param block 用户点击了confirm按钮回调
- (void)showPickViewWithIndex:(NSInteger)row block:(void (^)(NSInteger currentRow))block;

/// 让pickView消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
