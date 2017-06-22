//
//  YKLineDataSet.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YKLineDataSet : NSObject
@property (nonatomic,strong)NSMutableArray * data;
@property (nonatomic,assign)CGFloat highlightLineWidth;      //十字线宽度
@property (nonatomic,strong)UIColor  * highlightLineColor;   //十字线颜色
@property (nonatomic,strong)UIColor * candleRiseColor;       //蜡烛图升的颜色
@property (nonatomic,strong)UIColor * candleFallColor;       //蜡烛图降的颜色
@property (nonatomic,strong)UIColor * avgMA5Color;           //MA5均线颜色
@property (nonatomic,strong)UIColor * avgMA10Color;          //MA10均线颜色
@property (nonatomic,strong)UIColor * avgMA20Color;
@property (nonatomic,assign)CGFloat  avgLineWidth;           //均线宽度
@property (nonatomic,assign)CGFloat candleTopBottmLineWidth;    //蜡烛图上面和下面那个线宽度

@end


@interface YKTimeDataset : NSObject
@property (nonatomic,strong)NSMutableArray * data;
@property (nonatomic,assign)CGFloat highlightLineWidth;     //十字线宽度
@property (nonatomic,strong)UIColor  * highlightLineColor;  //十字线颜色
@property (nonatomic,assign)CGFloat  lineWidth;             //现价线宽
@property (nonatomic,strong)UIColor * priceLineCorlor;      //现价颜色
@property (nonatomic,strong)UIColor * avgLineCorlor;        //均线的颜色

@property (nonatomic,strong)UIColor * volumeRiseColor;      //涨的颜色
@property (nonatomic,strong)UIColor * volumeFallColor;      //跌的颜色
@property (nonatomic,strong)UIColor * volumeTieColor;      //涨幅是平的颜色

@property (nonatomic,assign)BOOL drawFilledEnabled;
@property (nonatomic,strong)UIColor * fillStartColor;
@property (nonatomic,strong)UIColor * fillStopColor;
@property (nonatomic,assign)CGFloat fillAlpha;

@end
