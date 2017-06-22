//
//  YKLineChartViewBase.m
//  YKLineChartView
//
//  Created by chenyk on 15/12/9.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKLineChartViewBase.h"
#import "YKLineEntity.h"
@interface YKLineChartViewBase()

@end

@implementation YKLineChartViewBase
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

#pragma mark - 画K先的背景框
- (void)drawGridBackground:(CGContextRef)context
                      rect:(CGRect)rect{
    UIColor * backgroundColor = self.gridBackgroundColor?:[UIColor whiteColor];
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //画边框
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, self.contentTop, self.contentWidth, (self.uperChartHeightScale * self.contentHeight)));
    CGContextStrokeRect(context, CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, self.contentWidth, (self.contentBottom - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)));
    
    //画中间的横线
//    [self drawline:context startPoint:CGPointMake(self.contentLeft,(self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) stopPoint:CGPointMake(self.contentRight, (self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop) color:self.borderColor lineWidth:self.borderWidth/2.0];
    
    //by JopYin画多条横线
    for (int i = 1; i < 8; i++) {
        CGFloat paddingY = (self.uperChartHeightScale * self.contentHeight)/8.0;
        [self drawline:context startPoint:CGPointMake(self.contentLeft,paddingY*i + self.contentTop) stopPoint:CGPointMake(self.contentRight, paddingY*i + self.contentTop) color:self.borderColor lineWidth:self.borderWidth/2.0];
    }
    //by JopYin画多条竖线线
    for (int i = 1; i < 4; i++) {
        CGFloat paddingX = self.contentWidth/4.0;
        [self drawline:context startPoint:CGPointMake(paddingX*i+self.contentLeft,self.contentTop) stopPoint:CGPointMake(paddingX*i+self.contentLeft,self.contentTop+(self.uperChartHeightScale * self.contentHeight)) color:self.borderColor lineWidth:self.borderWidth/2.0];
    }
}

#pragma mark - 画直线
- (void)drawline:(CGContextRef)context
      startPoint:(CGPoint)startPoint
       stopPoint:(CGPoint)stopPoint
           color:(UIColor *)color
       lineWidth:(CGFloat)lineWitdth {
    if (startPoint.x < self.contentLeft ||stopPoint.x >self.contentRight || startPoint.y <self.contentTop || stopPoint.y < self.contentTop) {
        return;
    }
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, lineWitdth);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, stopPoint.x,stopPoint.y);
    CGContextStrokePath(context);
}

#pragma mark  - 画左侧价格区间指示
- (void)drawLabelPrice:(CGContextRef)context {
    NSDictionary * drawAttributes = self.leftYAxisAttributedDic?:self.defaultAttributedDic;
    //画左侧价格分布 by JopYin  画了5种价格区间指示  下面屏蔽的只画了三种价格指示
 {
    for (int i = 0; i < 5; i++) {
        CGFloat pricePad = (self.maxPrice-self.minPrice)/4.0;
        CGFloat heightPad = (self.uperChartHeightScale * self.contentHeight)/4.0;
        NSString *priceStr = [self handleStrWithPrice:self.maxPrice-pricePad*i];
        NSMutableAttributedString * priceAttStr = [[NSMutableAttributedString alloc]initWithString:priceStr attributes:drawAttributes];
        CGSize sizePriceAttStr = [priceAttStr size];
        CGRect priceRect;
        if (i == 0) {
            priceRect = CGRectMake(self.leftYAxisIsInChart?self.contentLeft:0, self.contentTop+heightPad*i, sizePriceAttStr.width, sizePriceAttStr.height);
        }else{
            priceRect = CGRectMake(self.leftYAxisIsInChart?self.contentLeft:0, self.contentTop+heightPad*i-sizePriceAttStr.height/2.0, sizePriceAttStr.width, sizePriceAttStr.height);
        }
        [priceAttStr drawInRect:priceRect];
    }
/*
    //画左侧价格最大值label
    NSString * maxPriceStr = [self handleStrWithPrice:self.maxPrice];
    NSMutableAttributedString * maxPriceAttStr = [[NSMutableAttributedString alloc]initWithString:maxPriceStr attributes:drawAttributes];
    CGSize sizeMaxPriceAttStr = [maxPriceAttStr size];
    //修改左侧价格指示 by JopYin 下面屏蔽的内容是我改的
//    CGRect maxPriceRect = CGRectMake(self.leftYAxisIsInChart?self.contentLeft:0, self.contentTop, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height);
//    [maxPriceAttStr drawInRect:maxPriceRect];
    CGRect maxPriceRect = CGRectMake(self.contentLeft - (self.leftYAxisIsInChart?0:sizeMaxPriceAttStr.width+2), self.contentTop, sizeMaxPriceAttStr.width, sizeMaxPriceAttStr.height);
    [self drawRect:context rect:maxPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:maxPriceAttStr rect:maxPriceRect];
    
    //左侧中间值
    NSString * midPriceStr = [self handleStrWithPrice:(self.maxPrice+self.minPrice)/2.0];
    NSMutableAttributedString * midPriceAttStr = [[NSMutableAttributedString alloc]initWithString:midPriceStr attributes:drawAttributes];
    CGSize sizeMidPriceAttStr = [midPriceAttStr size];
    CGRect midPriceRect = CGRectMake(self.contentLeft - (self.leftYAxisIsInChart?0:sizeMidPriceAttStr.width+2), ((self.uperChartHeightScale * self.contentHeight)/2.0 + self.contentTop)-sizeMidPriceAttStr.height/2.0, sizeMidPriceAttStr.width, sizeMidPriceAttStr.height);
    [self drawRect:context rect:midPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:midPriceAttStr rect:midPriceRect];
    
    //左侧最小值
    NSString * minPriceStr = [self handleStrWithPrice:self.minPrice];
    NSMutableAttributedString * minPriceAttStr = [[NSMutableAttributedString alloc]initWithString:minPriceStr attributes:drawAttributes];
    CGSize sizeMinPriceAttStr = [minPriceAttStr size];
    CGRect minPriceRect = CGRectMake(self.contentLeft - (self.leftYAxisIsInChart?0:sizeMinPriceAttStr.width+2), ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinPriceAttStr.height ), sizeMinPriceAttStr.width, sizeMinPriceAttStr.height);
    [self drawRect:context rect:minPriceRect color:labelBGColor];
    [self drawLabel:context attributesText:minPriceAttStr rect:minPriceRect];
*/
 }
    
    //画成交量左侧的起始点label 下面的单位 （手、万手）
    NSMutableAttributedString * zeroVolumeAttStr = [[NSMutableAttributedString alloc] initWithString:[self handleShowWithVolume:self.maxVolume] attributes:drawAttributes];
    CGSize zeroVolumeAttStrSize = [zeroVolumeAttStr size];
//    CGRect zeroVolumeRect = CGRectMake(self.contentLeft - (self.leftYAxisIsInChart?0:zeroVolumeAttStrSize.width+2), self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
    CGRect zeroVolumeRect = CGRectMake(0, self.contentBottom - zeroVolumeAttStrSize.height, zeroVolumeAttStrSize.width, zeroVolumeAttStrSize.height);
    [zeroVolumeAttStr drawInRect:zeroVolumeRect];   //by JopYin  将之前用的两个方法来画改成这个方法
    
    //画成交量左侧的最大值label
    NSString * maxVolumeStr = [self handleShowNumWithVolume:self.maxVolume];
    NSMutableAttributedString * maxVolumeAttStr = [[NSMutableAttributedString alloc]initWithString:maxVolumeStr attributes:drawAttributes];
    CGSize maxVolumeAttStrSize = [maxVolumeAttStr size];
//    CGRect maxVolumeRect = CGRectMake(self.contentLeft - (self.leftYAxisIsInChart?0:maxVolumeAttStrSize.width+2), (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
    CGRect maxVolumeRect = CGRectMake(0, (self.uperChartHeightScale * self.contentHeight)+self.xAxisHeitht, maxVolumeAttStrSize.width, maxVolumeAttStrSize.height);
    [maxVolumeAttStr drawInRect:maxVolumeRect];
    
    //画右侧的涨幅  仅分时图
    if (self.rightYAxisDrawEnabled) {
        NSString * maxRateStr = [self handleRateWithPrice:self.maxPrice originPX:(self.maxPrice+self.minPrice)/2.0];
        NSMutableAttributedString * maxRateAttStr = [[NSMutableAttributedString alloc]initWithString:maxRateStr attributes:drawAttributes];
        CGSize sizeMaxRateAttStr = [maxRateAttStr size];
         CGRect maxRateRect = CGRectMake(self.contentRight- sizeMaxRateAttStr.width, self.contentTop, sizeMaxRateAttStr.width, sizeMaxRateAttStr.height);
        [maxRateAttStr drawInRect:maxRateRect];
        
        NSString * minRateStr = [self handleRateWithPrice:self.minPrice originPX:(self.maxPrice+self.minPrice)/2.0];
        NSMutableAttributedString * minRateAttStr = [[NSMutableAttributedString alloc]initWithString:minRateStr attributes:drawAttributes];
        CGSize sizeMinRateAttStr = [minRateAttStr size];
        CGRect minRateRect = CGRectMake(self.contentRight-(self.leftYAxisIsInChart?sizeMinRateAttStr.width:0), ((self.uperChartHeightScale * self.contentHeight) + self.contentTop - sizeMinRateAttStr.height ), sizeMinRateAttStr.width, sizeMinRateAttStr.height);
        [minRateAttStr drawInRect:minRateRect];
    }
}

#pragma mark - 十字线画法   point.x= 蜡烛图中心点x坐标   point.y = 蜡烛图收盘价的y坐标
- (void)drawHighlighted:(CGContextRef)context
                  point:(CGPoint)point
                   idex:(NSInteger)idex
                  value:(id)value
                  color:(UIColor *)color
              lineWidth:(CGFloat)lineWidth{
    
    NSString * leftMarkerStr = @"";                 //K线十字线左侧价格
    NSString * bottomMarkerStr = @"";               //K线十字线日期
    NSString * rightMarkerStr = @"";                //仅分时图有
    NSString * volumeMarkerStr = @"";               //K线十字线成交量
    
    if ([value isKindOfClass:[YKTimeLineEntity class]]) {
        YKTimeLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.lastPirce];
        bottomMarkerStr = entity.currtTime;
        rightMarkerStr = entity.rate;
        
    }else if([value isKindOfClass:[YKLineEntity class]]){
        YKLineEntity * entity = value;
        leftMarkerStr = [self handleStrWithPrice:entity.close];
        bottomMarkerStr = entity.date;
        volumeMarkerStr = [NSString stringWithFormat:@"%@%@",[self handleShowNumWithVolume:entity.volume],[self handleShowWithVolume:entity.volume]];
    }else{
        return;
    }
    
    if (nil == leftMarkerStr || nil == bottomMarkerStr || nil == rightMarkerStr) {
        return;
    }
    bottomMarkerStr = [[@" " stringByAppendingString:bottomMarkerStr] stringByAppendingString:@" "];
    CGContextSetStrokeColorWithColor(context,color.CGColor);                //设置画笔颜色
    CGContextSetLineWidth(context, lineWidth);
    //十字线竖线
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, self.contentTop);
    CGContextAddLineToPoint(context, point.x, self.contentBottom);
    CGContextStrokePath(context);                           //渲染
    //十字线横线
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.contentLeft, point.y);
    CGContextAddLineToPoint(context, self.contentRight, point.y);
    CGContextStrokePath(context);                           //渲染
    
    //十字线中心圆点
    CGFloat radius = 3.0;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(point.x-(radius/2.0), point.y-(radius/2.0), radius, radius));
    
    NSDictionary * drawAttributes = self.highlightAttributedDic?:self.defaultAttributedDic;                    //十字线日期和成交量字体属性
    NSDictionary * drawLeftAtt = self.highlightAttributedLeftDic?:self.defaultAttributedDic;                   //十字线左侧字体属性
    
    //十字线左侧lable
    NSMutableAttributedString * leftMarkerStrAtt = [[NSMutableAttributedString alloc] initWithString:leftMarkerStr attributes:drawLeftAtt];
    CGSize leftMarkerStrAttSize = [leftMarkerStrAtt size];
    [leftMarkerStrAtt drawInRect:CGRectMake(0,point.y - leftMarkerStrAttSize.height/2.0, leftMarkerStrAttSize.width, leftMarkerStrAttSize.height)];
    //十字线日期label
    NSMutableAttributedString * bottomMarkerStrAtt = [[NSMutableAttributedString alloc] initWithString:bottomMarkerStr attributes:drawAttributes];
    CGSize bottomMarkerStrAttSize = [bottomMarkerStrAtt size];
    CGRect rect = CGRectMake(point.x - bottomMarkerStrAttSize.width/2.0,  ((self.uperChartHeightScale * self.contentHeight) + self.contentTop), bottomMarkerStrAttSize.width, bottomMarkerStrAttSize.height);
    if (rect.size.width + rect.origin.x > self.contentRight) {
        rect.origin.x = self.contentRight -rect.size.width;
    }
    if (rect.origin.x < self.contentLeft) {
        rect.origin.x = self.contentLeft;
    }
    [bottomMarkerStrAtt drawInRect:rect];
    
    //十字线右侧的  分时专有
    NSMutableAttributedString * rightMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:rightMarkerStr attributes:drawLeftAtt];
    CGSize rightMarkerStrAttSize = [rightMarkerStrAtt size];
    [rightMarkerStrAtt drawInRect:CGRectMake(self.contentRight-rightMarkerStrAttSize.width, point.y - rightMarkerStrAttSize.height/2.0, rightMarkerStrAttSize.width, rightMarkerStrAttSize.height)];
    
    //十字线成交量
    NSMutableAttributedString * volumeMarkerStrAtt = [[NSMutableAttributedString alloc]initWithString:volumeMarkerStr attributes:drawAttributes];
    CGSize volumeMarkerStrAttSize = [volumeMarkerStrAtt size];
    CGRect volumeMarkerRect = CGRectMake(self.contentLeft,  self.contentHeight * self.uperChartHeightScale+self.xAxisHeitht, volumeMarkerStrAttSize.width, volumeMarkerStrAttSize.height);
    [volumeMarkerStrAtt drawInRect:volumeMarkerRect];
}


- (void)drawLabel:(CGContextRef)context
   attributesText:(NSAttributedString *)attributesText
             rect:(CGRect)rect{
    [attributesText drawInRect:rect];
}

#pragma mark - 画实心矩形 
- (void)drawRect:(CGContextRef)context
            rect:(CGRect)rect
           color:(UIColor*)color{
    if ((rect.origin.x + rect.size.width) > self.contentRight) {
        return;
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
}

#pragma mark - 画空心矩形 by JopYin
- (void)drawHollowRect:(CGContextRef)context
                  rect:(CGRect)rect
                 color:(UIColor*)color{
    if ((rect.origin.x + rect.size.width) > self.contentRight) {
        return;
    }
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}

-(void)drawCirclyPoint:(CGContextRef)context
                point:(CGPoint)point
               radius:(CGFloat)radius
                color:(UIColor*)color{
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);//线的宽度
    CGContextAddArc(context, point.x, point.y, radius, 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
}


#pragma mark - 处理价格涨跌幅
- (NSString *)handleRateWithPrice:(CGFloat)price originPX:(CGFloat)originPX{
    if (0 == originPX) {
        return @"--";
    }
    CGFloat rate = (price - originPX)/originPX *100.00;
    if(rate >0){
        return [NSString stringWithFormat:@"+%.2f%@",rate,@"%"];
    }
    return [NSString stringWithFormat:@"%.2f%@",rate,@"%"];
}
#pragma mark - 处理数据，保留小数点位数
- (NSString *)handleStrWithPrice:(CGFloat)price{
    if (self.isETF) {
        return [NSString stringWithFormat:@"%.3f ",price];
    }
    return [NSString stringWithFormat:@"%.2f ",price];
}
#pragma mark - 成交量的单位处理
- (NSString *)handleShowWithVolume:(CGFloat)volume {
//    volume = volume/100.0;
    
    if (volume < 10000.0) {
        return @"手 ";
    }else if (volume > 10000.0 && volume < 100000000.0){
        return @"万手 ";
    }else{
        return @"亿手 ";
    }
}
#pragma mark - 成交量--保留小数点位数
- (NSString *)handleShowNumWithVolume:(CGFloat)volume {
//    volume = volume/100.0;
    if (volume < 10000.0) {
        return [NSString stringWithFormat:@"%.0f ",volume];
    }else if (volume > 10000.0 && volume < 100000000.0){
        return [NSString stringWithFormat:@"%.2f ",volume/10000.0];
    }else{
        return [NSString stringWithFormat:@"%.2f ",volume/100000000.0];
    }
}

- (NSDictionary *)defaultAttributedDic
{
    if (!_defaultAttributedDic) {
        _defaultAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSBackgroundColorAttributeName:[UIColor clearColor]};
    }
    return _defaultAttributedDic;
}

- (void)setHighlightLineCurrentEnabled:(BOOL)highlightLineCurrentEnabled {
    
    if (_highlightLineCurrentEnabled != highlightLineCurrentEnabled) {
        _highlightLineCurrentEnabled = highlightLineCurrentEnabled;
        if ( NO == highlightLineCurrentEnabled) {
            if ([self.delegate respondsToSelector:@selector(chartValueNothingSelected:)]) {
                [self.delegate chartValueNothingSelected:self];
            }
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
