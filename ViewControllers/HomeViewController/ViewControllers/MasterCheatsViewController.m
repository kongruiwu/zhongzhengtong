//
//  MasterCheatsViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MasterCheatsViewController.h"
#import "ReferenceListCell.h"
#import "MasterModel.h"
#import "WkWebViewController.h"

@interface MasterCheatsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<MasterModel *> * dataArray;
@property (nonatomic) int page;

@end

@implementation MasterCheatsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"高手秘籍"];
    [self drawBackButton];
    [self creatUI];
    [self getData];
    [self addRefreshView];
}
- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT -Anno750(30)) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (void)addRefreshView{
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updatedata)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
    self.tabview.mj_footer = self.refreshFooter;
    self.tabview.mj_header = self.refreshHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray[indexPath.row].Newsthumb == nil || self.dataArray[indexPath.row].Newsthumb.length == 0) {
        return Anno750(150);
    }
    return Anno750(205);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ReferenceListCell";
    ReferenceListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ReferenceListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithMasterModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WkWebViewController * webvc = [[WkWebViewController alloc]initWithTitle:@"高手秘籍" content:
                                   self.dataArray[indexPath.row].Newscontent];
    [self.navigationController pushViewController:webvc animated:YES];
}
- (void)getData{
    NSDictionary * params = @{
                              @"Newstype":@11,
                              @"PageIndex":@(self.page),
                              @"PageSize":@10
                              };
    [[NetWorkManager manager] GET:Page_MasterList tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        if (self.dataArray.count != 0 && arr.count< 10) {
            if (arr.count == 0) {
                self.page -= 1;
            }
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
        }
        for (int i = 0; i<arr.count; i++) {
            MasterModel * model = [[MasterModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    } error:^(JSError *error) {
        if (self.page != 1) {
            self.page -- ;
        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}
- (void)updatedata{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)LoadMoreData{
    self.page++;
    [self getData];
}

@end
