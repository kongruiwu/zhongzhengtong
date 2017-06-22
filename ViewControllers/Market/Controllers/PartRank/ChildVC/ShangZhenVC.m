//
//  ShangZhenVC.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "ShangZhenVC.h"
#import "RankHeadView.h"
#import "StockCell.h"
#import "DataProvide.h"
#import "StockDetailVC.h"
#import "ConfigHeader.h"

@interface ShangZhenVC ()<UITableViewDelegate,UITableViewDataSource,RankHeadViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray *stockArray;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign)NSInteger startIndex;

@end

static NSString * const CellID = @"StockID";  //定义cell的标识

@implementation ShangZhenVC

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self startTimer];
//    [self getStockData];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self stopTimer];
//}
//
//#pragma mark - 开启定时器
//- (void)startTimer{
//    if ([_timer isValid])
//    {
//        [_timer invalidate];
//    }
//    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getStockData) userInfo:nil repeats:YES];
//}
//#pragma mark - 关闭定时器
//- (void)stopTimer {
//    if ([_timer isValid])
//    {
//        [_timer setFireDate:[NSDate distantFuture]]; //关闭定时器
//        _timer = nil;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
    [self setUpRefresh];
    [self.tableView.mj_header beginRefreshing];
}

-(void)setUpRefresh {
    //下拉刷新
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}
#pragma mark - 上拉刷新
-(void)loadNew {
    [self.tableView.mj_footer endRefreshing];
    self.startIndex = 0;
    NSString *string = [NSString stringWithFormat:@"stocktype=%ld&OrderKey=5014&OrderType=%@&StartIndex=%ld&PageSize=20",(long)self.stockType,self.orderType,self.startIndex];
    
    [[DataProvide sharedStore] getStockTypeDataWithParameters:string successBlock:^(id data) {
        [self.stockArray removeAllObjects];
        [self.stockArray addObjectsFromArray:data];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSString *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 下拉加载更多
-(void)loadMore {
    [self.tableView.mj_header endRefreshing];
    if (self.stockArray.count%20 != 0) {
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }else{
        self.startIndex += 20;
        NSString *string = [NSString stringWithFormat:@"stocktype=%ld&OrderKey=5014&OrderType=%@&StartIndex=%ld&PageSize=20",(long)self.stockType,self.orderType,(long)self.startIndex];
        [[DataProvide sharedStore] getStockTypeDataWithParameters:string successBlock:^(id data) {
            [self.stockArray addObjectsFromArray:data];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        } failure:^(NSString *error) {
            [self.tableView.mj_footer endRefreshing];
            self.startIndex -= 20;
        }];
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView {
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64 - 40) style:UITableViewStylePlain];
    self.tableView = tableV;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StockCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    
    RankHeadView *headView = [RankHeadView headView];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.stockArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[StockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.stockArray objectAtIndexCheck:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        return;
//    }
    
    QuoteModel *model = [self.stockArray objectAtIndexCheck:indexPath.row];
    StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
    [self.navigationController pushViewController:stockVC animated:YES];
}


- (void)rankHeadView:(RankHeadView *)rankHeadView changeRate:(BOOL)isFall{
    if (isFall) {
        self.orderType = @"0";
    }else{
        self.orderType = @"1";
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 懒加载数据数组 操盘精灵数据
-(NSMutableArray *)stockArray {
    if (_stockArray == nil) {
        _stockArray = [NSMutableArray array];
    }
    return _stockArray;
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
