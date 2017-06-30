//
//  SearchStock.h
//  NiuBa
//
//  Created by JopYin on 2016/10/28.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//  数据库指存放所有股票的库    自选股的是另外一个表

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "StockModel.h"

typedef  NS_ENUM(NSInteger, SearchResult) {
    NotAdd,
    AddSelf
};

@interface SearchStock : NSObject{
    FMDatabase *dataBase;
    FMDatabaseQueue *queue;
}

+ (SearchStock *)shareManager;

/***************************************操作stock表************************************************/
//在多线程中操作数据库
- (void)replaceStockInQueue:(StockModel *)model;
//请求写入数据库
- (void)replaceStock:(StockModel *)model;
//不输入条件显示默认的股票
- (NSMutableArray *)showDefaultStock;
//条件查找对应的股票 :输入数字 即按照股票代码查找
- (NSMutableArray *)searchStockCode:(NSString *)conditionStr;
//条件查找对应的股票 :输入字母 即按照简拼查找
- (NSMutableArray *)searchStockJP:(NSString *)conditionStr;
//根据isFav查找上证指数和深证指数的指数
- (NSMutableArray *)searchSHExp:(NSString * )isFav;
//根据isFav查找上证指数和深证指数的指数
- (NSMutableArray *)searchSZExp:(NSString * )isFav;

- (NSString *)searchStockName:(NSString *)stockCode;

/**查询股票简拼*/
- (NSString *)searchStockJPstring:(NSString *)stockCode;
// 条件查找对应的股票 :输入数字 即按照股票代码查找
- (StockModel *)searchModel:(NSString *)stockCode;

//根据股票代码确定此支股票是否为指数  YES即为指数，NO就是普通股票
- (NSInteger)searStockIsFav:(NSString *)stockCode;

/**************************************操作自选股favStock表*************************************************/
//增加
- (BOOL)insertToTable:(NSString *)stockCode;
//删除
- (BOOL)deleteToTable:(NSString *)stockCode;
//删除所有股票
- (BOOL)deleteAllStock;
//判断股票是否存在
- (BOOL)isExistInTable:(NSString *)stockCode;
//总计自选股表中总数
- (NSMutableArray *)allFavStock;

@end
