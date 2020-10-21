//
//  MKPickerView.h
//  mokoLibrary
//
//  Created by aa on 2020/10/7.
//

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
