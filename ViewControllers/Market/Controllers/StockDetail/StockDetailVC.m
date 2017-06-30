//
//  StockDetailVC.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/20.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "StockDetailVC.h"
#import "FindStockVC.h"
#import "StockDetailHeadView.h"
#import "StockCell.h"
#import "SearchStock.h"
#import "DataProvide.h"
#import "StockPublic.h"
#import "KLineViewController.h"
#import "MinViewController.h"
#import "SearchHistoryCacheManager.h"
#import "iPhoneModel.h"

#import "StockDetailSectionView.h"
#import "FSDetailTableViewCell.h"
#import "FiveDangCell.h"
#import "ConfigHeader.h"

@interface StockDetailVC ()<StockDetailKLineDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,copy)NSString *stockCode;
@property (nonatomic,copy)NSString *stockName;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong)StockDetailHeadView *headView;
@property (nonatomic,strong)KLineViewController *KLineVC;
@property (nonatomic,strong)MinViewController *minTimeVC;
@property (nonatomic,strong)UIViewController *tmpVC;        //临时存储右侧视图正在显示的控制器
@property (nonatomic,copy)NSString *preClose;               //昨收价用于传给分时控制器
@property (nonatomic,assign)BOOL isExp;                     //判断股票是否是指数  YES:指数  NO:股票
@property (nonatomic,strong)NSMutableArray *histockArr;    //浏览过的股票model，从缓存中取出


@property (nonatomic,strong)StockDetailSectionView *sectionHead;       //五档----明细头
@property (nonatomic,assign)StockDetailType dealType;

@property (nonatomic,strong)NSMutableArray *dealFenBiArray;      //成交明细分笔
@property (nonatomic,strong)QuoteModel *fiveModel;                  //主要用于五档

@end

static NSString *const detailCellID = @"FSDetailTableViewCell";
static NSString *const FiveCell = @"FiveDangCell";


@implementation StockDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - 开启定时器 -- 右侧顶部行情定时刷新
- (void)startTimer{
    if ([_timer isValid]){
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getStockData) userInfo:nil repeats:YES];
}
#pragma mark - 关闭定时器 -- 右侧顶部行情定时刷新
- (void)stopTimer {
    if ([_timer isValid]){
        [_timer setFireDate:[NSDate distantFuture]]; //关闭定时器
        _timer = nil;
    }
}

#pragma mark- 请求分笔数据
- (void)getFenBiData{
    if (self.stockCode == nil) {
        return;
    }
    NSString *stockCode = [StockPublic prefixStockCode:self.stockCode];
    [[DataProvide sharedStore] FenBiData:stockCode successBlock:^(id data) {
        if ([data isKindOfClass:[NSMutableArray class]]) {
            [self.dealFenBiArray removeAllObjects];
            [self.dealFenBiArray addObjectsFromArray:data];
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 请求头部行情数据
- (void)getStockData {
    [self getFenBiData];
    
    NSString *preStockCode = [StockPublic prefixStockCode:self.stockCode];
    [[DataProvide sharedStore] getShiShiDataWithURL:preStockCode success:^(NSArray *data) {
        if (data.count > 0) {
            QuoteModel *model = [data objectAtIndexCheck:0];
            self.preClose = model.closePrice;
            self.headView.model = model;
            self.fiveModel = model;
        }
    } failure:^(NSString *error) {
        
    }];
}

#pragma mark - 获取资金净流入
- (void)getZiJinData{
    NSString *zijinUrl = [NSString stringWithFormat:@"http://api.ihuangpu.com:8094/cgi-bin/GetZjlxData.ashx?RequestType=0&ExtStockCode=%@&DataType=ZJLX",self.stockCode];
    [[DataProvide sharedStore] HTTPRequestOperationByGet:zijinUrl successBlock:^(NSString *responseBody) {
        
        NSString *strCode = @"";
        
        //新增对股票代码的处理
        NSRange rangeCode = [responseBody rangeOfString:@"stockCode:"];
        if(rangeCode.location != NSNotFound){
            NSInteger  startPos = rangeCode.location + rangeCode.length;
            //股票代码为六位
            NSRange ran = NSMakeRange(startPos, 6);
            strCode = [responseBody substringWithRange:ran];
        }
        
        NSRange rang = [responseBody rangeOfString:@"ZlIn:" options:NSBackwardsSearch];
        if(rang.location != NSNotFound){
            NSInteger  startPos = rang.location + rang.length;
            
            NSRange rang1 = [responseBody  rangeOfString:@",CddIn:" options:NSBackwardsSearch];
            if (rang1.location != NSNotFound)
            {
                NSInteger endPos = rang1.location;
                
                NSRange ran = NSMakeRange(startPos, endPos-startPos);
                NSString *str1 = [responseBody substringWithRange:ran];
                [self.headView updateZiJin:str1];
            }
        }

    } failureBlock:^(NSString *error) {
        
    }];
}

- (instancetype)initWithStockCode:(NSString *)stockCode withStockName:(NSString *)stockName {
    self = [super init];
    if (self) {
        self.stockCode = stockCode;
        self.stockName = stockName;
        
        [self getZiJinData];          //暂时屏蔽
        [self getStockData];
        [self getFenBiData];
        NSInteger isFav = [[SearchStock shareManager] searStockIsFav:stockCode]; //1和2:是指数 1:是上证指数  2：深证指数  0:不是指数是普通股票
        
        if (isFav == 0) {
            //普通股票
            self.isExp = NO;
        }else{
            self.isExp = YES;
        }
//        [self setupNavi];
        //存储浏览股票中
      {
        //1.先从缓存中取
        self.histockArr = [NSMutableArray arrayWithArray:[[SearchHistoryCacheManager shareInstance] searchHistoryKeywords]];
        //2.将model存入到这个数组中
        StockModel *model = [[SearchStock shareManager] searchModel:self.stockCode];
        [self.histockArr enumerateObjectsUsingBlock:^(StockModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.stockCode == nil) {
                [self.histockArr removeObject:obj];
            }
            if ([obj.stockCode isEqualToString:model.stockCode]) {
                [self.histockArr removeObject:obj];
            }
        }];
        [self.histockArr insertObject:model atIndex:0];
        if (self.histockArr.count > 10) {
            [self.histockArr removeLastObject];
        }
        //3.把数组存入到YYCache中
        [[SearchHistoryCacheManager shareInstance] cacheSearchHistory:self.histockArr];
      }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self drawBackButton];
    [self setupSearchBtn];
    if (self.isExp) {
        [self setNavTitle:[NSString stringWithFormat:@"%@",self.stockName]];
    }else{
        [self setNavTitle:[NSString stringWithFormat:@"%@ %@",self.stockName,self.stockCode]];
    }
    
    [self setupTableView];
    
    [self startTimer];
    self.KLineVC.view.frame = self.headView.KLineView.bounds;
    [self addChildViewController:self.KLineVC];
    [self.headView.KLineView addSubview:self.KLineVC.view];
    self.tmpVC = self.KLineVC;
    [self showKLine];
    
}

#pragma  mark - 创建导航栏
- (void)setupSearchBtn{
    UIImage * searchImg = [[UIImage imageNamed:@"Navi_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    UIImage * refreshImg = [[UIImage imageNamed:@"refresh"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * search = [[UIBarButtonItem alloc]initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:@selector(navigationBarRightButton)];
    
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc]initWithImage:refreshImg style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    
    [self.navigationItem setRightBarButtonItems:@[refresh,search]];
}

#pragma mark - 导航栏右侧搜索按钮点击事件
- (void)navigationBarRightButton {
    FindStockVC *find = [[FindStockVC alloc] init];
    [self.navigationController pushViewController:find animated:YES];
}
- (void)refreshData{
    [self getStockData];
}
#pragma mark - 初始化tableView
- (void)setupTableView {
    self.headView = [StockDetailHeadView headView];
    self.headView.delegate = self;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FSDetailTableViewCell" bundle:nil] forCellReuseIdentifier:detailCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"FiveDangCell" bundle:nil] forCellReuseIdentifier:FiveCell];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dealType == FiveDang) {
        return 1;
    }
    return self.dealFenBiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dealType ==  FiveDang ) {
        FiveDangCell *cell = [tableView dequeueReusableCellWithIdentifier:FiveCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.fiveModel;
        return  cell;
    }else{
        FSDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model.preClose = self.preClose;
        cell.model = [self.dealFenBiArray objectAtIndex:indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dealType == FiveDang) {
        return 190;
    }else{
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    __weak typeof(self) weakSelf = self;
    self.sectionHead.headClickBlock = ^(StockDetailType dealType) {
        weakSelf.dealType = dealType;
        [weakSelf.tableView reloadData];
    };
    return self.sectionHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0f;
}

#pragma mark - 加入自选
- (void)addToSelectStock:(id)sender {
    if ([[SearchStock shareManager] isExistInTable:self.stockCode]) {
        [StockPublic deleteStockFromServerWithStockCode:self.stockCode]; //向服务器删除自选
        [[SearchStock shareManager] deleteToTable:self.stockCode];
        
    }else {
        [StockPublic addStockFromServerWithStockCode:self.stockCode];  //向服务器添加自选
        [[SearchStock shareManager] insertToTable:self.stockCode];
        
    }
}



#pragma mark -- 代理方法 加载K线和分时  StockDetailKLineDelegate
- (void)fenShiLine{
    self.minTimeVC.preClose = self.preClose;
    
    [self replaceRightController:self.KLineVC newController:self.minTimeVC];
}
- (void)dayKLine{
    self.KLineVC.klineType = @"4";
    [self showKLine];
}
- (void)weekLine{
    self.KLineVC.klineType = @"5";
    [self showKLine];
}
- (void)monthKLine{
    self.KLineVC.klineType = @"6";
    [self showKLine];
}
- (void)hourKLine{
    self.KLineVC.klineType = @"3";
    [self showKLine];
}

- (void)showKLine {
    if (self.tmpVC != self.KLineVC) {
        //当从分时切换到K线
        [self replaceRightController:self.tmpVC newController:self.KLineVC];
    }else{
        //当日K、周K、月K、60分钟相互切换时候 或者点击左侧视图切换过来
        [self.KLineVC updateKLine];
    }
}

#pragma mark - 加载K线视图
- (void)replaceRightController:(UIViewController *)oldController newController:(UIViewController *)newController{
    newController.view.frame = self.headView.KLineView.bounds;
    [self addChildViewController:newController];
    [oldController willMoveToParentViewController:nil];
    [self.headView.KLineView addSubview:newController.view];
    __weak id weakSelf = self;
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
    } completion:^(BOOL finished) {
        [oldController.view removeFromSuperview];
        [oldController removeFromParentViewController];
        [newController didMoveToParentViewController:weakSelf];
        _tmpVC = newController;
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




#pragma mark - 懒加载tableView并设置代理
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, UI_WIDTH, self.view.height-49-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (KLineViewController *)KLineVC {
    if (_KLineVC == nil) {
        _KLineVC = [[KLineViewController alloc] init];
        _KLineVC.stockCode = [StockPublic prefixStockCode:self.stockCode];
        _KLineVC.klineType = @"4";
    }
    return _KLineVC;
}

- (MinViewController *)minTimeVC {
    if (_minTimeVC == nil) {
        _minTimeVC = [[MinViewController alloc] init];
        _minTimeVC.isExp = _isExp;
        _minTimeVC.stockCode = [StockPublic prefixStockCode:self.stockCode];
    }
    return _minTimeVC;
}


- (NSMutableArray *)histockArr{
    if (_histockArr == nil) {
        _histockArr = [[NSMutableArray alloc] init];
    }
    return _histockArr;
}

- (StockDetailSectionView *) sectionHead {
    if (!_sectionHead) {
        _sectionHead = [[StockDetailSectionView alloc] init];
    }
    return _sectionHead;
}

- (NSMutableArray *)dealFenBiArray{
    if (_dealFenBiArray == nil) {
        _dealFenBiArray = [NSMutableArray array];
    }
    return _dealFenBiArray;
}

- (void)dealloc {
    [self stopTimer];
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
