//
//  QuoteModel.h
//  GuShang
//
//  Created by JopYin on 2016/11/22.
//  Copyright © 2016年 尹争荣. All rights reserved.
// 这个model主要用于处理行情数据和行情报价牌

#import <Foundation/Foundation.h>

@interface QuoteModel : NSObject

@property (nonatomic,copy)NSString *stockCode;
@property (nonatomic,copy)NSString *stockName;
@property (nonatomic,copy)NSString *openPrice;          //开盘价
@property (nonatomic,copy)NSString *closePrice;         //收盘价  (昨收价)  
@property (nonatomic,copy)NSString *price;              //最新价
@property (nonatomic,copy)NSString *highPrice;          //最高价
@property (nonatomic,copy)NSString *lowPrice;           //最低价
@property (nonatomic,copy)NSString *VOL;                //成交量（手）
@property (nonatomic,copy)NSString *amount;             //成交额
@property (nonatomic,copy)NSString *change;             //涨跌额
@property (nonatomic,copy)NSString *changeRate;         //涨跌幅  已经计算到了1.02%  只要在后面加 "%"号就行
@property (nonatomic,copy)NSString *time;

@property (nonatomic,strong)NSMutableArray *buyPrice;       //买价：包含  买一、买二、买三、买四、买五
@property (nonatomic,strong)NSMutableArray *buyVOL;         //买价：包含  买一申请量、买二申请量、买三申请量、买四申请量、买五申请量
@property (nonatomic,strong)NSMutableArray *sellPrice;      //卖价：包含  卖一、卖二、卖三、卖四、卖五
@property (nonatomic,strong)NSMutableArray *sellVOL;        //卖价：包含  卖一申请量、卖二申请量、卖三申请量、卖四申请量、卖五申请量



@end
