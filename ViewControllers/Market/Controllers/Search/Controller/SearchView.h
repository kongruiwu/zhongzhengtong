//
//  SearchView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/12.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryStockView.h"
#import "ResultStockView.h"

@interface SearchView : UIView{
    HistoryStockView *_historyView;
    ResultStockView  *_resultView;
}

@property (nonatomic,weak)id<FindStockDelegate> delegate;

/**
 搜索关键词结果
 @param keyword            关键词
 */
- (void)searchKeywords:(NSString *)keyword;

/**
 输入框清除输入，显示搜索页
 */
- (void)clearInputTxtForShowHistoryView;

@end
