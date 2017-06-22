//
//  SearchHistoryCacheManager.m
//  YunZhangTechnology
//
//  Created by 余彪 on 16/10/14.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import "SearchHistoryCacheManager.h"


static SearchHistoryCacheManager *shared = nil;
static NSString *kArchiverStaticKey = @"kArchiverStaticKey";


@implementation SearchHistoryCacheManager


#pragma mark - Public Method
#pragma mark 存储搜索记录
- (void)cacheSearchHistory:(NSMutableArray *)searchKeywordArray {
    NSMutableData *mulData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mulData];
    [archiver encodeObject:searchKeywordArray forKey:kArchiverStaticKey];
    [archiver finishEncoding];
    
    [_searchHistoryYYCache setObject:mulData forKey:@"kSearchHistoryCacheKey"];
}

#pragma mark 获取搜索历史
- (NSMutableArray<StockModel *> *)searchHistoryKeywords {
    NSData *cacheData = (NSData *)[_searchHistoryYYCache objectForKey:@"kSearchHistoryCacheKey"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:cacheData];
    NSMutableArray *keywordsArray = [unarchiver decodeObjectForKey:kArchiverStaticKey];
    [unarchiver finishDecoding];
    return keywordsArray;
}

#pragma mark 删除缓存
- (void)removeCache {
    [_searchHistoryYYCache removeObjectForKey:@"kSearchHistoryCacheKey"];
}


#pragma mark 初始化YYCache
- (void)initYYCache {
    if (!_searchHistoryYYCache) {
        _searchHistoryYYCache = [YYCache cacheWithName:@"kSearchHistoryYYCacheName"];
    }
}

#pragma mark 单例
+ (instancetype)shareInstance {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        if (shared == nil) {
            shared = [[super alloc] init];
            [shared initYYCache];
        }
    });
    
    return shared;
}

@end
