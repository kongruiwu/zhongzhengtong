//
//  FSDetailTableViewController.m
//  YunZhangCaiJing
//
//  @Author: JopYin on 16/3/31.
//  Copyright © 2016年 JopYin. All rights reserved.
//

#import "FSDetailTableViewController.h"
#import "FSDetailTableViewCell.h"
#import "DataProvide.h"
#import "ConfigHeader.h"

@interface FSDetailTableViewController () {
    __weak IBOutlet UIView *tableHeadView;
}

@property (nonatomic, strong) NSTimer *minTimer;

@end

@implementation FSDetailTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startTimer];
    [self getFenBiData];
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
    _minTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getFenBiData) userInfo:nil repeats:YES];
}
#pragma mark - 关闭定时器
- (void)stopTimer {
    if ([_minTimer isValid])
    {
        [_minTimer setFireDate:[NSDate distantFuture]]; //关闭定时器
        _minTimer = nil;
    }
}

- (void)getFenBiData{
    if (self.stockCode == nil) {
        return;
    }
    [[DataProvide sharedStore] FenBiData:self.stockCode successBlock:^(id data) {
        if ([data isKindOfClass:[NSMutableArray class]]) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:data];
        }
        [self.tableView reloadData];
    } failure:^(NSString *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.scrollEnabled  = NO;
}

#pragma mark - 加载分时明细头部列表
- (UIView *)loadFSDetailHeadView {
    if (!tableHeadView) {
        [[NSBundle mainBundle] loadNibNamed:@"FSDetailHeadView" owner:self options:nil];
    }
    return tableHeadView;
}

#pragma mark - Table view data source
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self loadFSDetailHeadView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"FSDetail";
    FSDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FSDetailTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model.preClose = self.preClose;
    cell.model = [self.dataArray objectAtIndexCheck:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
