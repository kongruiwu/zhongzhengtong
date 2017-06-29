//
//  MinViewController.m
//  GuShang
//
//  Created by JopYin on 2016/12/1.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import "MinViewController.h"

#import "MinModel.h"
#import "DataProvide.h"

@interface MinViewController ()<YKLineChartViewDelegate>

@property (nonatomic, strong)NSMutableArray *minDataArr;
@property (nonatomic,strong)YKTimeDataset *dataSet;
@property (nonatomic, strong) NSTimer *minTimer;
@end

@implementation MinViewController
- (YKTimeDataset *)dataSet {
    if (_dataSet == nil) {
        _dataSet = [[YKTimeDataset alloc] init];
        _dataSet.avgLineCorlor = [UIColor colorWithRed:243/255.0 green:119/255.0 blue:13/255.0 alpha:1.0];
        _dataSet.priceLineCorlor = [UIColor colorWithRed:62/255.0 green:147/255.0 blue:241/255.0 alpha:1.0];
        _dataSet.lineWidth = 0.8f;
        _dataSet.highlightLineWidth = .3f;
        _dataSet.highlightLineColor = [UIColor colorWithRed:17/255.0 green:64/255.0 blue:104/255.0 alpha:1.0];
        
        _dataSet.volumeTieColor  = [UIColor colorWithRed:250/255.0 green:9/255.0 blue:38/255.0 alpha:1.0];
        _dataSet.volumeRiseColor = [UIColor colorWithRed:250/255.0 green:9/255.0 blue:38/255.0 alpha:1.0];
        _dataSet.volumeFallColor = [UIColor colorWithRed:35/255.0 green:209/255.0 blue:167/255.0 alpha:1.0];
        
        _dataSet.fillStartColor = [UIColor colorWithRed:224/255.0 green:239/255.0 blue:255/255.0 alpha:1.0];
        _dataSet.fillStopColor =  [UIColor colorWithRed:224/255.0 green:239/255.0 blue:255/255.0 alpha:1.0];
        _dataSet.fillAlpha = 0.7f;
        _dataSet.drawFilledEnabled = YES;
    }
    return _dataSet;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimer];
    [self getMinData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
}
#pragma mark - 开启定时器
- (void)startTimer{
    if ([_minTimer isValid])
    {
        [_minTimer invalidate];
    }
    _minTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(getMinData) userInfo:nil repeats:YES];
}
#pragma mark - 关闭定时器
- (void)stopTimer {
    if ([_minTimer isValid])
    {
        [_minTimer setFireDate:[NSDate distantFuture]]; //关闭定时器
        _minTimer = nil;
    }
}

#pragma mark - 获取分时接口数据
- (void)getMinData{
    if (self.stockCode == nil) {
        return;
    }
    [[DataProvide sharedStore] MinData:self.stockCode successBlock:^(id data) {
        [self.minDataArr removeAllObjects];
        for (MinModel*model in data) {
            YKTimeLineEntity * e = [[YKTimeLineEntity alloc]init];
            e.currtTime   = model.time;
            e.preClosePx  = [self.preClose floatValue];
            if (self.isExp) {
                e.avgPirce    = [self.preClose floatValue];
            }else{
                e.avgPirce    = [model.avgPrice floatValue];
            }
            e.lastPirce   = [model.price floatValue];
            e.rate        = [NSString stringWithFormat:@"%.2lf%%",([model.price floatValue]-[self.preClose floatValue])*100/[self.preClose floatValue]];
            e.change      = [NSString stringWithFormat:@"%.2lf",[model.price floatValue]-[self.preClose floatValue]];
            e.volume      = model.preVol;
            [self.minDataArr addObject:e];
        }
        self.dataSet.data = self.minDataArr;
        [self.minTimeView setupData:self.dataSet];
    } failure:^(NSString *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMinData];
    [self setupMinTimeView];
}

#pragma mark --设置分时图的一些基本元素
- (void)setupMinTimeView{
    [self.minTimeView setupChartOffsetWithLeft:20 top:2 right:2 bottom:2];
    self.minTimeView.gridBackgroundColor = [UIColor whiteColor];
    self.minTimeView.borderColor = [UIColor colorWithRed:125/255.0 green:125/255.0 blue:125/255.0 alpha:1.0];
    self.minTimeView.borderWidth = .2;
    self.minTimeView.uperChartHeightScale = 0.8;
    self.minTimeView.xAxisHeitht = 15;
    self.minTimeView.countOfTimes = 242;
    self.minTimeView.delegate = self;
    self.minTimeView.highlightLineShowEnabled = YES;
    self.minTimeView.endPointShowEnabled = YES;
    self.minTimeView.isDrawAvgEnabled = !self.isExp;
    self.minTimeView.xAxisAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:154/255.0 green:173/255.0 blue:200/255.0 alpha:1.0]};
    self.minTimeView.leftYAxisAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:154/255.0 green:173/255.0 blue:200/255.0 alpha:1.0]};
    self.minTimeView.highlightAttributedDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.minTimeView.highlightAttributedLeftDic = @{NSFontAttributeName:[UIFont systemFontOfSize:8],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.minTimeView.detailDataAttDic = @{NSFontAttributeName:[UIFont systemFontOfSize:6],NSBackgroundColorAttributeName:[UIColor clearColor],NSForegroundColorAttributeName:[UIColor colorWithRed:179/255.0 green:186/255.0 blue:194/255.0 alpha:1.0]};
}

#pragma mark - 懒加载
- (NSMutableArray *)minDataArr {
    if (_minDataArr == nil) {
        _minDataArr = [NSMutableArray array];
    }
    return _minDataArr;
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
