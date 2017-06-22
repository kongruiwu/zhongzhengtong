//
//  SearchView.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "SearchView.h"

@interface SearchView()<FindStockDelegate>

@end

@implementation SearchView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createUI];
    }
    
    return self;
}


#pragma mark - Private Method
#pragma mark 创建视图
- (void)createUI {
    [self showHistoryView];
}

#pragma mark - Public Method
#pragma mark 搜索关键词结果
- (void)searchKeywords:(NSString *)keyword {
    [self showResultView];
    [_resultView showStock:keyword];
}

#pragma mark 当清除输入框，显示浏览股票
- (void)clearInputTxtForShowHistoryView {
    [self showHistoryView];
}

#pragma mark 显示搜索历史
- (void)showHistoryView {
    if (!_historyView) {
        _historyView = [[HistoryStockView alloc] initWithFrame:self.bounds];
        _historyView.delegate = self;
    }
    
    if (!_historyView.superview) {
        [self addSubview:_historyView];
    }
    
    if (_resultView) {
        [_resultView removeFromSuperview];
    }
}

#pragma mark 显示搜索结果页
- (void)showResultView {
    if (!_resultView) {
        _resultView = [[ResultStockView alloc] initWithFrame:self.bounds];
        _resultView.delegate = self;
    }
    
    if (!_resultView.superview) {
        [self addSubview:_resultView];
    }
    
    if (_historyView) {
        [_historyView removeFromSuperview];
    }
}

#pragma mark - pushStockDetail 
- (void)pushStockDetailWithModel:(StockModel *)model{
    if ([self.delegate respondsToSelector:@selector(pushStockDetailWithModel:)]) {
        [self.delegate pushStockDetailWithModel:model];
    }
}




@end
