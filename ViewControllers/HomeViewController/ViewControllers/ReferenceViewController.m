//
//  ReferenceViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ReferenceViewController.h"
#import "ReferenceListCell.h"
#import "ReferenceModel.h"
#import "WkWebViewController.h"
@interface ReferenceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<ReferenceModel *> * dataArray;
@property (nonatomic) int page;

@end

@implementation ReferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"核心内参"];
    [self drawBackButton];
    [self creatUI];
    [self getData];
    [self addRefreshView];
}
- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT -49 - 64) style:UITableViewStylePlain];
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
    if (self.dataArray[indexPath.row].Pic == nil || self.dataArray[indexPath.row].Pic.length == 0) {
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
    [cell updateWithReferenceModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WkWebViewController * webvc = [[WkWebViewController alloc]initWithTitle:self.dataArray[indexPath.row].Title content:
                                   self.dataArray[indexPath.row].Content
                                   time:self.dataArray[indexPath.row].CreateDate navTitle:@"核心内参"];
    [self.navigationController pushViewController:webvc animated:YES];
}
- (void)getData{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"UserId":[UserManager instance].userInfo.ID,
                              @"PageIndex":@(self.page),
                              @"PageSize":@10
                              };
    [[NetWorkManager manager] GET:Page_SoleList tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        self.page++;
        for (int i = 0; i<arr.count; i++) {
            ReferenceModel * model = [[ReferenceModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        if (arr.count<10) {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }else{
            [self.refreshFooter endRefreshing];
        }
    } error:^(JSError *error) {
        [self.refreshHeader endRefreshing];
        if (error.code.integerValue == 103) {
            if (self.dataArray.count == 0) {
                [self showNullViewWithMessage:@"暂无核心内参..."];
            }else{
                [self.refreshFooter endRefreshingWithNoMoreData];
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
            }
            
        }else{
            [self showNullViewWithMessage:@"网络好像有问题..."];
        }
    }];
}
- (void)updatedata{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)LoadMoreData{
    [self getData];
}

@end
