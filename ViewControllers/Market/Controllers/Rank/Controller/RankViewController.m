//
//  RankViewController.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/13.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "RankViewController.h"
#import "HeadView.h"
#import "StockCell.h"
#import "SectionHeadView.h"
#import "DataProvide.h"
#import "PartRankVC.h"
#import "StockDetailVC.h"

@interface RankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *rankTableView;

@property (nonatomic,strong)NSMutableArray *stockExpArr; //大盘数据
@property (nonatomic,strong)NSMutableArray *riseArr;     //涨幅数据
@property (nonatomic,strong)NSMutableArray *fallArr;     //跌幅数据

@property (nonatomic,strong)HeadView *headView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) PartRankVC *partVC;

@end

static NSString * const CellID = @"StockID";  //定义cell的标识

@implementation RankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimer];
    [self getStockData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopTimer];
}

#pragma mark - 开启定时器
- (void)startTimer{
    if ([_timer isValid])
    {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getStockData) userInfo:nil repeats:YES];
}
#pragma mark - 关闭定时器
- (void)stopTimer {
    if ([_timer isValid])
    {
        [_timer setFireDate:[NSDate distantFuture]]; //关闭定时器
        _timer = nil;
    }
}

- (void)getStockData {
    [self getStockExp];
    [self getRise];
    [self getFall];
}

#pragma mark - 获取大盘指数的数据
- (void)getStockExp{
    NSString *ExpURL =@"sh1A0001,sz399001,sz399005,sz399006";
    [[DataProvide sharedStore] getShiShiDataWithURL:ExpURL success:^(NSArray *data) {
        if (data.count > 0) {
            [self.stockExpArr removeAllObjects];
            [self.stockExpArr addObjectsFromArray:data];
            self.headView.dataArr = self.stockExpArr;
        }
        [self.rankTableView reloadData];
    } failure:^(NSString *error) {
        [self.rankTableView reloadData];
    }];
    
}
#pragma mark - 获取领涨个股数据
- (void)getRise{
    NSString *riseURL = @"stocktype=13&OrderKey=5014&OrderType=1&StartIndex=0&PageSize=10";
    [[DataProvide sharedStore] getStockTypeDataWithParameters:riseURL successBlock:^(NSArray* data) {
        if (data.count > 0) {
            [self.riseArr removeAllObjects];
            [self.riseArr addObjectsFromArray:data];
        }
        [self.rankTableView reloadData];
    } failure:^(NSString *error) {
        [self.rankTableView reloadData];
    }];
}
#pragma mark - 获取领跌个股的数据
- (void)getFall{
    NSString *riseURL = @"stocktype=13&OrderKey=5014&OrderType=0&StartIndex=0&PageSize=10";
    [[DataProvide sharedStore] getStockTypeDataWithParameters:riseURL successBlock:^(NSArray* data) {
        if (data.count > 0) {
            [self.fallArr removeAllObjects];
            [self.fallArr addObjectsFromArray:data];
        }
        [self.rankTableView reloadData];
    } failure:^(NSString *error) {
        [self.rankTableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    WEAKSELF();
    self.rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.rankTableView registerNib:[UINib nibWithNibName:NSStringFromClass([StockCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    self.headView = [HeadView headView];
    self.rankTableView.tableHeaderView = self.headView;
    self.headView.SHBlock = ^{
        //上证指数点击事件
        NSLog(@"SH");
        [weakSelf pushStockDetail:0];
        
    };
    self.headView.SZBlock = ^{
        //深证指数点击事件
        NSLog(@"SZ");
        [weakSelf pushStockDetail:1];
    };
    self.headView.ZXBlock = ^{
        //中小板指点击事件
        NSLog(@"ZX");
        [weakSelf pushStockDetail:2];
    };
    self.headView.CYBlock = ^{
        //创业板指点击事件
        NSLog(@"CY");
        [weakSelf pushStockDetail:3];
    };
}

#pragma mark - TableViewDegelate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionHeadView *sectionHead = [SectionHeadView sectionHeadView];
    WEAKSELF();
    if (section == 0) {
        sectionHead.line.backgroundColor = [UIColor colorWithHexString:@"#C90011"];
        sectionHead.title.text = @"领涨个股";
        sectionHead.moreBlock = ^{
            
            weakSelf.partVC.orderType = @"1";   //涨幅
            [self.navigationController  pushViewController:weakSelf.partVC animated:YES];
        };
    }else {
        sectionHead.line.backgroundColor = [UIColor colorWithHexString:@"#19BD9C"];
        sectionHead.title.text = @"领跌个股";
        sectionHead.moreBlock = ^{
            weakSelf.partVC.orderType = @"0";   //涨幅
            [self.navigationController  pushViewController:weakSelf.partVC animated:YES];
        };
    }
    return sectionHead;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StockCell  *cell = (StockCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[StockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.model = [self.riseArr objectAtIndexCheck:indexPath.row];
    }else {
        cell.model = [self.fallArr objectAtIndexCheck:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        //没有网络
//        return;
//    }
    
    QuoteModel *model = [[QuoteModel alloc] init];
    if (indexPath.section == 0) {
        model = [self.riseArr objectAtIndexCheck:indexPath.row];
    }else{
        model = [self.fallArr objectAtIndexCheck:indexPath.row];
    }
    StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
    [self.navigationController pushViewController:stockVC animated:YES];
}


- (void)pushStockDetail:(NSInteger)index{
    QuoteModel *model = [self.stockExpArr objectAtIndexCheck:index];
    StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
    [self.navigationController pushViewController:stockVC animated:YES];
}

- (PartRankVC *)partVC {
    if (!_partVC) {
        _partVC = [[PartRankVC alloc] init];
    }
    return _partVC;
}

#pragma mark - 懒加载 存放涨幅的数组
- (NSMutableArray *)stockExpArr {
    if (!_stockExpArr) {
        _stockExpArr = [NSMutableArray array];
    }
    return _stockExpArr;
}
- (NSMutableArray *)riseArr {
    if (!_riseArr) {
        _riseArr = [NSMutableArray array];
    }
    return _riseArr;
}
- (NSMutableArray *)fallArr {
    if (!_fallArr) {
        _fallArr = [NSMutableArray array];
    }
    return _fallArr;
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
