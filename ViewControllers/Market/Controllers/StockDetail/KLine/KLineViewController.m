//
//  KLineViewController.m
//  GuShang
//
//  Created by JopYin on 2016/12/1.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import "KLineViewController.h"
#import "YKLineChart.h"
#import "KLineModel.h"
#import "DataProvide.h"

@interface KLineViewController ()<YKLineChartViewDelegate>

@property (weak, nonatomic) IBOutlet YKLineChartView *klineView;

@property (nonatomic,strong)YKLineDataSet *kLineDataSet;

@property (nonatomic, strong)NSMutableArray *kLineDataArr;

@property (nonatomic, strong) NSTimer *kLineTimer;

@end

@implementation KLineViewController
#pragma mark - 懒加载
- (NSMutableArray *)kLineDataArr {
    if (_kLineDataArr == nil) {
        _kLineDataArr = [NSMutableArray array];
    }
    return _kLineDataArr;
}

- (YKLineDataSet *)kLineDataSet {
    if (_kLineDataSet == nil) {
        _kLineDataSet = [[YKLineDataSet alloc] init];
        _kLineDataSet.highlightLineWidth = 0.3;
        _kLineDataSet.highlightLineColor = [UIColor colorWithRed:17/255.0 green:64/255.0 blue:104/255.0 alpha:1.0];
        _kLineDataSet.candleRiseColor = [UIColor colorWithRed:250/255.0 green:9/255.0 blue:38/255.0 alpha:1.0];
        _kLineDataSet.candleFallColor = [UIColor colorWithRed:35/255.0 green:209/255.0 blue:167/255.0 alpha:1.0];
        _kLineDataSet.avgLineWidth = 1.f;
        _kLineDataSet.avgMA5Color  = [UIColor colorWithRed:234/255.0 green:113/255.0 blue:24/255.0 alpha:1.0];
        _kLineDataSet.avgMA10Color = [UIColor colorWithRed:23/255.0 green:138/255.0 blue:196/255.0 alpha:1.0];
        _kLineDataSet.avgMA20Color = [UIColor colorWithRed:213/255.0 green:79/255.0 blue:200/255.0 alpha:1.0];
        _kLineDataSet.candleTopBottmLineWidth = 0.5;
    }
    return _kLineDataSet;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimer];
    [self updateKLine];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
}
#pragma mark - 开启定时器
- (void)startTimer{
    if ([_kLineTimer isValid]){
        [_kLineTimer invalidate];
    }
    _kLineTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(updateKLine) userInfo:nil repeats:YES];
}
#pragma mark - 关闭定时器
- (void)stopTimer {
    if ([_kLineTimer isValid]){
        [_kLineTimer setFireDate:[NSDate distantFuture]]; //关闭定时器
        _kLineTimer = nil;
    }
}

#pragma mark - 获取K线接口数据
- (void)updateKLine{
    if (self.stockCode == nil) {
        return ;
    }
    NSString *urlStr = [NSString stringWithFormat:@"symbol=%@&klinetype=%@&datalen=200&startIndex=0",self.stockCode,self.klineType];
    [[DataProvide sharedStore] KLineData:urlStr successBlock:^(id data) {
        [self.kLineDataArr removeAllObjects];
        for (KLineModel *model in data) {
            YKLineEntity * entity = [[YKLineEntity alloc]init];
            entity.date   = model.time;
            entity.open   = [model.openPrice floatValue];        //开盘价
            entity.high   = [model.highPrice floatValue];        //最高价
            entity.low    = [model.lowPrice floatValue];         //最低价
            entity.close  = [model.closePrice floatValue];       //收盘价
            entity.volume = [model.VOL floatValue];
            entity.amount = [model.amount floatValue];
            entity.change = model.change;
            entity.rate   = model.changeRate;
            entity.ma5    = model.ma5;
            entity.ma10   = model.ma10;          //10日
            entity.ma20   = model.ma20;
            entity.preClosePx = model.preClosePx;
            entity.index  = model.index;
            [self.kLineDataArr addObject:entity];
        }
        self.kLineDataSet.data = self.kLineDataArr;
        [self.klineView setupData:self.kLineDataSet];
    } failure:^(NSString *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateKLine];
    // Do any additional setup after loading the view from its nib.
    
    [self.klineView setupChartOffsetWithLeft:20 top:2 right:2 bottom:2];
    self.klineView.gridBackgroundColor = [UIColor whiteColor];
    self.klineView.borderColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    self.klineView.borderWidth = .2;
    self.klineView.candleWidth = 8;
    self.klineView.candleMaxWidth = 30;
    self.klineView.candleMinWidth = 1;
    self.klineView.uperChartHeightScale = 0.8;
    self.klineView.xAxisHeitht = 15;
    self.klineView.delegate = self;
    self.klineView.highlightLineShowEnabled = YES;
    self.klineView.leftYAxisIsInChart = NO;
    self.klineView.highlightAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.klineView.highlightAttributedLeftDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.klineView.avgLabelAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:6],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.klineView.detailDataAttDic = @{NSFontAttributeName:[UIFont systemFontOfSize:6],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:179/255.0 green:186/255.0 blue:194/255.0 alpha:1.0]};
    self.klineView.leftYAxisAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0]};
    self.klineView.zoomEnabled = YES;
    self.klineView.scrollEnabled = YES;
    self.klineView.isShowAvgMarkerEnabled = YES;
}

-(void)chartValueSelected:(YKViewBase *)chartView entry:(id)entry entryIndex:(NSInteger)entryIndex{
    
}

- (void)chartValueNothingSelected:(YKViewBase *)chartView{
}

- (void)chartKlineScrollLeft:(YKViewBase *)chartView{
    
}


-(void)beginAppearanceTransition:(BOOL)isAppearing animated:(BOOL)animated{
    
}

-(void)endAppearanceTransition{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
