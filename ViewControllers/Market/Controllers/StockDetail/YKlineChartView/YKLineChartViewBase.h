//
//  YKLineChartViewBase.h
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import <UIKit/UIKit.h>
#import "YKViewBase.h"


@protocol YKLineChartViewDelegate <NSObject>

@optional
- (void)chartValueSelected:(YKViewBase *)chartView entry:(id)entry entryIndex:(NSInteger)entryIndex;

- (void)chartValueNothingSelected:(YKViewBase *)chartView;

- (void)chartKlineScrollLeft:(YKViewBase *)chartView;

@end

@interface YKLineChartViewBase : YKViewBase

@property (nonatomic,assign) CGFloat uperChartHeightScale;          //k线图上面的高度占总视图高度的比例
@property (nonatomic,assign) CGFloat xAxisHeitht;                   //K线图和下面成交量之间的距离 间隙

@property (nonatomic,strong) UIColor *gridBackgroundColor;          //K线视图背景颜色
@property (nonatomic,strong) UIColor *borderColor;                  //K线视图边框
@property (nonatomic,assign) CGFloat borderWidth;


@property (nonatomic,assign)CGFloat maxPrice;
@property (nonatomic,assign)CGFloat minPrice;
@property (nonatomic,assign)CGFloat maxVolume;
@property (nonatomic,assign)CGFloat candleCoordsScale;              //蜡烛图总高度/（最大值-最小值）
@property (nonatomic,assign)CGFloat volumeCoordsScale;              //成交量总高度/（最大成交量-0）

@property (nonatomic,assign)NSInteger highlightLineCurrentIndex;        //十字线正在显示的K线索引
@property (nonatomic,assign)CGPoint highlightLineCurrentPoint;
@property (nonatomic,assign)BOOL highlightLineCurrentEnabled;           //当十字线显示后，设置为NO,则消失十字线  且只有长按手势设置了YES ,其他手势都设置为NO

@property (nonatomic,strong)NSDictionary * leftYAxisAttributedDic;          //左侧Y轴字体属性
@property (nonatomic,strong)NSDictionary * xAxisAttributedDic;              //X轴字体属性   显示日期或者时间，现在近在分时图中用到
@property (nonatomic,strong)NSDictionary * highlightAttributedDic;          //十字线显示字体属性：日期、成交量
@property (nonatomic,strong)NSDictionary * highlightAttributedLeftDic;      //十字线显示字体属性：左侧价格
@property (nonatomic,strong)NSDictionary * defaultAttributedDic;

@property (nonatomic,assign)BOOL highlightLineShowEnabled;              //十字线是否显示
@property (nonatomic,assign)BOOL scrollEnabled;                         //K线图是否可以滑动
@property (nonatomic,assign)BOOL zoomEnabled;                           //K线图是否可以放大缩小

@property (nonatomic,assign)BOOL leftYAxisIsInChart;                    //YES:则左侧的价格指示在K线框内  No:在K线框外
@property (nonatomic,assign)BOOL rightYAxisDrawEnabled;                 //YES:右侧涨幅指示  分时图

@property (nonatomic,assign)id<YKLineChartViewDelegate>  delegate;

@property (nonatomic,assign)BOOL isETF;


#pragma mark - 画直线
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth;

#pragma mark  - 画左侧价格区间指示
- (void)drawLabelPrice:(CGContextRef)context;

//圆点
-(void)drawCirclyPoint:(CGContextRef)context
                 point:(CGPoint)point
                radius:(CGFloat)radius
                 color:(UIColor*)color;

#pragma mark -画十字线
- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth;

#pragma mark - 很多地方用到这个内部方法
- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect;

#pragma mark - 实心矩形
- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color;
#pragma mark -画空心矩形
- (void)drawHollowRect:(CGContextRef)context
                  rect:(CGRect)rect
                 color:(UIColor*)color;

- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect;



@end
