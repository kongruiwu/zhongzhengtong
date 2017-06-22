//
//  KLineModel.h
//  GuShang
//
//  Created by JopYin on 2016/11/29.
//  Copyright © 2016年 尹争荣. All rights reserved.
//  这个model用于接收K线接口数据

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface KLineModel : NSObject

@property (nonatomic,copy)NSString *time;               //日期
@property (nonatomic,copy)NSString *openPrice;          //开盘价
@property (nonatomic,copy)NSString *highPrice;          //最高价
@property (nonatomic,copy)NSString *lowPrice;           //最低价
@property (nonatomic,copy)NSString *closePrice;         //收盘价
@property (nonatomic,copy)NSString *VOL;                //成交量（手）
@property (nonatomic,copy)NSString *amount;             //成交额
@property (nonatomic,assign)CGFloat preClosePx;         //上个交易日的收盘价 昨收价
@property (nonatomic,assign)CGFloat change;             //涨跌额
@property (nonatomic,assign)CGFloat changeRate;         //涨跌幅  已经计算到了1.02%  只要在后面加 "%"号就行
@property (nonatomic,assign)CGFloat ma5;
@property (nonatomic,assign)CGFloat ma10;
@property (nonatomic,assign)CGFloat ma20;
@property (nonatomic,assign)NSInteger index;

@end
