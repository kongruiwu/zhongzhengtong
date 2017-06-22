//
//  DataProvide.m
//  GuShang
//
//  Created by JopYin on 2016/11/22.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import "DataProvide.h"
#import "QuoteModel.h"
#import "KLineModel.h"
#import "MinModel.h"
#import "FenBiModel.h"
#import "ConfigHeader.h"

@interface DataProvide()

@end

@implementation DataProvide

+(DataProvide*) sharedStore {
    static DataProvide *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

- (id)init {
    if (self = [super init]){
        [self Login];
    }
    return self ;
}

-(BOOL)Login {
    //取随机数
    int randomNum = arc4random() % 2;
    const char * cString = "http://webhq.700000.cc:5432";
    const char * otherString = "http://hangqing.ihuangpu.com:5432";
    if (randomNum == 0){
        _strLoginIP = [NSString stringWithUTF8String:cString];
    }else{
        _strLoginIP = [NSString stringWithUTF8String:otherString];
    }
    
    _isLogin = [self LoginRequest:_strLoginIP];
    
    if (_isLogin)
    {
        return YES;
    }else{
        if ([_strLoginIP isEqualToString:[NSString stringWithUTF8String:cString]]){
            _strLoginIP = [NSString stringWithUTF8String:otherString];
        }else{
            _strLoginIP = [NSString stringWithUTF8String:cString];
        }
        _isLogin = [self LoginRequest:_strLoginIP];
    }
    return _isLogin;
}

-(BOOL) LoginRequest: (NSString*) strServer {
    NSInteger nCount = 0;
    
    NSString *strLoginUrl = [NSString stringWithFormat:@"%@/ManageAuth.ashx?p=trds033}trds033",strServer];
    
    NSURL *url = [NSURL URLWithString: [strLoginUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSError *error = nil;
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    while (1)
    {
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        
        if([str isEqualToString:@"s=0"])
        {
            return YES;
        }
        else
        {
            nCount++;
            if (nCount == 3)
            {
                return NO;
            }
        }
    }
    return YES;
}


- (void)HTTPRequestOperationByGet:(NSString *)requestURL successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    if (requestURL.length <= 0)
    {
        return ;
    }
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    //设置超时时间，默认为60秒
    [manage.requestSerializer setTimeoutInterval:20];
    //设置返回数据的数据序列，默认为JSON
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    NSString* strURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manage GET:strURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        successBlock(responStr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}


-(void)HTTPRequestOperation:(NSString *)requestURL ByPost:(NSDictionary*) parametersArray successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    if (requestURL.length <= 0)
    {
        return;
    }
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    //设置超时时间，默认为60秒
    [manage.requestSerializer setTimeoutInterval:20];
    //设置返回数据的数据序列，默认为JSON
    //manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    NSString* strURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manage POST:strURL parameters:parametersArray constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

#pragma mark - 获取股票实时数据  适用处理一支或者多支股票的情况  model:quoteModel
- (void)getShiShiDataWithURL:(NSString*)urlString success:(void (^)(NSArray *data))shiShiBlock failure:(void (^)(NSString *error))failBlock{
    NSString *string = [NSString stringWithFormat:@"%@/GetQuote.ashx?symbol=%@",_strLoginIP,urlString];
    [self HTTPRequestOperationByGet:string successBlock:^(NSString * responseBody){
        NSMutableArray *dataArray = [NSMutableArray array];
        if (responseBody.length > 30) {
            NSArray *array = [responseBody componentsSeparatedByString:NSLocalizedString(@"\";", nil)];
            for (int i = 0; i<array.count-1; i++) {
                QuoteModel *quoteModel = [[QuoteModel alloc] init];
                NSArray *singleData   = [array[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@","]];
                NSArray *nameArr = [singleData[0] componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@"=\""]];
                NSString *codeStr = nameArr[0];
                quoteModel.stockName  = nameArr[2];
                quoteModel.stockCode  = [codeStr substringWithRange:NSMakeRange(codeStr.length-6, 6)];
                quoteModel.openPrice  = singleData[1];
                quoteModel.closePrice = singleData[2];
                quoteModel.price      = singleData[3];
                quoteModel.highPrice  = singleData[4];
                quoteModel.lowPrice   = singleData[5];
                quoteModel.VOL    = singleData[6];
                quoteModel.amount = singleData[7];
                quoteModel.change = [NSString stringWithFormat:@"%.2lf",[singleData[3] floatValue] - [singleData[2] floatValue]];
                quoteModel.changeRate   =[NSString stringWithFormat:@"%.2lf%%",([singleData[3] floatValue] - [singleData[2] floatValue])*100/[singleData[2] floatValue]];
                
                //五档行情，从singleData[8]开始 - singleData[27]
                //五档行情的买的申请量 singleData[8] singleData[10] singleData[12] singleData[14] singleData[16]
                //五档行情的买价 singleData[9] singleData[11] singleData[13] singleData[15] singleData[17]
                for (int i = 4; i < 9; i++){
                    [quoteModel.buyVOL   addObject: singleData[2*i]];
                    [quoteModel.buyPrice addObject: singleData[2*i + 1]];
                }
                //五档行情的卖申请量 singleData[18] singleData[20] singleData[22] singleData[24] singleData[26]
                //五档行情的卖价 singleData[19] singleData[21] singleData[23] singleData[25] singleData[27]
                for (int i = 9; i < 14; i++){
                    [quoteModel.sellVOL addObject:singleData[2 * i]];
                    [quoteModel.sellPrice addObject:singleData[2 * i + 1]];
                }
                quoteModel.time = singleData[28];
                [dataArray addObject:quoteModel];
            }
        }
        shiShiBlock(dataArray);
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 获取上证指数
- (void)getShangZhenExpWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetBlock.ashx?stocktype=0",_strLoginIP];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString* responseBody) {
        NSString *resultStr = [responseBody substringToIndex:responseBody.length-2];
        if (resultStr.length > 20) {
            NSMutableArray *array = [self analysisWith:resultStr];
            block(array);
        }
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 请求上证A股
- (void)getShangZhenAGuWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetBlock.ashx?stocktype=1",_strLoginIP];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString* responseBody) {
        NSString *resultStr = [responseBody substringToIndex:responseBody.length-2];
        if (resultStr.length > 20) {
            NSMutableArray *array = [self analysisWith:resultStr];
            block(array);
        }
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 请求深证指数
- (void)getShenZhenExpWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetBlock.ashx?stocktype=3",_strLoginIP];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString* responseBody) {
        NSString *resultStr = [responseBody substringToIndex:responseBody.length-2];
        if (resultStr.length > 20) {
            NSMutableArray *array = [self analysisWith:resultStr];
            block(array);
        }
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 请求深证A股
- (void)getShenZhenAGuWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetBlock.ashx?stocktype=4",_strLoginIP];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString* responseBody) {
        NSString *resultStr = [responseBody substringToIndex:responseBody.length-2];
        if (resultStr.length > 20) {
            NSMutableArray *array = [self analysisWith:resultStr];
            block(array);
        }
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 请求沪深A股  包含上证A股+深证A股+中小板+创业板
- (void)getAllStockWithBlock:(void (^)(id data))block failure:(void (^)(NSString *error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetBlock.ashx?stocktype=13",_strLoginIP];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString* responseBody) {
        NSString *resultStr = [responseBody substringToIndex:responseBody.length-2];
        if (resultStr.length > 20) {
            NSMutableArray *array = [self analysisWith:resultStr];
            block(array);
        }
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 解析数据 -只针对返回数据中有股票代码、名称、简拼，并不能处理行情数据
- (NSMutableArray *)analysisWith:(NSString *)resultStr {
    NSMutableArray *stocksArray = [NSMutableArray array];
    NSArray *allStock = [resultStr componentsSeparatedByString:NSLocalizedString(@"\",\"", nil)];
    for (int i = 0; i < allStock.count; i++) {
        NSArray *stockArray = [allStock[i] componentsSeparatedByCharactersInSet: [NSCharacterSet  characterSetWithCharactersInString:@","]]; //SH 股票代码  股票名称 简拼
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:stockArray[1] forKey:@"stockCode"];
        [dic setObject:stockArray[2] forKey:@"stockName"];
        [dic setObject:stockArray[3] forKey:@"JP"];
        [stocksArray addObject:dic];
    }
    return stocksArray;
}

#pragma mark - 获取行情报价牌 --  model:quoteModel
- (void)getStockTypeDataWithParameters:(NSString *)urlString successBlock:(void (^)(NSArray * data))block failure:(void (^)(NSString* error))failBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetQuoteList.ashx?%@",_strLoginIP,urlString];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    //设置超时时间，默认为60秒
    [manage.requestSerializer setTimeoutInterval:20];
    //设置返回数据的数据序列，默认为JSON
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html",@"application/javascript",@"application/json", nil];
    
    NSString* strURL = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manage GET:strURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *dataArray = [NSMutableArray array];
        NSString *responStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (responStr.length > 30) { //30只是一个长度，这个值后期还要仔细考虑
            NSArray *array = [responStr componentsSeparatedByString:NSLocalizedString(@"\",\"", nil)];  //分割多支股票数据
            for (int i = 0; i<array.count; i++) {
                QuoteModel *quoteModel = [[QuoteModel alloc] init];
                NSArray *singleData   = [array[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@",?"]];
                quoteModel.stockName  = singleData[2];
                quoteModel.stockCode  = singleData[1];
                quoteModel.openPrice  = singleData[3];
                quoteModel.closePrice = singleData[4];
                quoteModel.price      = singleData[5];
                quoteModel.highPrice  = singleData[6];
                quoteModel.lowPrice   = singleData[7];
                quoteModel.VOL    = singleData[8];
                quoteModel.amount = singleData[9];
                quoteModel.change = [NSString stringWithFormat:@"%.2lf",[singleData[5] floatValue] - [singleData[4] floatValue]];
                quoteModel.changeRate   =[NSString stringWithFormat:@"%.2lf%%",([singleData[5] floatValue] - [singleData[4] floatValue])*100/[singleData[4] floatValue]];
                
                //五档行情，从singleData[10]开始 - singleData[29]
                //五档行情的买的申请量 singleData[10] singleData[12] singleData[14] singleData[16] singleData[18]
                //五档行情的买价 singleData[11] singleData[13] singleData[15] singleData[17] singleData[19]
                for (int i = 5; i < 10; i++){
                    [quoteModel.buyVOL   addObject: singleData[2*i]];
                    [quoteModel.buyPrice addObject: singleData[2*i + 1]];
                }
                //五档行情的卖申请量 singleData[20] singleData[22] singleData[24] singleData[26] singleData[28]
                //五档行情的卖价 singleData[21] singleData[23] singleData[25] singleData[27] singleData[29]
                for (int i = 10; i < 15; i++)
                {
                    [quoteModel.sellVOL addObject:singleData[2 * i]];
                    [quoteModel.sellPrice addObject:singleData[2 * i + 1]];
                }
                quoteModel.time = singleData[30];
                [dataArray addObject:quoteModel];
            }
        }
        block(dataArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failBlock(errorStr);
    }];
}

#pragma mark - 请求K线数据   -- 用的model：KLineMode
- (void)KLineData:(NSString *)urlString successBlock:(void(^)(id data))block failure:(void (^)(NSString *error))failBlock{
//    http://hangqing.ihuangpu.com:5432/GetKLine.ashx?symbol=SH600009&klinetype=4&datalen=5&startIndex=0
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetKLine.ashx?%@",_strLoginIP,urlString];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString *responseBody) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if (responseBody.length > 30) {  //30只是一个长度，这个值后期还要仔细考虑
            responseBody = [responseBody substringFromIndex:21];  //截取前面的字符
            responseBody = [responseBody substringToIndex:responseBody.length-2]; //截取后面2个字符
            NSArray *array = [responseBody componentsSeparatedByString:NSLocalizedString(@"\",\"", nil)];//分割多支股票数据
            CGFloat preClosePx = 0;
            for (NSInteger i=array.count-1; i >= 0; i--) {
                KLineModel *KLine = [[KLineModel alloc] init];
                NSArray *singleData = [array[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@","]];
                KLine.time = [singleData[0] componentsSeparatedByString:NSLocalizedString(@" ", nil)][0];
                KLine.openPrice = singleData[1];                    //开盘价
                KLine.highPrice = singleData[2];                    //最高价
                KLine.lowPrice = singleData[3];                     //最低价
                KLine.closePrice = singleData[4];                   //收盘价
                KLine.VOL = singleData[5];                          //成交量
                KLine.amount = singleData[6];                       //成交额
                KLine.preClosePx = preClosePx;
                if (i != array.count-1) {
//                  请求数据中最后一组(即最早的数据)数据无法计算涨跌额和涨跌幅，因为没有上一个交易日的收盘价，已经是最后一条数据了
                    KLine.change = [singleData[4] floatValue] - preClosePx;
                    KLine.changeRate = ([singleData[4] floatValue] -preClosePx)*100/preClosePx;
                }
                //MA5
                if (array.count<=5 || i>array.count-5) {
                    //数据不足10条数据  数据没有最后9天的ma10
                }else {
                    CGFloat MA5_result = [singleData[4] floatValue];
                    NSInteger j = array.count-i-2;
                    NSInteger num = array.count-i-2-4;
                    for (; j > num; j--) {
                        KLineModel *model = dataArray[j];
                        MA5_result += [model.closePrice floatValue];
                    }
                    KLine.ma5 = MA5_result/5.0;
                }
                //MA10
                if (array.count<=10 || i>array.count-10) {
                    //数据不足10条数据  数据没有最后9天的ma10
                }else {
                    CGFloat MA10_result = [singleData[4] floatValue];
                    NSInteger j = array.count-i-2;
                    NSInteger num = array.count-i-2-9;
                    for (; j > num; j--) {
                        KLineModel *model = dataArray[j];
                        MA10_result += [model.closePrice floatValue];
                    }
                    KLine.ma10 = MA10_result/10.0;
                }
                //MA20
                if (array.count<=20 || i>array.count-20) {
                    //数据不足20条数据  数据没有最后19天的ma10
                }else {
                    CGFloat MA20_result = [singleData[4] floatValue];
                    NSInteger j = array.count-i-2;
                    NSInteger num = array.count-i-2-19;
                    for (; j > num; j--) {
                        KLineModel *model = dataArray[j];
                        MA20_result += [model.closePrice floatValue];
                    }
                    KLine.ma20 = MA20_result/20.0;
                }
                preClosePx = [singleData[4] floatValue];            //昨收价 但是
                KLine.index = i;                                    //下标索引
                [dataArray addObject:KLine];
            }
        }
        block(dataArray);
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}
#pragma mark - 请求分时数据   --用的model:MinModel
- (void)MinData:(NSString *)stockCode successBlock:(void(^)(id data))block failure:(void(^)(NSString *error))failBlock{
//    http://hangqing.ihuangpu.com:5432/GetMinuteData.ashx?SYMBOL=sh600000&datalen=240
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetMinuteData.ashx?SYMBOL=%@&datalen=242",_strLoginIP,stockCode];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString *responseBody) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if (responseBody.length > 30) { //30只是一个长度，这个值后期还要仔细考虑
            NSRange range = [responseBody  rangeOfString:@"9:30"];
            if (range.location != NSNotFound) {
                responseBody = [responseBody substringFromIndex:range.location];
            }
            responseBody = [responseBody substringToIndex:responseBody.length-3]; //截取后面3个字符  ",]
            NSArray *array = [responseBody componentsSeparatedByString:NSLocalizedString(@"\",\"", nil)];//分割多支股票数据  这个分时数据
            CGFloat preVol = 0;
            for (int i = 0; i < array.count; i++) {
                MinModel *min = [[MinModel alloc] init];
                NSArray *singleData = [array[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@","]];
                NSString *timeStr = singleData[0];
                if (i>0) {
                    timeStr = [singleData[0] componentsSeparatedByString:NSLocalizedString(@" ", nil)][1];
                }
                min.time = [timeStr substringToIndex:timeStr.length-3];
                if (i == 0) {
                    min.preVol = [singleData[2] floatValue];
                }else {
                    min.preVol = [singleData[2] floatValue]-preVol;
                }
                min.price = singleData[1];
                min.VOL = singleData[2];
                preVol = [singleData[2] floatValue];
                min.amount = singleData[3];
                min.avgPrice = [NSString stringWithFormat:@"%.2lf",[singleData[3] floatValue]/([singleData[2] floatValue]*100)];
                [dataArray addObject:min];
            }
        }
        block(dataArray);
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

#pragma mark - 请求分笔数据  --成交明细
- (void)FenBiData:(NSString *)stockCode successBlock:(void(^)(id data))block failure:(void(^)(NSString *error))failBlock{
//    http://hangqing.ihuangpu.com:5432/GetFenBiData.ashx?SYMBOL=sh600000&datalen=10
    NSString *urlStr = [NSString stringWithFormat:@"%@/GetFenBiData.ashx?SYMBOL=%@&datalen=10",_strLoginIP,stockCode];
    [self HTTPRequestOperationByGet:urlStr successBlock:^(NSString *responseBody) {
        NSMutableArray *dataArray = [NSMutableArray array];
        if (responseBody.length > 30) { //30只是一个长度，这个值后期还要仔细考虑
           NSArray *array = [responseBody componentsSeparatedByString:NSLocalizedString(@"\",\"", nil)];  //分割多支股票数据
            for (int i = 0; i<array.count; i++) {
                FenBiModel *fenBiModel = [[FenBiModel alloc] init];
                NSArray *singleData   = [array[i]  componentsSeparatedByCharactersInSet:[NSCharacterSet  characterSetWithCharactersInString:@","]];
                //按照空格拆开，只取时间
                NSString *tempTime = [singleData[0] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]][1];
                NSArray *tempArray = [tempTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
                fenBiModel.time   = [NSString stringWithFormat:@"%@:%@",tempArray[0],tempArray[1]];
                fenBiModel.Price  = singleData[1];
                fenBiModel.VOL    = singleData[2];
                fenBiModel.amount = singleData[3];
                fenBiModel.buyOne = singleData[4];
                fenBiModel.sellOne = singleData[5];
                [dataArray addObject:fenBiModel];
            }
        }
        block(dataArray);
    } failureBlock:^(NSString *error) {
        failBlock(error);
    }];
}

@end
