/*
 抛出mk_customUIModule_dismissPickView通知可以让当前pickView消失
 [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKPickerView : UIView

/// 显示pickView
/// @param dataList pickView的数据列表
/// @param selectedRow 列表显示的时候选中的row
/// @param block 用户点击了confirm按钮的选中回调
- (void)showPickViewWithDataList:(NSArray <NSString *>*)dataList
                     selectedRow:(NSInteger)selectedRow
                           block:(void (^)(NSInteger currentRow))block;

/// 让pickView消失
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
