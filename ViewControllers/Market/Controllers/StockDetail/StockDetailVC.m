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
#import "ExpHeadView.h"
#import "StockCell.h"
#import "SearchStock.h"
#import "DataProvide.h"
#import "StockPublic.h"
#import "KLineViewController.h"
#import "MinViewController.h"
#import "StockHeadView.h"
#import "SearchHistoryCacheManager.h"
#import "ExpNoDataCell.h"
#import "StockNewsModel.h"
#import "AdiviserNodataCell.h"
#import "iPhoneModel.h"
#import "ConfigHeader.h"

@interface StockDetailVC ()<UITableViewDelegate,UITableViewDataSource,StockDetailKLineDelegate,StockNewsDelegate >

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy)NSString *stockCode;
@property (nonatomic, copy)NSString *stockName;
@property (nonatomic, strong) NSTimer *timer;               //用于刷新右侧视图顶部数据
@property (nonatomic, strong)StockDetailHeadView *headView;
@property (nonatomic,strong)KLineViewController *KLineVC;
@property (nonatomic,strong)MinViewController *minTimeVC;
@property (nonatomic,strong)UIViewController *tmpVC;        //临时存储右侧视图正在显示的控制器
@property (nonatomic,copy)NSString *preClose;               //昨收价用于传给分时控制器
@property (nonatomic,assign)BOOL isExp;                     //判断股票是否是指数  YES:指数  NO:股票
@property (nonatomic,assign)BOOL isShowTop;                  //判断股票是否要显示回到顶部按钮，当只子指数的时候就不要显示
@property (nonatomic, weak)UIButton *addStockBtn;           //底部加入自选按钮
@property (nonatomic, strong)NSMutableArray *histockArr;    //浏览过的股票model，从缓存中取出
@property (nonatomic, strong)NSMutableArray *expArr;        //存放属于上证指数的指数
@property (nonatomic, strong)NSMutableArray *expDataArr;   //保存上证指数中子指数的实时行情数据

/***股票新闻相关***/
@property (nonatomic, assign) NSInteger sectionIndex;           //股票资讯类型 0：新闻 1：公告 2：研报 
@property (nonatomic, assign) NSInteger pageIndex;              //新闻参数请求的页码
@property (nonatomic, strong) NSMutableArray *newsArray;        //存放该股票新闻数组
@property (nonatomic, assign) NSInteger count;                  //该股票新闻总数

@property (nonatomic, strong) NSMutableArray *noticeArray;        //存放该股票公告数组
@property (nonatomic, strong) NSMutableArray *yanBaoArray;        //存放该股票研报数组
@property (nonatomic, assign) NSInteger zxtzNum;                    //每次加载的公告和研报数据个数

@end

static NSString * const CellID = @"StockID";  //定义cell的标识
static NSString * const AdviserNoDataCellID = @"AdviserNoDataCellID";
static NSString * const SectionID = @"StockHeadView";
static NSString * const SectionExpID = @"ExpHeadView";

@implementation StockDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
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

#pragma mark - 请求头部行情数据
- (void)getStockData {
    NSString *preStockCode = [StockPublic prefixStockCode:self.stockCode];
    [[DataProvide sharedStore] getShiShiDataWithURL:preStockCode success:^(NSArray *data) {
        if (data.count > 0) {
            QuoteModel *model = [data objectAtIndexCheck:0];
            self.preClose = model.closePrice;
            [self.headView updateUI:model];
            [self.minTimeVC.fiveViewController updateUIWithData:model];
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

- (id)initWithStockCode:(NSString *)stockCode withStockName:(NSString *)stockName {
    self = [super init];
    if (self) {
        self.stockCode = stockCode;
        self.stockName = stockName;
        self.sectionIndex = 0;
        [self getZiJinData];
        [self getStockData];
        NSInteger isFav = [[SearchStock shareManager] searStockIsFav:stockCode]; //1和2:是指数 1:是上证指数  2：深证指数  0:不是指数是普通股票
        
        if (isFav == 0) {
            //普通股票
            self.isExp = NO;
            self.isShowTop = NO;
            [self setNavTitle:[NSString stringWithFormat:@"%@ %@",self.stockName,self.stockCode]];
        }else{
            self.isExp = YES;
            self.isShowTop = YES;
            [self setNavTitle: [NSString stringWithFormat:@"%@",self.stockName]];
            if ([stockCode isEqualToString:@"1A0001"]) {
                self.expArr = [[SearchStock shareManager] searchSHExp:@"1"];
                NSMutableString * string = [[NSMutableString alloc] init];
                [self.expArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [string appendString:obj];
                }];
                NSString *urlStr = [string substringToIndex:[string length] - 1];
                [[DataProvide sharedStore] getShiShiDataWithURL:urlStr success:^(NSArray *data) {
                    if (data.count > 0) {
                        [self.expDataArr removeAllObjects];
                        [self.expDataArr addObjectsFromArray:data];
                    }
                } failure:^(NSString *error) {
                    [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"行情异常" duration:1.0f];
                }];
            }else if ([stockCode isEqualToString:@"399001"]){
                self.expArr = [[SearchStock shareManager] searchSZExp:@"2"];
                NSMutableString * string = [[NSMutableString alloc] init];
                [self.expArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [string appendString:obj];
                }];
                NSString *urlStr = [string substringToIndex:[string length] - 1];
                [[DataProvide sharedStore] getShiShiDataWithURL:urlStr success:^(NSArray *data) {
                    if (data.count > 0) {
                        [self.expDataArr removeAllObjects];
                        [self.expDataArr addObjectsFromArray:data];
                    }
                } failure:^(NSString *error) {
                    [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"行情异常" duration:1.0f];
                }];
            }else{
                self.isShowTop = NO;
            }
        }
        
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
    [self drawBackButton];
    // Do any additional setup after loading the view from its nib.
    _zxtzNum = 10;          //公告和研报每次加载的个数
    
    UIButton* someButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 21)];
    UIImage* image= [UIImage imageNamed:@"Navi_search"] ;
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:NO];
    [someButton addTarget:self action:@selector(navigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [self.navigationItem setRightBarButtonItem:someBarButtonItem];
    
    [self setupTableView];
    if (self.isShowTop) {
        
    }
    [self createBottomView];
    [self startTimer];
    
    self.KLineVC.view.frame = self.headView.KLineView.bounds;
    [self addChildViewController:self.KLineVC];
    [self.headView.KLineView addSubview:self.KLineVC.view];
    self.tmpVC = self.KLineVC;
    [self showKLine];
    
    //请求新闻的资讯数据
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StockCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdiviserNodataCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:AdviserNoDataCellID];
    [self.tableView registerClass:[StockHeadView class] forHeaderFooterViewReuseIdentifier:SectionID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExpHeadView class]) bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:SectionExpID];
    self.headView = [StockDetailHeadView headView];
    self.headView.delegate = self;
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
}



#pragma mark - 下拉刷新
- (void)headerRefresh {
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - 上拉加载
- (void)loadMoreData {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
}

#pragma mark - 添加底部视图
- (void)createBottomView {
    
    UIButton * delBtn = [Factory creatButtonWithTitle:@"  删除自选"
                                      backGroundColor:[UIColor whiteColor]
                                            textColor:UIColorFromRGB(0x7D7D7D)
                                             textSize:font750(30)];
    [delBtn setTitle:@"  添加自选" forState:UIControlStateSelected];
    [delBtn setImage:[UIImage imageNamed:@"deleteStock"] forState:UIControlStateNormal];
    [delBtn setImage:[UIImage imageNamed:@"addStock"] forState:UIControlStateSelected];
    delBtn.layer.borderColor = UIColorFromRGB(0x7D7D7D).CGColor;
    delBtn.layer.borderWidth= 1.0f;
    delBtn.layer.cornerRadius = 2.0f;

    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-49-64, self.view.width, 49)];
//    bottomView.backgroundColor = kWhiteColor;   //这句代码必须要加才能设置阴影效果
//    bottomView.layer.shadowColor = [UIColor grayColor].CGColor;//shadowColor阴影颜色
//    bottomView.layer.shadowOffset = CGSizeMake(-2,-2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    bottomView.layer.shadowOpacity = 0.3;//阴影透明度，默认0
//    bottomView.layer.shadowRadius = 2;//阴影半径，默认3
    [self.view addSubview:bottomView];
    
    [bottomView addSubview:delBtn];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@(Anno750(80)));
        make.bottom.equalTo(@(-Anno750(10)));
    }];
    delBtn.selected = ![[SearchStock shareManager] isExistInTable:self.stockCode];
    [delBtn addTarget:self action:@selector(addToSelectStock:) forControlEvents:UIControlEventTouchUpInside];
    
//    //顶部的横线
//    UIView *topLine = [[UIView alloc] init];
//    topLine.backgroundColor = UIColorFromRGB(0x7D7D7D);//[UIColor colorWithHexString:@"7D7D7D"];
//    [bottomView addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(bottomView.mas_width);
//        make.height.equalTo(@0.5);
//        make.top.equalTo(bottomView.mas_top);
//    }];
//    
//    //中间的竖线
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = UIColorFromRGB(0x7D7D7D);//[UIColor colorWithHexString:@"7D7D7D"];
//    [bottomView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@0.5);
//        make.top.equalTo(bottomView.mas_top).offset(10);
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
//        make.centerX.mas_equalTo(bottomView.mas_centerX);
//    }];
//    
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setTitleColor:UIColorFromRGB(0x7D7D7D) forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = kFont(15.0);
//    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [bottomView addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView.mas_top).offset(10);
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
//        make.left.equalTo(bottomView.mas_left).offset(40);
//        make.right.equalTo(lineView.mas_right).offset(-40);
//    }];
//    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.addStockBtn = rightBtn;
//    [rightBtn setTitleColor:UIColorFromRGB(0x7D7D7D) forState:UIControlStateNormal];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
//    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [rightBtn addTarget:self action:@selector(addToSelectStock:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:rightBtn];
//    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView.mas_top).offset(10);
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
//        make.left.equalTo(lineView.mas_left).offset(40);
//        make.right.equalTo(bottomView.mas_right).offset(-40);
//    }];
//    [self initAddButton];
//    [leftBtn setTitle:@"问股" forState:UIControlStateNormal];
//    [leftBtn setImage:[UIImage imageNamed:@"queStock"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(questionStock) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 发起问股
- (void)questionStock{
//    [CNNavigationBarHUD showSuccess:@"该功能暂时没有开通"];
}
#pragma mark - 加入自选
- (void)addToSelectStock:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([[SearchStock shareManager] isExistInTable:self.stockCode]) {
//        [StockPublic deleteStockFromServerWithStockCode:currentStockCode]; //向服务器删除自选
        [[SearchStock shareManager] deleteToTable:self.stockCode];
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"删除成功" duration:1];
    }else {
//        [StockPublic addStockFromServerWithStockCode:currentStockCode];  //向服务器添加自选
        [[SearchStock shareManager] insertToTable:self.stockCode];
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"添加成功" duration:1];
    }
}


#pragma mark - Table view data source
#pragma mark numberOfSectionsInTableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark heightForHeaderInSection
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}
#pragma mark viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isExp) {
        ExpHeadView *expHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionExpID];
        return expHead;
    }else{
        StockHeadView *stockHead = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionID];
        stockHead.delegate = self;
        return stockHead;
    }
}
#pragma mark numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isExp) {
        return self.expDataArr.count?self.expDataArr.count:1;
    }else{
        return 1;
    }
}
#pragma mark  heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}
#pragma mark cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isExp) {
        if (self.expDataArr.count == 0) {
            ExpNoDataCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpNoDataCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
            return cell;
        }
        
        StockCell  *cell = (StockCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
        if (cell == nil) {
            cell = [[StockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        }
        cell.model = [self.expDataArr objectAtIndexCheck:indexPath.row];
        return cell;
    }else{
        NSString * cellID = AdviserNoDataCellID;
        UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExp) {
        QuoteModel *model = [self.expDataArr objectAtIndexCheck:indexPath.row];
        StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
        [self.navigationController pushViewController:stockVC animated:YES];
    }
}

#pragma mark -StockNewsDelegate   改变
- (void)changeStockNewsStyleWith:(NSInteger)index {
    self.sectionIndex = index;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏右侧搜索按钮点击事件
-(void)navigationBarRightButton {
    FindStockVC *find = [[FindStockVC alloc] init];
    [self.navigationController  pushViewController:find animated:YES];
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
#pragma mark - 懒加载tableView并设置代理
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, self.view.height-49-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

- (NSMutableArray *)expDataArr{
    if (_expDataArr == nil) {
        _expDataArr = [[NSMutableArray alloc] init];
    }
    return _expDataArr;
}

- (NSMutableArray *)expArr{
    if (_expArr == nil) {
        _expArr = [[NSMutableArray alloc] init];
    }
    return _expArr;
}

- (NSMutableArray *)newsArray {
    if (_newsArray == nil) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    return _newsArray;
}

- (NSMutableArray *)noticeArray {
    if (_noticeArray == nil) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}

- (NSMutableArray *)yanBaoArray {
    if (_yanBaoArray == nil) {
        _yanBaoArray = [[NSMutableArray alloc] init];
    }
    return _yanBaoArray;
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
