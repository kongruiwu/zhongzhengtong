//
//  OptionViewController.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/11.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "OptionViewController.h"
#import "StockCell.h"
#import "InvestNoDataCell.h"
#import "StockModel.h"
#import "SearchStock.h"
#import "DataProvide.h"
#import "StockPublic.h"
#import "FindStockVC.h"
#import "StockDetailVC.h"
#import "ServerStockModel.h"

@interface OptionViewController ()<UITableViewDataSource,UITableViewDelegate,InvestNoDelegate>

@property (weak, nonatomic) IBOutlet UILabel *SH_name;
@property (weak, nonatomic) IBOutlet UILabel *SH_rate;
@property (weak, nonatomic) IBOutlet UILabel *SZ_name;
@property (weak, nonatomic) IBOutlet UILabel *SZ_rate;
@property (weak, nonatomic) IBOutlet UILabel *CY_name;
@property (weak, nonatomic) IBOutlet UILabel *CY_rate;
@property (weak, nonatomic) IBOutlet UIButton *rateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *favStockArr; //存放自选股的数组：里面是StockMode: stockCode/stockName
@property (nonatomic, strong) NSMutableArray *stockExpArr; //存放底部的大盘指数 ：上证指数、深证指数、创业板
@property (nonatomic, strong) NSMutableArray *resultData;  //请求行情数据
@property (nonatomic, strong) NSTimer *timer;

@end

static NSString * const CellID = @"StockID";  //定义cell的标识
static NSString * const NoCell = @"NoCell";  //定义cell的标识

@implementation OptionViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestStockList];
    self.favStockArr =[[SearchStock shareManager] allFavStock];
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

#pragma mark - 同步自选股列表
- (void)requestStockList{
    NSDictionary *dic = @{
                          @"PageIndex":@"1",
                          @"PageSize":@"100",
                          @"UserId":[UserManager instance].userInfo.ID
                          };
    [[NetWorkManager manager] GET:Page_StockList tokenParams:dic complete:^(id result) {
        [[SearchStock shareManager] deleteAllStock];
        if ([result isKindOfClass:[NSArray class]]) {
            [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ServerStockModel *model = [[ServerStockModel alloc] initWithDictionary:obj];
                BOOL isFavStock = [[SearchStock shareManager] isExistInTable:model.StockCode];
                if (!isFavStock) {
                    [[SearchStock shareManager] insertToTable:model.StockCode];
                }
            }];
        }
        self.favStockArr =[[SearchStock shareManager] allFavStock];     //取出自选股表中的股票
        [self startTimer];
    } error:^(JSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StockCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InvestNoDataCell class]) bundle:nil] forCellReuseIdentifier:NoCell];
}

- (void)getStockData {
    NSString *Url = @"sh1A0001,sz399001,sz399006";
    [[DataProvide sharedStore] getShiShiDataWithURL:Url success:^(NSArray *data) {
        if (data.count > 0) {
            [self.stockExpArr removeAllObjects];
            [self.stockExpArr addObjectsFromArray:data];
            [self updateStockExp];
        }
    } failure:^(NSString *error) {
    }];

    
    if (self.favStockArr.count == 0) {
        [self.tableView reloadData];
        [self stopTimer];
    }else {
        NSMutableString *selectStr = [[NSMutableString alloc] init];
        for (StockModel *model in self.favStockArr) {
            NSString *tmpStr = [StockPublic prefixStockCode:model.stockCode];
            [selectStr appendString:[NSString stringWithFormat:@"%@,",tmpStr]];
        }
        NSString *URLStr = [selectStr substringWithRange:NSMakeRange(0, selectStr.length-1)];
        [[DataProvide sharedStore] getShiShiDataWithURL:URLStr success:^(NSArray *data) {
            if (data.count > 0) {
                [self.resultData removeAllObjects];
                [self.resultData addObjectsFromArray:data];
            }
            [self.tableView reloadData];
        } failure:^(NSString *error) {
        }];
    }
}

#pragma mark - 更新大盘指数 给大盘赋值和
- (void)updateStockExp {
    [self.stockExpArr enumerateObjectsUsingBlock:^(QuoteModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            self.SH_rate.text = obj.changeRate;
            if ([obj.changeRate floatValue] >= 0) {
                self.SH_name.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
                self.SH_rate.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
            }else{
                self.SH_name.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
                self.SH_rate.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
            }
        }else if (idx == 1){
            self.SZ_rate.text = obj.changeRate;
            if ([obj.changeRate floatValue] >= 0) {
                self.SZ_name.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
                self.SZ_rate.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
            }else{
                self.SZ_name.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
                self.SZ_rate.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
            }
        }else if (idx == 2){
            self.CY_rate.text = obj.changeRate;
            if ([obj.changeRate floatValue] >= 0) {
                self.CY_name.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
                self.CY_rate.textColor = UIColorFromRGB(0xC90011);      //[UIColor colorWithHexString:@"#C90011"];
            }else{
                self.CY_name.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
                self.CY_rate.textColor = UIColorFromRGB(0x19BD9C);      //[UIColor colorWithHexString:@"#19BD9C"];
            }
        }
    }];
}

#pragma mark - 自选改变涨跌幅顺序
- (IBAction)rate:(id)sender {
    NSLog(@"ss");
}

#pragma mark - UITableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.favStockArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.favStockArr.count) {
        InvestNoDataCell *noCell = [tableView dequeueReusableCellWithIdentifier:NoCell];
        noCell.delegate = self;
        noCell.selectionStyle = UITableViewCellAccessoryNone;
        return noCell;
    }
    StockCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[StockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.model = [self.resultData objectAtIndexCheck:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        [CNNavigationBarHUD showError:@"没有网络"];
//        return;
//    }
    if (indexPath.row != self.favStockArr.count) {
        QuoteModel *model = [self.resultData objectAtIndexCheck:indexPath.row];
        StockDetailVC *stockVC = [[StockDetailVC alloc] initWithStockCode:model.stockCode withStockName:model.stockName];
        [self.navigationController pushViewController:stockVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        StockModel *model = [self.favStockArr objectAtIndexCheck:indexPath.row];
        [[SearchStock shareManager] deleteToTable:model.stockCode];
        
        [StockPublic deleteStockFromServerWithStockCode:model.stockCode];   //通知服务器删除自选股
        self.favStockArr =[[SearchStock shareManager] allFavStock];
        [self startTimer];
        [self getStockData];
    }
}

#pragma mark - InvestNoDelegate
-(void)pushFindStockVC{
    FindStockVC *find = [[FindStockVC alloc] init];
    [self.navigationController  pushViewController:find animated:YES];
}

#pragma mark - 懒加载
- (NSMutableArray *)resultData {
    if (!_resultData) {
        _resultData = [NSMutableArray array];
    }
    return _resultData;
}

#pragma mark - 懒加载
- (NSMutableArray *)stockExpArr {
    if (!_stockExpArr) {
        _stockExpArr = [NSMutableArray array];
    }
    return _stockExpArr;
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
