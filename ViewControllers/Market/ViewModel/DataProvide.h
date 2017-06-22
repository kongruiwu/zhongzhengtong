//
//  DataProvide.h
//  GuShang
//
//  Created by JopYin on 2016/11/22.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSString *responseBody);
typedef void(^FailureBlock)(NSString *error);

@interface DataProvide : NSObject

@property (nonatomic, copy) NSString* strLoginIP;   //登陆的IP地址
@property (nonatomic, assign) BOOL isLogin;         //是否登陆成功

+ (DataProvide *) sharedStore;

- (BOOL)Login;

#pragma mark - POST请求函数
- (void)HTTPRequestOperation:(NSString *)requestURL ByPost:(NSDictionary*) parametersArray successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - GET请求函数
- (void)HTTPRequestOperationByGet:(NSString *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/******请求股票数据库******/
#pragma mark - 请求上证指数 所有的股票
- (void)getShangZhenExpWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock;

#pragma mark - 请求深证指数 所有的股票
- (void)getShenZhenExpWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock;

#pragma mark - 请求沪深A股所有的股票
- (void)getAllStockWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock;

#pragma mark - 请求上证A股
- (void)getShangZhenAGuWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock;

#pragma mark - 请求深证A股
- (void)getShenZhenAGuWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock;


/*********请求数据*************/
#pragma mark - 获取一支或多支股票的实时行情  urlString 传入股票类型+股票代码 如:sh600000 若多支股票：sh600000,sh600001     返回一个数组 里面包含QuetoModel
- (void)getShiShiDataWithURL:(NSString*)urlString success:(void (^)(NSArray *data))shiShiBlock failure:(void (^)(NSString *error))failBlock;

#pragma mark - 获取行情报价牌 -- 用的model：QuetoModel
- (void)getStockTypeDataWithParameters:(NSString *)urlString successBlock:(void (^)(NSArray *data))block failure:(void (^)(NSString* error))failBlock;

#pragma mark - 请求K线数据   -- 用的model：KLineMode
- (void)KLineData:(NSString *)urlString successBlock:(void(^)(id data))block failure:(void (^)(NSString *error))failBlock;

#pragma mark - 请求分时数据   --用的model:MinModel
- (void)MinData:(NSString *)stockCode successBlock:(void(^)(id data))block failure:(void(^)(NSString *error))failBlock;

#pragma mark - 请求分笔数据  --成交明细
- (void)FenBiData:(NSString *)stockCode successBlock:(void(^)(id data))block failure:(void(^)(NSString *error))failBlock;

@end
