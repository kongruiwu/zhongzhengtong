//
//  YKLineEntity.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YKLineEntity : NSObject

@property (nonatomic,strong)NSString * date;            //时间            对应KlineModel.time
@property (nonatomic,assign)CGFloat open;               //开盘价          对应KlineModel.openPrice
@property (nonatomic,assign)CGFloat high;               //最高价          对应KlineModel.highPrice
@property (nonatomic,assign)CGFloat low;                //最低价          对应KlineModel.lowPrice
@property (nonatomic,assign)CGFloat close;              //收盘价          对应KlineModel.closePrice
@property (nonatomic,assign)CGFloat volume;             //成交量          对应KlineModel.VOL
@property (nonatomic,assign)CGFloat amount;             //成交额          对应KlineModel.amount
@property (nonatomic,assign)CGFloat change;             //涨跌额          对应KlineModel.change
@property (nonatomic,assign)CGFloat rate;               //涨跌幅          对应KlineModel.changeRate
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)CGFloat ma5;
@property (nonatomic,assign)CGFloat ma10;
@property (nonatomic,assign)CGFloat ma20;
@property (nonatomic,assign)CGFloat preClosePx;         //上个交易日的收盘价 昨收价

@end

@interface YKTimeLineEntity : NSObject

@property (nonatomic,strong)NSString * currtTime;       //时间
@property (nonatomic,copy)NSString * rate;              //涨跌幅
@property (nonatomic,copy)NSString * change;            //涨跌额
@property (nonatomic,assign)CGFloat preClosePx;         //昨收价           分时控制器中的  self.preClose
@property (nonatomic,assign)CGFloat avgPirce;           //均价
@property (nonatomic,assign)CGFloat lastPirce;          //现价
@property (nonatomic,assign)CGFloat volume;             //成交量   这一分钟的成交量


@end
























