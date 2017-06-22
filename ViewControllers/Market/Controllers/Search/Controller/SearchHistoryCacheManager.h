//
//  SearchHistoryCacheManager.h
//  YunZhangTechnology
//
//  Created by 余彪 on 16/10/14.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockModel.h"
#import "ConfigHeader.h"
@interface SearchHistoryCacheManager : NSObject {
    YYCache *_searchHistoryYYCache;
}

/**
 存储搜索记录
 @param searchKeywordArray 搜索记录
 */
- (void)cacheSearchHistory:(NSMutableArray *)searchKeywordArray;

/**
 获取搜索记录
 @return 搜索记录
 */
- (NSMutableArray<StockModel *> *)searchHistoryKeywords;

/**
 移除缓存
 */
- (void)removeCache;

/**
 单例

 @return self
 */
+ (instancetype)shareInstance;

@end
