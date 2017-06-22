//
//  YKLineChartView.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKLineChartViewBase.h"

@class  YKLineDataSet;

@interface YKLineChartView : YKLineChartViewBase

@property (nonatomic,assign)CGFloat candleWidth;          //单个蜡烛图宽度 = (包括间隙1/6+ 5/6实际蜡烛图宽度)
@property (nonatomic,assign)CGFloat candleMaxWidth;       //单个蜡烛图最大宽度
@property (nonatomic,assign)CGFloat candleMinWidth;       //单个蜡烛图最小宽度

@property (nonatomic,assign)BOOL isShowAvgMarkerEnabled;  //是否显示均价图示  默认为NO

@property (nonatomic,strong)NSDictionary * avgLabelAttributedDic;       //上面 均价Label字体样式
@property (nonatomic,strong)NSDictionary *detailDataAttDic;             //十字线出现的详情视图


- (void)setupData:(YKLineDataSet *)dataSet;

- (void)addDataSetWithArray:(NSArray *)array;
@end
