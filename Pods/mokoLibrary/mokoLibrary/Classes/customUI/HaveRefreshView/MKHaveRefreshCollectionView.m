//
//  MKHaveRefreshCollectionView.m
//  mokoBaseUILibrary
//
//  Created by aa on 2018/8/28.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MKHaveRefreshCollectionView.h"
#import "MJRefresh.h"

@interface MKHaveRefreshCollectionView()

@property (nonatomic,assign)RequestType requestType;
@property (nonatomic,assign)NSUInteger  currentPage;
@property (nonatomic,assign)PLHaveRefreshSourceType sourceType;

@end

@implementation MKHaveRefreshCollectionView

- (instancetype)init{
    self = [super init];
    if (self) {
        _currentPage = 1;
        _requestType = REQUEST_REFRESH;
        _sourceType = PLHaveRefreshSourceTypeAll;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentPage = 1;
        _requestType = REQUEST_REFRESH;
        _sourceType = PLHaveRefreshSourceTypeAll;
        
        self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBeginRefresh)];
        self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBeginRefresh)];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout sourceType:(PLHaveRefreshSourceType)sourceType{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        _sourceType = sourceType;
        if (_sourceType == PLHaveRefreshSourceTypeAll)
            {
            self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBeginRefresh)];
            self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBeginRefresh)];
            }
        else if (_sourceType == PLHaveRefreshSourceTypeHeader){
            self.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerBeginRefresh)];
        }
        else if (_sourceType == PLHaveRefreshSourceTypeFooter){
            self.mj_footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerBeginRefresh)];
        }
        
        _currentPage = 1;
        _requestType = REQUEST_REFRESH;
    }
    
    return self;
}

#pragma mark - MKHaveRefreshViewProtocol

- (void)stopRefresh{
    if (_requestType == REQUEST_REFRESH) {
        [self.mj_header endRefreshing];
    }
    else{
        [self.mj_footer endRefreshing];
    }
}

#pragma mark - public method

- (void)setIdleImagesForHeader:(NSArray<UIImage *> *)idleImagesForHeader{
    _idleImagesForHeader = nil;
    _idleImagesForHeader = idleImagesForHeader;
    if (!_idleImagesForHeader || _idleImagesForHeader.count == 0) {
        return;
    }
    MJRefreshGifHeader *refreshHeader = (MJRefreshGifHeader *)self.mj_header;
    [refreshHeader setImages:_idleImagesForHeader forState:MJRefreshStateIdle];
    [refreshHeader setImages:_idleImagesForHeader forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [refreshHeader setImages:_idleImagesForHeader forState:MJRefreshStateRefreshing];
}

- (void)setIdleImagesForFooter:(NSArray<UIImage *> *)idleImagesForFooter{
    _idleImagesForFooter = nil;
    _idleImagesForFooter = idleImagesForFooter;
    if (!_idleImagesForFooter || _idleImagesForFooter.count == 0) {
        return;
    }
    MJRefreshBackGifFooter *refreshFooter = (MJRefreshBackGifFooter *)self.mj_footer;
    [refreshFooter setImages:_idleImagesForFooter forState:MJRefreshStateIdle];
    [refreshFooter setImages:_idleImagesForFooter forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [refreshFooter setImages:_idleImagesForFooter forState:MJRefreshStateRefreshing];
}

- (void)footerAutomaticRefresh{
    [self.mj_footer beginRefreshing];
}

- (void)headerAutomaticRefresh{
    [self.mj_header beginRefreshing];
}

#pragma custom method

- (void)headerBeginRefresh{
    self.requestType = REQUEST_REFRESH;
    self.currentPage = 1;
    if ([self.refreshDelegate respondsToSelector:@selector(refreshView:headBeginRefreshing:)]) {
        [self.refreshDelegate refreshView:self headBeginRefreshing:self.mj_header];
    }
}

- (void)footerBeginRefresh{
    self.requestType = OPERATE_LOADINGMORE;
    self.currentPage++;
    if ([self.refreshDelegate respondsToSelector:@selector(refreshView:footerBeginRefreshing:)]) {
        [self.refreshDelegate refreshView:self footerBeginRefreshing:self.mj_footer];
    }
}

@end
