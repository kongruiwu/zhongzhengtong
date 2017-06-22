//
//  YKTimeLineView.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/10.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKLineChartViewBase.h"
#import "YKLineDataSet.h"

@interface YKTimeLineView : YKLineChartViewBase

@property (nonatomic,assign)CGFloat offsetMaxPrice;         //价格最大偏移值
@property (nonatomic,assign)NSInteger countOfTimes;                     

@property (nonatomic,assign)BOOL endPointShowEnabled;       //显示最后一个点
@property (nonatomic,assign)BOOL isDrawAvgEnabled;          //均线显示
@property (nonatomic,strong)NSDictionary *detailDataAttDic;     //十字线出现的详情视图里面字体


- (void)setupData:(YKTimeDataset *)dataSet;

@end
