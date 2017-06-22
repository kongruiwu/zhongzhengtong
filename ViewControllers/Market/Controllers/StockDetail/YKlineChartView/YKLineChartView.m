//
//  YKLineChartView.m
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKLineChartView.h"
#import "YKLineDataSet.h"
#import "YKLineEntity.h"
#import "StockPublic.h"

@interface YKLineChartView()
@property (nonatomic,strong)YKLineDataSet * dataSet;
@property (nonatomic,assign)NSInteger countOfshowCandle;                        //正在显示的蜡烛图个数  = content宽度/单个蜡烛图的宽度
@property (nonatomic,assign)NSInteger  startDrawIndex;                          //K线图最左侧的第一个蜡烛图的索引
@property (nonatomic,strong)UIPanGestureRecognizer * panGesture;                //拖动手势
@property (nonatomic,strong)UIPinchGestureRecognizer * pinGesture;              //捏合
@property (nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;    //长按
@property (nonatomic,strong)UITapGestureRecognizer * tapGesture;                //点按
@property (nonatomic,assign)CGFloat lastPinScale;
@property (nonatomic,assign)CGFloat lastPinCount;
@end

@implementation YKLineChartView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
    }
    return self;
}

- (void)commonInit {
    self.candleCoordsScale = 0.f;
    [self addGestureRecognizer:self.panGesture];
    [self addGestureRecognizer:self.pinGesture];
    [self addGestureRecognizer:self.longPressGesture];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark - 私有属性 countOfshowCandle get方法
- (NSInteger)countOfshowCandle{
    return self.contentWidth/(self.candleWidth);
}
#pragma mark - 私有属性 startDrawIndex set方法
- (void)setStartDrawIndex:(NSInteger)startDrawIndex{
    if (startDrawIndex < 0) {
        startDrawIndex = 0;
    }
    if (startDrawIndex + self.countOfshowCandle > self.dataSet.data.count) {
        _startDrawIndex = 0;
    }
    _startDrawIndex = startDrawIndex;
}

#pragma mark -
-(void)setupData:(YKLineDataSet *)dataSet {
    self.dataSet = dataSet;
    [self notifyDataSetChanged];
}

- (void)addDataSetWithArray:(NSArray *)array {
    NSArray * tempArray = [self.dataSet.data mutableCopy];
    [self.dataSet.data removeAllObjects];
    [self.dataSet.data addObjectsFromArray:array];
    [self.dataSet.data addObjectsFromArray:tempArray];    
    self.startDrawIndex += array.count;
    [self  setCurrentDataMaxAndMin];
    [self setNeedsDisplay];             //会自动调用drawRect方法
}

#pragma mark - 设置当前数据中的价格最大最小值   当均价是最小值或者最大值则以均价作为最大最小
- (void)setCurrentDataMaxAndMin{
    if (self.dataSet.data.count > 0) {
        self.maxPrice = CGFLOAT_MIN;
        self.minPrice = CGFLOAT_MAX;
        self.maxVolume = CGFLOAT_MIN;
        
        NSInteger idx = self.startDrawIndex;
        for (NSInteger i = idx; i < self.startDrawIndex + self.countOfshowCandle && i < self.dataSet.data.count; i++) {
            YKLineEntity  * entity = [self.dataSet.data objectAtIndex:i];
            self.minPrice = self.minPrice < entity.low ? self.minPrice : entity.low;
            self.maxPrice = self.maxPrice > entity.high ? self.maxPrice : entity.high;
            self.maxVolume = self.maxVolume >entity.volume ? self.maxVolume : entity.volume;
            if(entity.ma5>0){
                self.minPrice = self.minPrice < entity.ma5 ? self.minPrice:entity.ma5;
                self.maxPrice = self.maxPrice > entity.ma5 ? self.maxPrice : entity.ma5;
            }
            if (entity.ma10 >0) {
                self.minPrice = self.minPrice < entity.ma10 ? self.minPrice:entity.ma10;
                self.maxPrice = self.maxPrice > entity.ma10 ? self.maxPrice : entity.ma10;
            }
            if (entity.ma20>0) {
                self.minPrice = self.minPrice < entity.ma20 ? self.minPrice:entity.ma20;
                self.maxPrice = self.maxPrice > entity.ma20 ? self.maxPrice : entity.ma20;
            }
        }
        
        if (self.maxPrice - self.minPrice < 0.3) {
            self.maxPrice +=0.5;
            self.minPrice -=0.5;
        }
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setCurrentDataMaxAndMin];
    CGContextRef optionalContext = UIGraphicsGetCurrentContext();
//画K线的背景框
    [self drawGridBackground:optionalContext rect:rect];
//画蜡烛图  十字线画法 详情弹框和均价视图
    if (self.dataSet.data.count) {
        [self drawCandle:optionalContext];
    }
//画左侧价格区间指示  -- 调用父类方法
    [self drawLabelPrice:optionalContext];
}

#pragma mark - 画K线背景框
- (void)drawGridBackground:(CGContextRef)context rect:(CGRect)rect{
    [super drawGridBackground:context rect:rect];
}

#pragma mark - 均价 均价 均价 ！Label   这是画上面均价 不是均线  isDrawRight = YES 则均价靠右显示
- (void)drawAvgMarker:(CGContextRef)context
                 idex:(NSInteger)idex
          isDrawRight:(BOOL)isDrawRight{
    if (!self.isShowAvgMarkerEnabled) {
        return;
    }
    YKLineEntity  * entity = self.dataSet.data[idex];

    NSDictionary * drawAttributes = self.avgLabelAttributedDic ?:self.defaultAttributedDic;
    
    NSString * ma5Str = [NSString stringWithFormat:@"MA5 %.2f",entity.ma5];
    NSMutableAttributedString * ma5StrAtt = [[NSMutableAttributedString alloc]initWithString:ma5Str attributes:drawAttributes];
    CGSize ma5StrAttSize = [ma5StrAtt size];
    
    NSString * ma10Str = [NSString stringWithFormat:@"MA10 %.2f",entity.ma10];
    NSMutableAttributedString * ma10StrAtt = [[NSMutableAttributedString alloc]initWithString:ma10Str attributes:drawAttributes];
    CGSize ma10StrAttSize = [ma10StrAtt size];
    
    NSString * ma20Str = [NSString stringWithFormat:@"MA20 %.2f",entity.ma20];
    NSMutableAttributedString * ma20StrAtt = [[NSMutableAttributedString alloc]initWithString:ma20Str attributes:drawAttributes];
    CGSize ma20StrAttSize = [ma20StrAtt size];
    
    
    CGFloat radius = ma5StrAttSize.height/2;
    CGFloat length = ma5StrAttSize.width+ma20StrAttSize.width+ma10StrAttSize.width+radius*8;
    CGFloat space = radius;
    
    CGPoint startP = CGPointMake(self.contentLeft, self.contentTop);
    if (isDrawRight) {
        startP.x = self.contentRight - length - 4;
    }
    
    startP.y = startP.y+(radius/2.0)+2;
    CGFloat labelY = self.contentTop+(radius/4.0);
    
    //Background 画均价的背景框 by JopYin屏蔽
//    UIColor * bgColor = [UIColor colorWithWhite:1 alpha:0.5];
//    [self drawRect:context rect:CGRectMake(startP.x, self.contentTop+1,length, ma5StrAttSize.height) color:bgColor];
    
    //=====画均价MA5小圆点 以及MA5 Label
    CGContextSetFillColorWithColor(context, self.dataSet.avgMA5Color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(startP.x+(radius/2.0),startP.y , radius, radius));
    
    startP.x += (radius+space);
    [self drawLabel:context attributesText:ma5StrAtt rect:CGRectMake(startP.x,labelY, ma5StrAttSize.width, ma5StrAttSize.height)];
    
    
    //=====画均价MA10小圆点 以及MA10 Label
    startP.x += (ma5StrAttSize.width + space);
    CGContextSetFillColorWithColor(context, self.dataSet.avgMA10Color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(startP.x+(radius/2.0),startP.y, radius, radius));
    
    startP.x += (radius+space);
    [self drawLabel:context attributesText:ma10StrAtt rect:CGRectMake(startP.x,labelY, ma10StrAttSize.width, ma10StrAttSize.height)];
    
    //=====画均价MA20小圆点 以及MA20 Label
    startP.x += (ma10StrAttSize.width + space);
    CGContextSetFillColorWithColor(context, self.dataSet.avgMA20Color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(startP.x+(radius/2.0), startP.y, radius, radius));
    
    startP.x += (radius+space);
    [self drawLabel:context attributesText:ma20StrAtt rect:CGRectMake(startP.x, labelY, ma20StrAttSize.width, ma20StrAttSize.height)];
    
}

#pragma mark - 画蜡烛图
- (void)drawCandle:(CGContextRef)context{
    CGContextSaveGState(context);
    NSInteger idex = self.startDrawIndex;
    self.candleCoordsScale = (self.uperChartHeightScale * self.contentHeight)/(self.maxPrice-self.minPrice);
    self.volumeCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxVolume - 0);
    //从K线图的左边第一个开始idex不为0   K线图和成交量的具体画法
    for (NSInteger i = idex ; i< self.dataSet.data.count; i ++) {
        YKLineEntity  * entity  = [self.dataSet.data objectAtIndex:i];
        CGFloat open  = ((self.maxPrice - entity.open) * self.candleCoordsScale) + self.contentTop;           //蜡烛图开盘价的Y坐标  蜡烛图中间的实心是矩形框不是一根线
        CGFloat close = ((self.maxPrice - entity.close) * self.candleCoordsScale) + self.contentTop;          //蜡烛图收盘价Y坐标
        CGFloat high  = ((self.maxPrice - entity.high) * self.candleCoordsScale) + self.contentTop;           //蜡烛图最高价Y坐标
        CGFloat low   = ((self.maxPrice - entity.low) * self.candleCoordsScale) + self.contentTop;            //蜡烛图最低价Y坐标
        CGFloat left  = self.candleWidth * (i - idex) + self.contentLeft + self.candleWidth / 6.0;            //每一个蜡烛图左侧起点位置 X坐标
        CGFloat candleWidth = self.candleWidth - self.candleWidth / 6.0;                                     //一个蜡烛图的宽度  其实是只有 candleWidth5/6，中间加个间隙
        
        CGFloat startX = left + candleWidth/2.0 ;                                                            //每个蜡烛图的中间点X坐标

    {
        //画K线图底部的日期
        //日期 这个判断是画中间显示日期的竖线 by JopYin 屏蔽   画竖线指定日期（可以不要）
    /*
        if (i > self.startDrawIndex+5 && i < self.dataSet.data.count - 2) {
            if (i % (NSInteger)(180/self.candleWidth) == 0) {
                [self drawline:context startPoint:CGPointMake(startX, self.contentTop) stopPoint:CGPointMake(startX,  (self.uperChartHeightScale * self.contentHeight)+ self.contentTop) color:self.borderColor lineWidth:0.5];  //画K线图中的竖线
                [self drawline:context startPoint:CGPointMake(startX, (self.uperChartHeightScale * self.contentHeight)+ self.xAxisHeitht) stopPoint:CGPointMake(startX,self.contentBottom) color:self.borderColor lineWidth:0.5];             //画成交量图的竖线
                NSString * date = entity.date;
                NSDictionary * drawAttributes = self.xAxisAttributedDic?:self.defaultAttributedDic;         //设置日期字体属性
                self.xAxisAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:6],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0]};      //by JopYin添加的一个参照例子
                NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
                CGSize dateStrAttSize = [dateStrAtt size];
                [self drawLabel:context attributesText:dateStrAtt rect:CGRectMake(startX - dateStrAttSize.width/2,((self.uperChartHeightScale * self.contentHeight)+ self.contentTop), dateStrAttSize.width, dateStrAttSize.height)];             //画中间间隙中的日期label
            }
        }
    */
        //日期 这个判断最左侧和最右侧显示日期的竖线 by JopYin   画竖线指定日期（可以不要）
        if (i == self.startDrawIndex || i == self.startDrawIndex+self.countOfshowCandle-1) {
            NSString * date = entity.date;
            NSDictionary * drawAttributes = self.xAxisAttributedDic?:self.defaultAttributedDic;         //设置日期字体属性
            self.xAxisAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:6],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0]};      //by JopYin添加的一个参照例子
            NSMutableAttributedString * dateStrAtt = [[NSMutableAttributedString alloc]initWithString:date attributes:drawAttributes];
            CGSize dateStrAttSize = [dateStrAtt size];
            [self drawLabel:context attributesText:dateStrAtt rect:CGRectMake(startX - dateStrAttSize.width/2-8,((self.uperChartHeightScale * self.contentHeight)+ self.contentTop), dateStrAttSize.width, dateStrAttSize.height)];  //显示最左边和最右边的日期
        }
    }
        
        UIColor * color = self.dataSet.candleRiseColor;
        //蜡烛图的具体画法
        if (open < close) {
            //蜡烛图开盘价Y坐标 < 收盘价Y坐标 == 开盘价 > 收盘价  即开盘价在蜡烛图上面，收盘价在蜡烛图下面  绿色
            color = self.dataSet.candleFallColor;
            CGFloat hight = close-open < 1.0?1.0:close-open;
            [self drawRect:context rect:CGRectMake(left, open, candleWidth, hight) color:color];  //蜡烛图中间的矩形实心框
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, low) color:color lineWidth:self.dataSet.candleTopBottmLineWidth];
        }else if (open == close) {
            if (i > 1) {
                YKLineEntity * lastEntity = [self.dataSet.data objectAtIndex:i-1];
                if (lastEntity.close > entity.close) {
                    color = self.dataSet.candleFallColor;
                }
            }
            [self drawRect:context rect:CGRectMake(left, open, candleWidth, 1.5) color:color];
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, low) color:color lineWidth:self.dataSet.candleTopBottmLineWidth];
        } else {
            color = self.dataSet.candleRiseColor;
            CGFloat hight = open-close < 1.0?1.0:open-close;
//            [self drawHollowRect:context rect:CGRectMake(left, close, candleWidth, hight) color:color];           //蜡烛图矩形空心框 By JopYin
            [self drawRect:context rect:CGRectMake(left, close, candleWidth, hight) color:color];                   //蜡烛图矩形实心框
            [self drawline:context startPoint:CGPointMake(startX, high) stopPoint:CGPointMake(startX, close) color:color lineWidth:self.dataSet.candleTopBottmLineWidth];                                                             //蜡烛图上面的那条线
            [self drawline:context startPoint:CGPointMake(startX, open) stopPoint:CGPointMake(startX, low) color:color lineWidth:self.dataSet.candleTopBottmLineWidth];                                                                //蜡烛图下面的那条线
        }
        
        //三条均线的具体画法
        if (i > 0){
            YKLineEntity * lastEntity = [self.dataSet.data objectAtIndex:i -1];                                 //上一个数据model
            CGFloat lastX = startX - self.candleWidth;                                                          //上一个蜡烛图中点X坐标
            if (i>4) {
                CGFloat lastY5 = (self.maxPrice - lastEntity.ma5)*self.candleCoordsScale + self.contentTop;         //上一个MA5均线Y坐标
                CGFloat  y5 = (self.maxPrice - entity.ma5)*self.candleCoordsScale  + self.contentTop;               //MA5均线Y坐标
                if (entity.ma5 > 0 && lastEntity.ma5>0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY5) stopPoint:CGPointMake(startX, y5) color:self.dataSet.avgMA5Color lineWidth:self.dataSet.avgLineWidth];
                }
            }
            if (i>9) {
                CGFloat lastY10 = (self.maxPrice - lastEntity.ma10)*self.candleCoordsScale  + self.contentTop;      //上一个MA10均线Y坐标
                CGFloat  y10 = (self.maxPrice - entity.ma10)*self.candleCoordsScale  + self.contentTop;             //MA10均线Y坐标
                if (entity.ma10 > 0 && lastEntity.ma10 > 0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY10) stopPoint:CGPointMake(startX, y10) color:self.dataSet.avgMA10Color lineWidth:self.dataSet.avgLineWidth];
                }

            }
            if (i>19) {
                CGFloat lastY20 = (self.maxPrice - lastEntity.ma20)*self.candleCoordsScale  + self.contentTop;
                CGFloat  y20 = (self.maxPrice - entity.ma20)*self.candleCoordsScale  + self.contentTop;
                if (entity.ma20 > 0 && lastEntity.ma20 >0) {
                    [self drawline:context startPoint:CGPointMake(lastX, lastY20) stopPoint:CGPointMake(startX, y20) color:self.dataSet.avgMA20Color lineWidth:self.dataSet.avgLineWidth];
                }
            }
        }
        //成交量的具体画法
        CGFloat volume = ((entity.volume - 0) * self.volumeCoordsScale);                                    //成交量的高度
        [self drawRect:context rect:CGRectMake(left, self.contentBottom - volume , candleWidth, volume) color:color];       //这个color根据上面的k线图判断自动为红色或者绿色
    }
    
    for (NSInteger i = idex ; i< self.dataSet.data.count; i ++) {
        YKLineEntity  * entity  = [self.dataSet.data objectAtIndex:i];
        
        CGFloat close = ((self.maxPrice - entity.close) * self.candleCoordsScale) + self.contentTop;            //蜡烛图收盘价Y坐标  蜡烛图中间的实心是矩形框不是一根线
        CGFloat left = (self.candleWidth * (i - idex) + self.contentLeft) + self.candleWidth / 6.0;             //每个蜡烛图左侧起点位置 X坐标
        CGFloat candleWidth = self.candleWidth - self.candleWidth / 6.0;                                        //一个蜡烛图的宽度  其实是只有 candleWidth5/6，中间加个间隙
        CGFloat startX = left + candleWidth/2.0 ;                                                               //每个蜡烛图的中间点X坐标
        //十字线  当时长按手势则这个 highlightLineCurrentEnabled = YES
        if (self.highlightLineCurrentEnabled) {
            if (i == self.highlightLineCurrentIndex) {
                
                YKLineEntity * entity;
                if (i < self.dataSet.data.count) {
                    entity = [self.dataSet.data objectAtIndex:i];
                }
                [self drawHighlighted:context point:CGPointMake(startX, close) idex:idex value:entity color:self.dataSet.highlightLineColor lineWidth:self.dataSet.highlightLineWidth];
                
                BOOL isDrawRight = startX < (self.contentRight)/2.0;                                    //比较十字线的位置在视图的中线左边还是右边
                [self drwaDetailData:context idex:i isDrawRight:isDrawRight];                           //画K线蜡烛图详情 
                [self drawAvgMarker:context idex:i isDrawRight:isDrawRight];                            //画上面均价
                if ([self.delegate respondsToSelector:@selector(chartValueSelected:entry:entryIndex:) ]) {
                    [self.delegate chartValueSelected:self entry:entity entryIndex:i];
                }
            }
        }
    }
    
    //设置均价现在靠左显示  不显示十字线的时候默认靠左显示
    if (!self.highlightLineCurrentEnabled) {
        [self drawAvgMarker:context idex:0 isDrawRight:NO];;
    }
    CGContextRestoreGState(context);
}
#pragma mark - 画十字线弹框详情视图
- (void)drwaDetailData:(CGContextRef)context
                 idex:(NSInteger)idex
           isDrawRight:(BOOL)isDrawRight {
    YKLineEntity  * entity = self.dataSet.data[idex];    
    NSDictionary * attDic = self.detailDataAttDic ?:self.defaultAttributedDic;
    
    NSString * date = entity.date;
    NSMutableAttributedString * dateAttStr = [[NSMutableAttributedString alloc] initWithString:date attributes:attDic];
    CGSize dateAttSize = [dateAttStr size];
    
    NSString * open = [NSString stringWithFormat:@"开盘   %.2f",entity.open];
    NSMutableAttributedString * openAttStr = [[NSMutableAttributedString alloc] initWithString:open attributes:attDic];
    CGSize openAttSize = [openAttStr size];
    
    NSString * high = [NSString stringWithFormat:@"最高   %.2f",entity.high];
    NSMutableAttributedString * highAttStr = [[NSMutableAttributedString alloc] initWithString:high attributes:attDic];
    CGSize highAttSize = [highAttStr size];
    
    NSString * low = [NSString stringWithFormat:@"最低   %.2f",entity.low];
    NSMutableAttributedString * lowAttStr = [[NSMutableAttributedString alloc] initWithString:low attributes:attDic];
    CGSize lowAttSize = [lowAttStr size];
    
    NSString * close = [NSString stringWithFormat:@"收盘   %.2f",entity.close];
    NSMutableAttributedString * closeAttStr = [[NSMutableAttributedString alloc] initWithString:close attributes:attDic];
    CGSize closeAttSize = [closeAttStr size];
    
    NSString * change = [NSString stringWithFormat:@"涨跌额 %.2f",entity.change];
    NSMutableAttributedString * changeAttStr = [[NSMutableAttributedString alloc] initWithString:change attributes:attDic];
    CGSize changeAttSize = [changeAttStr size];
    
    NSString * changeRate = [NSString stringWithFormat:@"涨跌幅 %.2f%%",entity.rate];
    NSMutableAttributedString * rateAttStr = [[NSMutableAttributedString alloc] initWithString:changeRate attributes:attDic];
    CGSize changeRateAttSize = [rateAttStr size];
    
    NSString * VOL = [NSString stringWithFormat:@"成交量 %@",[StockPublic calculateFloat:entity.volume]];
    NSMutableAttributedString * VOLAttStr = [[NSMutableAttributedString alloc] initWithString:VOL attributes:attDic];
    CGSize VOLAttSize = [VOLAttStr size];
    
    NSString * amount = [NSString stringWithFormat:@"成交额 %@",[StockPublic changePrice:entity.amount]];
    NSMutableAttributedString * amountAttStr = [[NSMutableAttributedString alloc] initWithString:amount attributes:attDic];
    CGSize amountAttSize = [amountAttStr size];
    
    CGFloat spaceY = 3.0;
    CGFloat height = dateAttSize.height +openAttSize.height+highAttSize.height+lowAttSize.height+closeAttSize.height+changeAttSize.height+changeRateAttSize.height+VOLAttSize.height+amountAttSize.height+10*spaceY;
    CGFloat width = VOLAttSize.width+10;
    
    CGPoint origin = CGPointMake(self.contentLeft, self.contentTop+10);
    if (isDrawRight) {
        origin.x = self.contentRight - width ;
    }

    [self drawRect:context rect:CGRectMake(origin.x, self.contentTop+10, width, height) color:[UIColor colorWithRed:17/255.0 green:64/255.0 blue:104/255.0 alpha:0.8]];     //画详情框背景
    CGFloat labelY = origin.y +spaceY;
    [dateAttStr    drawInRect:CGRectMake(origin.x, labelY, dateAttSize.width, dateAttSize.height)];                         //日期
    labelY += spaceY+dateAttSize.height;
    [openAttStr    drawInRect:CGRectMake(origin.x, labelY, openAttSize.width, openAttSize.height)];                         //开盘价
    labelY += spaceY+openAttSize.height;
    [highAttStr    drawInRect:CGRectMake(origin.x, labelY, highAttSize.width, highAttSize.height)];                         //最高价
    labelY += spaceY+highAttSize.height;
    [lowAttStr     drawInRect:CGRectMake(origin.x, labelY, lowAttSize.width, lowAttSize.height)];                           //最低价
    labelY += spaceY+lowAttSize.height;
    [closeAttStr   drawInRect:CGRectMake(origin.x, labelY, closeAttSize.width, closeAttSize.height)];                       //收盘价
    labelY += spaceY+closeAttSize.height;
    [changeAttStr  drawInRect:CGRectMake(origin.x, labelY, changeAttSize.width, changeAttSize.height)];                     //涨跌额
    labelY += spaceY+changeAttSize.height;
    [rateAttStr    drawInRect:CGRectMake(origin.x, labelY, changeRateAttSize.width, changeRateAttSize.height)];             //涨跌幅
    labelY += spaceY+changeRateAttSize.height;
    [VOLAttStr     drawInRect:CGRectMake(origin.x, labelY, VOLAttSize.width, VOLAttSize.height)];                           //成交量
    labelY += spaceY+VOLAttSize.height;
    [amountAttStr  drawInRect:CGRectMake(origin.x, labelY, amountAttSize.width, amountAttSize.height)];                     //成交额
}

- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGestureAction:)];
    }
    return _panGesture;
}
- (void)handlePanGestureAction:(UIPanGestureRecognizer *)recognizer{
    if (!self.scrollEnabled) {
        return;
    }
    
    self.highlightLineCurrentEnabled = NO;
    
    BOOL isPanRight = NO;
    
    CGPoint point = [recognizer translationInView:self];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
    }
   
    CGFloat offset = point.x;

    NSLog(@"%ld=======,%.2f,%.2f",(long)self.startDrawIndex,offset,[recognizer velocityInView:self].x);


    if (offset > 0) {

        NSInteger offsetIndex = offset/8.0 ;
        NSLog(@"%ld",(long)offsetIndex);

        self.startDrawIndex  -= offsetIndex;
        if ( self.startDrawIndex < 2) {
            if ([self.delegate respondsToSelector:@selector(chartKlineScrollLeft:)]) {
                [self.delegate chartKlineScrollLeft:self];
            }
        }
    }else{
 
        if (self.startDrawIndex + self.countOfshowCandle - (+offset)/self.candleWidth > self.dataSet.data.count) {
            isPanRight = YES;
        }
        NSInteger offsetIndex = (-offset)/8.0;
        self.startDrawIndex += offsetIndex;
        if (self.startDrawIndex +10 > self.dataSet.data.count) {
            self.startDrawIndex = 0;
        }
        

    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (isPanRight) {
            [self notifyDataSetChanged];
        }
    }
    
    [self setNeedsDisplay];             //会自动调用drawRect方法
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];

}

- (UIPinchGestureRecognizer *)pinGesture{
    if (!_pinGesture) {
        _pinGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinGestureAction:)];
        }
    return _pinGesture;
}


- (void)handlePinGestureAction:(UIPinchGestureRecognizer *)recognizer{
    if (!self.zoomEnabled) {
        return;
    }
    
    self.highlightLineCurrentEnabled = NO;

    recognizer.scale= recognizer.scale-self.lastPinScale + 1;
    
    ;
    self.candleWidth = recognizer.scale * self.candleWidth;
    
    if(self.candleWidth > self.candleMaxWidth){
        self.candleWidth = self.candleMaxWidth;
    }
    if(self.candleWidth < self.candleMinWidth){
        self.candleWidth = self.candleMinWidth;
    }
    
    //self.startDrawIndex = self.dataSet.data.count - self.countOfshowCandle;
    NSInteger offset = (NSInteger)((self.lastPinCount -self.countOfshowCandle)/2);
    
    if (labs(offset)) {
        NSLog(@"offset %ld",(long)offset);
        self.lastPinCount = self.countOfshowCandle;
        self.startDrawIndex = self.startDrawIndex + offset;
        [self setNeedsDisplay];                                     //会自动调用drawRect方法
    }
    
    NSLog(@"%ld",(long)self.startDrawIndex);
    
    self.lastPinScale = recognizer.scale;

}

- (UILongPressGestureRecognizer *)longPressGesture{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}
- (void)handleLongPressGestureAction:(UIPanGestureRecognizer *)recognizer{
    if (!self.highlightLineShowEnabled) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint  point = [recognizer locationInView:self];
        
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint  point = [recognizer locationInView:self];
        
        if (point.x > self.contentLeft && point.x < self.contentRight && point.y >self.contentTop && point.y<self.contentBottom) {
            self.highlightLineCurrentEnabled = YES;
            [self getHighlightByTouchPoint:point];
        }
    }
}

- (void)getHighlightByTouchPoint:(CGPoint) point{
   
    self.highlightLineCurrentIndex = self.startDrawIndex + (NSInteger)((point.x - self.contentLeft)/self.candleWidth);
    [self setNeedsDisplay];             //会自动调用drawRect方法
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureAction:)];
    }
    return _tapGesture;
}
- (void)handleTapGestureAction:(UITapGestureRecognizer *)recognizer{
    if (self.highlightLineCurrentEnabled) {
        self.highlightLineCurrentEnabled = NO;
    }
    [self setNeedsDisplay];   //会自动调用drawRect方法
}


- (void)notifyDataSetChanged{
    [super notifyDataSetChanged];
    [self setNeedsDisplay];                 //会自动调用drawRect方法
    self.startDrawIndex = self.dataSet.data.count - self.countOfshowCandle;
}
- (void)notifyDeviceOrientationChanged{
    [super notifyDeviceOrientationChanged];
    self.startDrawIndex = self.dataSet.data.count - self.countOfshowCandle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
