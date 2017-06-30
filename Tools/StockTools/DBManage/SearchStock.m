//
//  SearchStock.m
//  NiuBa
//
//  Created by JopYin on 2016/10/28.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "SearchStock.h"

@implementation SearchStock
#pragma mark- GCD的写法  只实例化一次
+ (SearchStock *)shareManager {
    static SearchStock *DB = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (DB == nil) {
            DB = [[SearchStock alloc] init];
        }
    });
    return DB;
}

- (id)init{
    if (self = [super init]) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *sqlFilePath = [path stringByAppendingPathComponent:@"Company.sqlite"];
        NSLog(@"数据库路径:%@",sqlFilePath);
        dataBase = [FMDatabase databaseWithPath:sqlFilePath];
        queue = [FMDatabaseQueue databaseQueueWithPath:sqlFilePath];
        if ([dataBase open]) {
            // 打开成功就创建一个stock
            NSString *createStock = @"create table if not exists stock(nid integer PRIMARY KEY AUTOINCREMENT,stockCode text UNIQUE,stockName text,JP text,isFav boolean)";
            NSString *createFav = @"create table if not exists favStock(nid integer PRIMARY KEY AUTOINCREMENT,stockCode text,stockName text)";
            if (![dataBase executeUpdate:createStock]) {
                NSLog(@"创建表stock失败:%@",[dataBase lastErrorMessage]);
            }
            if (![dataBase executeUpdate:createFav]) {
                NSLog(@"创建表favStock失败:%@",[dataBase lastErrorMessage]);
            }
        }
    }
    return self;
}

/*********************************对stock表的查询操作**************************************/
#pragma mark - 在多线程中使用
- (void)replaceStockInQueue:(StockModel *)model{
    NSString *sql = [NSString stringWithFormat:@"replace into stock(stockCode,stockName,JP,isFav) values('%@','%@','%@','%ld')",model.stockCode,model.stockName,model.JP,model.isFav];
    [queue inDatabase:^(FMDatabase *db) {
        BOOL sucess = [db executeUpdate:sql];
        if (!sucess) {
            NSLog(@"加入数据失败:%@",[dataBase lastErrorMessage]);
        }
    }];
}

#pragma mark - 插入新股票到数据表stock中
- (void)replaceStock:(StockModel *)model {
    NSString *sql = [NSString stringWithFormat:@"replace into stock(stockCode,stockName,JP,isFav) values('%@','%@','%@','%ld')",model.stockCode,model.stockName,model.JP,model.isFav];
    BOOL sucess = [dataBase executeUpdate:sql];
    if (!sucess) {
        NSLog(@"加入数据失败:%@",[dataBase lastErrorMessage]);
    }
}

#pragma mark - 对stock表的查询操作
#pragma mark- 不输入任何条件显示默认的股票
- (NSMutableArray *)showDefaultStock{
    NSMutableArray *dataArr = [NSMutableArray array];
    FMResultSet *resultSet = [dataBase executeQuery:@"select * from stock where stockCode like '0000%'"];
    while (resultSet.next) {
        StockModel * stockModel = [[StockModel alloc] init];
//        stockModel.isFav = [resultSet boolForColumn:@"isFav"];
        stockModel.isFav = [resultSet intForColumn:@"isFav"];
        stockModel.stockCode = [resultSet stringForColumn:@"stockCode"];
        stockModel.stockName = [resultSet stringForColumn:@"stockName"];
        [dataArr addObject:stockModel];
    }
    return dataArr;
}
#pragma mark- 条件查找对应的股票 :输入数字 即按照股票代码查找
- (NSMutableArray *)searchStockCode:(NSString *)conditionStr{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from stock where stockCode like '%%%@%%'",conditionStr];
    FMResultSet *resultSet = [dataBase executeQuery:sql];
    while (resultSet.next) {
        StockModel * stockModel = [[StockModel alloc] init];
//        stockModel.isFav = [resultSet boolForColumn:@"isFav"];
        stockModel.isFav = [resultSet intForColumn:@"isFav"];
        stockModel.stockCode = [resultSet stringForColumn:@"stockCode"];
        stockModel.stockName = [resultSet stringForColumn:@"stockName"];
        [dataArr addObject:stockModel];
    }
    return dataArr;
}
#pragma mark- 条件查找对应的股票 :输入字母 即按照简拼查找
- (NSMutableArray *)searchStockJP:(NSString *)conditionStr{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"select * from stock where JP like '%%%@%%'",conditionStr];
    FMResultSet *resultSet = [dataBase executeQuery:sql];
    while (resultSet.next) {
        StockModel * stockModel = [[StockModel alloc] init];
//        stockModel.isFav = [resultSet boolForColumn:@"isFav"];
        stockModel.isFav = [resultSet intForColumn:@"isFav"];
        stockModel.stockCode = [resultSet stringForColumn:@"stockCode"];
        stockModel.stockName = [resultSet stringForColumn:@"stockName"];
        [dataArr addObject:stockModel];
    }
    return dataArr;
}

#pragma mark- 根据isFav查找上证指数和深证指数的指数
- (NSMutableArray *)searchSHExp:(NSString * )isFav{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"select * from stock where isFav = '%@'",isFav];
    FMResultSet *resultSet = [dataBase executeQuery:str];
    while (resultSet.next) {
        NSString * stockCode =[NSString stringWithFormat:@"sh%@,",[resultSet stringForColumn:@"stockCode"]];
        [dataArr addObject:stockCode];
    }
    return dataArr;
}
#pragma mark- 根据isFav查找上证指数和深证指数的指数
- (NSMutableArray *)searchSZExp:(NSString * )isFav{
    NSMutableArray *dataArr = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"select * from stock where isFav = '%@'",isFav];
    FMResultSet *resultSet = [dataBase executeQuery:str];
    while (resultSet.next) {
        NSString * stockCode =[NSString stringWithFormat:@"sz%@,",[resultSet stringForColumn:@"stockCode"]];
        [dataArr addObject:stockCode];
    }
    return dataArr;
}

#pragma mark - 根据股票代码返回对应的股票名称
- (NSString *)searchStockName:(NSString *)stockCode{
    NSString *stockName = @"";
    NSString *sql = [NSString stringWithFormat:@"select * from stock where stockCode = '%@'",stockCode];
    FMResultSet *requestSet = [dataBase executeQuery:sql];
    while (requestSet.next) {
         stockName = [requestSet stringForColumn:@"stockName"];
        
    }
    return stockName;
}
#pragma mark - 根据股票代码返回对应的股票名称
- (NSString *)searchStockJPstring:(NSString *)stockCode{
    NSString *stockJP = @"";
    NSString *sql = [NSString stringWithFormat:@"select * from stock where stockCode = '%@'",stockCode];
    FMResultSet *requestSet = [dataBase executeQuery:sql];
    while (requestSet.next) {
        stockJP = [requestSet stringForColumn:@"JP"];
        
    }
    return stockJP;
}

#pragma mark- 条件查找对应的股票 :输入数字 即按照股票代码查找
- (StockModel *)searchModel:(NSString *)stockCode{
    StockModel * stockModel = [[StockModel alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from stock where stockCode = '%@'",stockCode];
    FMResultSet *resultSet = [dataBase executeQuery:sql];
    while (resultSet.next) {
        //        stockModel.isFav = [resultSet boolForColumn:@"isFav"];
        stockModel.isFav = [resultSet intForColumn:@"isFav"];
        stockModel.stockCode = [resultSet stringForColumn:@"stockCode"];
        stockModel.stockName = [resultSet stringForColumn:@"stockName"];
        stockModel.JP = [resultSet stringForColumn:@"JP"];
    }
    return stockModel;
}

#pragma mark - 根据股票代码确定是不是指数
- (NSInteger)searStockIsFav:(NSString *)stockCode{
    NSInteger isFav = 0;
    NSString *sql = [NSString stringWithFormat:@"select * from stock where stockCode = '%@'",stockCode];
    FMResultSet *requestSet = [dataBase executeQuery:sql];
    while (requestSet.next) {
        
        isFav = [requestSet intForColumn:@"isFav"];
    }
    return isFav;
}
/*********************************对自选股favStock表的操作**************************************/
#pragma mark - 对favStock表操作
#pragma mark - 增加自选股
- (BOOL)insertToTable:(NSString *)stockCode {
    NSString *sql = [NSString stringWithFormat:@"insert into favStock(stockCode, stockName) select stockCode,stockName from stock where stockCode = '%@'",stockCode];
    BOOL isFinish = [dataBase executeUpdate:sql];
    
    if (!isFinish) {
        NSLog(@"删除失败:%@",[dataBase lastErrorMessage]);
    }
    return isFinish;
}
#pragma mark - 删除自选股
- (BOOL)deleteToTable:(NSString *)stockCode{
    NSString *sql = [NSString stringWithFormat:@"delete from favStock where stockCode = '%@'",stockCode];
    BOOL isFinish = [dataBase executeUpdate:sql];
    if (!isFinish) {
        NSLog(@"删除失败:%@",[dataBase lastErrorMessage]);
    }
    return isFinish;
}
#pragma mark - 删除所有股票
- (BOOL)deleteAllStock{
    NSString *sql = @"delete from favStock";
    BOOL isFinish = [dataBase executeUpdate:sql];
    if (!isFinish) {
        NSLog(@"删除失败:%@",[dataBase lastErrorMessage]);
    }
    return isFinish;
}
#pragma mark - 查询某只股票是否在表favStock中
- (BOOL)isExistInTable:(NSString *)stockCode {
    NSString *sql = [NSString stringWithFormat:@"select stockCode from favStock where stockCode = '%@'",stockCode];
    FMResultSet *result = [dataBase executeQuery:sql];
    return [result next];
}

#pragma mark - 总计自选股表中总数
- (NSMutableArray *)allFavStock {
    NSMutableArray *favStockArr = [NSMutableArray array];
    NSString *sql = @"select * from favStock";
    FMResultSet *resultSet = [dataBase executeQuery:sql];
    while (resultSet.next) {
        StockModel *model = [[StockModel alloc] init];
        model.stockCode = [resultSet stringForColumn:@"stockCode"];
        model.stockName = [resultSet stringForColumn:@"stockName"];
        [favStockArr addObject:model];
    }
    return favStockArr;
}
@end
