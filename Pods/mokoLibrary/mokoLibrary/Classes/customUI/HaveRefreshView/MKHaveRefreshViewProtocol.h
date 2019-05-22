#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestType){
    REQUEST_REFRESH = 1,    //下拉刷新请求数据
    OPERATE_LOADINGMORE = 2 //上拉加载更多请求数据
};

typedef NS_ENUM(NSUInteger, PLHaveRefreshSourceType){
    PLHaveRefreshSourceTypeAll,     // 默认显示下拉刷新和上拉加载更多
    PLHaveRefreshSourceTypeHeader,  // 只显示下拉刷新
    PLHaveRefreshSourceTypeFooter,  // 只显示上拉加载更多
    PLHaveRefreshSourceTypeNone     // 都不显示
};

@protocol MKHaveRefreshViewProtocol <NSObject>

/**
 *  停止刷新
 */
- (void)stopRefresh;

#pragma 点击按钮自动开始刷新
/**
 *  footer自动开始刷新执行的方法
 */
- (void)footerAutomaticRefresh;

/**
 *  header自动开始刷新执行的方法
 */
- (void)headerAutomaticRefresh;

@optional
@property (nonatomic,assign, readonly)RequestType requestType;
@property (nonatomic,assign, readonly)NSUInteger  currentPage;
@property (nonatomic,assign, readonly)PLHaveRefreshSourceType sourceType;

@end

@protocol MKHaveRefreshViewDelegate <NSObject>

@optional
/**
 *  footer开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshView:(UIScrollView *)refreshView footerBeginRefreshing:(UIView *)footView;

/**
 *  header开始刷新执行的方法（写刷新逻辑）
 */
- (void)refreshView:(UIScrollView *)refreshView headBeginRefreshing:(UIView *)headView;

@end

