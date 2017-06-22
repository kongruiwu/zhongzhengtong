//
//  YKTimeLineView.m
//  YKLineChartView
//
//  Created by chenyk on 15/12/10.
//  Copyright © 2015年 chenyk. All rights reserved.
//  https://github.com/chenyk0317/YKLineChartView

#import "YKTimeLineView.h"
#import "YKLineEntity.h"
#import "StockPublic.h"

@interface YKTimeLineView()

@property (nonatomic,assign) CGFloat volumeWidth;
@property (nonatomic,strong)YKTimeDataset * dataset;
@property (nonatomic,strong)UILongPressGestureRecognizer * longPressGesture;    //长按
@property (nonatomic,strong)UITapGestureRecognizer * tapGesture;
@property (nonatomic,strong)CALayer * breathingPoint;

@end

@implementation YKTimeLineView

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
    [self addGestureRecognizer:self.longPressGesture];
    [self addGestureRecognizer:self.tapGesture];
}

#pragma mark - 私有属性get方法
- (CGFloat)volumeWidth {
    return self.contentWidth/self.countOfTimes;
}

- (void)setupData:(YKTimeDataset *)dataSet {
    self.dataset = dataSet;
    [self notifyDataSetChanged];
}

- (void)setCurrentDataMaxAndMin{
    if (self.dataset.data.count > 0) {
        self.maxPrice = CGFLOAT_MIN;
        self.minPrice = CGFLOAT_MAX;
        self.maxVolume = CGFLOAT_MIN;
        self.offsetMaxPrice = CGFLOAT_MIN;
        for (NSInteger i = 0; i < self.dataset.data.count; i++) {
            YKTimeLineEntity  * entity = [self.dataset.data objectAtIndex:i];
            
            self.offsetMaxPrice = self.offsetMaxPrice > fabs(entity.lastPirce-entity.preClosePx)?self.offsetMaxPrice:fabs(entity.lastPirce-entity.preClosePx);
            if (entity.avgPirce) {
              self.offsetMaxPrice = self.offsetMaxPrice > fabs(entity.avgPirce - entity.preClosePx)?self.offsetMaxPrice:fabs(entity.avgPirce - entity.preClosePx);
            }
            self.maxVolume = self.maxVolume >entity.volume ? self.maxVolume : entity.volume;
        }
        self.maxPrice =((YKTimeLineEntity *)[self.dataset.data firstObject]).preClosePx + self.offsetMaxPrice;
        self.minPrice =((YKTimeLineEntity *)[self.dataset.data firstObject]).preClosePx - self.offsetMaxPrice;
        
        if (self.maxPrice == self.minPrice) {
            self.maxPrice = self.maxPrice + 0.01;
            self.minPrice = self.minPrice - 0.01;
        }
        for (NSInteger i = 0; i < self.dataset.data.count; i++) {
            YKTimeLineEntity  * entity = [self.dataset.data objectAtIndex:i];
            if (entity.avgPirce != 0) {
                entity.avgPirce = entity.avgPirce < self.minPrice ? self.minPrice :entity.avgPirce;
                entity.avgPirce = entity.avgPirce > self.maxPrice ? self.maxPrice :entity.avgPirce;
            }
        }
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setCurrentDataMaxAndMin];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridBackground:context rect:rect];
    
    [self drawTimeLabel:context];
    if (self.dataset.data.count>0) {
        [self drawTimeLine:context];
    }
    [self drawLabelPrice:context];
}

- (void)drawGridBackground:(CGContextRef)context rect:(CGRect)rect {
    [super drawGridBackground:context rect:rect];
    //画分时图中的中心点，11:30/1:00
    [self drawline:context startPoint:CGPointMake(self.contentWidth/2.0 + self.contentLeft, self.contentTop) stopPoint:CGPointMake(self.contentWidth/2.0 + self.contentLeft,(self.uperChartHeightScale * self.contentHeight)+self.contentTop) color:self.borderColor lineWidth:self.borderWidth/2.0];
}

- (void)drawTimeLabel:(CGContextRef)context {
    NSDictionary * drawAttributes = self.xAxisAttributedDic ?: self.defaultAttributedDic;
    
    NSMutableAttributedString * startTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"9:30" attributes:drawAttributes];
    CGSize sizeStartTimeAttStr = [startTimeAttStr size];
    [self drawLabel:context attributesText:startTimeAttStr rect:CGRectMake(self.contentLeft, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeStartTimeAttStr.width, sizeStartTimeAttStr.height)];
    
    NSMutableAttributedString * midTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"11:30/13:00" attributes:drawAttributes];
    CGSize sizeMidTimeAttStr = [midTimeAttStr size];
    [self drawLabel:context attributesText:midTimeAttStr rect:CGRectMake(self.contentWidth/2.0 + self.contentLeft - sizeMidTimeAttStr.width/2.0, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeMidTimeAttStr.width, sizeMidTimeAttStr.height)];
    
    NSMutableAttributedString * stopTimeAttStr = [[NSMutableAttributedString alloc]initWithString:@"15:00" attributes:drawAttributes];
    CGSize sizeStopTimeAttStr = [stopTimeAttStr size];
    [self drawLabel:context attributesText:stopTimeAttStr rect:CGRectMake(self.contentRight -sizeStopTimeAttStr.width, (self.uperChartHeightScale * self.contentHeight+self.contentTop), sizeStopTimeAttStr.width, sizeStopTimeAttStr.height)];
}
- (void)drawTimeLine:(CGContextRef)context {
    CGContextSaveGState(context);
    self.candleCoordsScale = (self.uperChartHeightScale * self.contentHeight)/(self.maxPrice-self.minPrice);
    self.volumeCoordsScale = (self.contentHeight - (self.uperChartHeightScale * self.contentHeight)-self.xAxisHeitht)/(self.maxVolume - 0);
    
    CGMutablePathRef fillPath = CGPathCreateMutable();
    
    for (NSInteger i = 0 ; i< self.dataset.data.count; i ++) {
        YKTimeLineEntity  * entity  = [self.dataset.data objectAtIndex:i];
        CGFloat left = self.volumeWidth * i + self.contentLeft + self.volumeWidth / 6.0;
        CGFloat candleWidth = self.volumeWidth - self.volumeWidth / 6.0;
        CGFloat startX = left + candleWidth/2.0 ;               //每个成交量的中心点
        CGFloat  yPrice = 0;
        UIColor * color = self.dataset.volumeRiseColor;
        if (i > 0){
            YKTimeLineEntity * lastEntity = [self.dataset.data objectAtIndex:i -1];
            CGFloat lastX = startX - self.volumeWidth;
            
            CGFloat lastYPrice = (self.maxPrice - lastEntity.lastPirce)*self.candleCoordsScale + self.contentTop;
            
            yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale  + self.contentTop;
            
            [self drawline:context startPoint:CGPointMake(lastX, lastYPrice) stopPoint:CGPointMake(startX, yPrice) color:self.dataset.priceLineCorlor lineWidth:self.dataset.lineWidth];
            
            if (self.isDrawAvgEnabled) {
                if (lastEntity.avgPirce > 0 && entity.avgPirce > 0) {
                    CGFloat lastYAvg = (self.maxPrice - lastEntity.avgPirce)*self.candleCoordsScale  + self.contentTop;
                    CGFloat  yAvg = (self.maxPrice - entity.avgPirce)*self.candleCoordsScale  + self.contentTop;
                    
                    [self drawline:context startPoint:CGPointMake(lastX, lastYAvg) stopPoint:CGPointMake(startX, yAvg) color:self.dataset.avgLineCorlor lineWidth:self.dataset.lineWidth];
                }
            }
            
            if (entity.lastPirce > lastEntity.lastPirce) {
                color = self.dataset.volumeRiseColor;
            }else if (entity.lastPirce < lastEntity.lastPirce){
                color = self.dataset.volumeFallColor;
            }else{
                color = self.dataset.volumeTieColor;
            }
            
            if (1 == i) {
                CGPathMoveToPoint(fillPath, NULL, self.contentLeft, (self.uperChartHeightScale * self.contentHeight) + self.contentTop);
                CGPathAddLineToPoint(fillPath, NULL, self.contentLeft,lastYPrice);
                CGPathAddLineToPoint(fillPath, NULL, lastX, lastYPrice);
            }else{
                CGPathAddLineToPoint(fillPath, NULL, startX, yPrice);
            }
            if ((self.dataset.data.count - 1) == i) {
                CGPathAddLineToPoint(fillPath, NULL, startX, yPrice);
                CGPathAddLineToPoint(fillPath, NULL, startX, (self.uperChartHeightScale * self.contentHeight) + self.contentTop);
                CGPathCloseSubpath(fillPath);
            }
        }
        
        //成交量
        CGFloat volume = ((entity.volume - 0) * self.volumeCoordsScale);
        [self drawRect:context rect:CGRectMake(left, self.contentBottom - volume , candleWidth, volume) color:color];
        
        //十字线
        if (self.highlightLineCurrentEnabled) {
            if (i == self.highlightLineCurrentIndex) {
                if (i == 0) {
                    yPrice = (self.maxPrice - entity.lastPirce)*self.candleCoordsScale  + self.contentTop;
                }
                
                YKTimeLineEntity * entity;
                if (i < self.dataset.data.count) {
                    entity = [self.dataset.data objectAtIndex:i];
                }
                [self drawHighlighted:context point:CGPointMake(startX, yPrice) idex:i value:entity color:self.dataset.highlightLineColor lineWidth:self.dataset.highlightLineWidth ];
                BOOL isDrawRight = startX < (self.contentRight)/2.0;                                    //比较十字线的位置在视图的中线左边还是右边
                [self drwaDetailData:context idex:i isDrawRight:isDrawRight];
                if ([self.delegate respondsToSelector:@selector(chartValueSelected:entry:entryIndex:) ]) {
                    [self.delegate chartValueSelected:self entry:entity entryIndex:i];
                }
            }
        }
        
        if (self.endPointShowEnabled) {
            if (i == self.dataset.data.count - 1 && i != self.countOfTimes-1) {
                self.breathingPoint.frame = CGRectMake(startX-4/2, yPrice-4/2,4,4);
            }
        }
    }
    
    if (self.dataset.drawFilledEnabled && self.dataset.data.count > 0) {
        [self drawLinearGradient:context path:fillPath alpha:self.dataset.fillAlpha startColor:self.dataset.fillStartColor.CGColor endColor:self.dataset.fillStopColor.CGColor];
    }
    CGPathRelease(fillPath);
 
    CGContextRestoreGState(context);
}

#pragma mark - 画十字线弹框详情视图
- (void)drwaDetailData:(CGContextRef)context
                  idex:(NSInteger)idex
           isDrawRight:(BOOL)isDrawRight {
    YKTimeLineEntity  * entity = self.dataset.data[idex];;
    NSDictionary * attDic = self.detailDataAttDic ?:self.defaultAttributedDic;
    NSString * date = entity.currtTime;
    NSMutableAttributedString * dateAttStr = [[NSMutableAttributedString alloc] initWithString:date attributes:attDic];
    CGSize dateAttSize = [dateAttStr size];
    
    NSString * open = [NSString stringWithFormat:@"价格   %.2f",entity.lastPirce];
    NSMutableAttributedString * openAttStr = [[NSMutableAttributedString alloc] initWithString:open attributes:attDic];
    CGSize openAttSize = [openAttStr size];
    
    NSString * high = [NSString stringWithFormat:@"均价   %.2f",entity.avgPirce];
    NSMutableAttributedString * highAttStr = [[NSMutableAttributedString alloc] initWithString:high attributes:attDic];
    CGSize highAttSize = [highAttStr size];
    
    NSString * change = [NSString stringWithFormat:@"涨跌额 %@",entity.change];
    NSMutableAttributedString * changeAttStr = [[NSMutableAttributedString alloc] initWithString:change attributes:attDic];
    CGSize changeAttSize = [changeAttStr size];
    
    NSString * changeRate = [NSString stringWithFormat:@"涨跌幅 %@",entity.rate];
    NSMutableAttributedString * rateAttStr = [[NSMutableAttributedString alloc] initWithString:changeRate attributes:attDic];
    CGSize changeRateAttSize = [rateAttStr size];
    
    NSString * VOL = [NSString stringWithFormat:@"成交量 %@",[StockPublic calculateFloat:entity.volume]];
    NSMutableAttributedString * VOLAttStr = [[NSMutableAttributedString alloc] initWithString:VOL attributes:attDic];
    CGSize VOLAttSize = [VOLAttStr size];
    
//    NSString * amount = [NSString stringWithFormat:@"成交额 %.2f",entity.trade];
//    NSMutableAttributedString * amountAttStr = [[NSMutableAttributedString alloc] initWithString:amount attributes:attDic];
//    CGSize amountAttSize = [amountAttStr size];
    
    CGFloat spaceY = 2.0;
    CGFloat height = dateAttSize.height +openAttSize.height+highAttSize.height+changeAttSize.height+changeRateAttSize.height+VOLAttSize.height+8*spaceY;
    CGFloat width = changeRateAttSize.width;
    
    CGPoint origin = CGPointMake(self.contentLeft, self.contentTop);
    if (isDrawRight) {
        origin.x = self.contentRight - width ;
    }
    
    [self drawRect:context rect:CGRectMake(origin.x, self.contentTop, width, height) color:[UIColor colorWithRed:17/255.0 green:64/255.0 blue:104/255.0 alpha:0.8]];     //画详情框背景
    CGFloat labelY = origin.y +spaceY;
    [dateAttStr    drawInRect:CGRectMake(origin.x, labelY, dateAttSize.width, dateAttSize.height)];                         //日期
    labelY += spaceY+dateAttSize.height;
    [openAttStr    drawInRect:CGRectMake(origin.x, labelY, openAttSize.width, openAttSize.height)];                         //价格
    labelY += spaceY+openAttSize.height;
    [highAttStr    drawInRect:CGRectMake(origin.x, labelY, highAttSize.width, highAttSize.height)];                         //均价
    labelY += spaceY+highAttSize.height;
    [changeAttStr  drawInRect:CGRectMake(origin.x, labelY, changeAttSize.width, changeAttSize.height)];                     //涨跌额
    labelY += spaceY+changeAttSize.height;
    [rateAttStr    drawInRect:CGRectMake(origin.x, labelY, changeRateAttSize.width, changeRateAttSize.height)];             //涨跌幅
    labelY += spaceY+changeRateAttSize.height;
    [VOLAttStr     drawInRect:CGRectMake(origin.x, labelY, VOLAttSize.width, VOLAttSize.height)];                           //成交量
//    labelY += spaceY+VOLAttSize.height;
//    [amountAttStr  drawInRect:CGRectMake(origin.x, labelY, amountAttSize.width, amountAttSize.height)];                     //成交额
}

- (UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressGestureAction:)];
        _longPressGesture.minimumPressDuration = 0.5;
    }
    return _longPressGesture;
}
- (void)handleLongPressGestureAction:(UIPanGestureRecognizer *)recognizer
{
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

- (void)getHighlightByTouchPoint:(CGPoint) point
{
    
    self.highlightLineCurrentIndex = (NSInteger)((point.x - self.contentLeft)/self.volumeWidth);
    [self setNeedsDisplay];
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongTapGestureAction:)];
    }
    return _tapGesture;
}
- (void)handleLongTapGestureAction:(UITapGestureRecognizer *)recognizer
{
    if (self.highlightLineCurrentEnabled) {
        self.highlightLineCurrentEnabled = NO;
    }
    [self setNeedsDisplay];
}
- (void)notifyDataSetChanged
{
    [super notifyDataSetChanged];
    [self setNeedsDisplay];
}
- (void)notifyDeviceOrientationChanged{
    [super notifyDeviceOrientationChanged];
}

- (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                     alpha:(CGFloat)alpha
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextSetAlpha(context, self.dataset.fillAlpha);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

#pragma mark - 呼吸点动画效果
- (CALayer *)breathingPoint {
    if (!_breathingPoint) {
        _breathingPoint = [CAScrollLayer layer];
        [self.layer addSublayer:_breathingPoint];
        _breathingPoint.backgroundColor = [UIColor whiteColor].CGColor;
        _breathingPoint.cornerRadius = 2;
        _breathingPoint.masksToBounds = YES;
        _breathingPoint.borderWidth = 1;
        _breathingPoint.borderColor = self.dataset.priceLineCorlor.CGColor;

        [_breathingPoint addAnimation:[self groupAnimationDurTimes:1.5f] forKey:@"breathingPoint"];
    }
    return _breathingPoint;
}

-(CABasicAnimation *)breathingLight:(float)time {
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.3f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}
-(CAAnimationGroup *)groupAnimationDurTimes:(float)time{
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    
    NSArray * array = @[[self breathingLight:time],scaleAnim];
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    animation.animations= array;
    animation.duration=time;
    animation.repeatCount=MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    return animation;
}

@end
