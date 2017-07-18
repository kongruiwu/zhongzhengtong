//
//  HotNewsViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotNewsViewController.h"
#import "HotNewsCell.h"
#import "HotNewsModel.h"
@interface HotNewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<HotNewsModel *> * dataArray;
@property (nonatomic) int page;

@end

@implementation HotNewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    [self setNavTitle:@"热点追踪"];
    [self creatUI];
    [self getData];
    [self addRefreshView];
}
- (void)addRefreshView{
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updatedata)];
    self.refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMoreData)];
    self.tabview.mj_footer = self.refreshFooter;
    self.tabview.mj_header = self.refreshHeader;
}

- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT -49 - 64) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [Factory getSize:self.dataArray[indexPath.row].NEWSTITLE maxSize:CGSizeMake(Anno750(750 - 96), 99999) font:[UIFont systemFontOfSize:Anno750(28)]];
    return Anno750(96)+ size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"HotNewsCell";
    HotNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HotNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 0) {
        [cell updateFristCell:YES];
    }else{
        [cell updateFristCell:NO];
    }
    [cell updateWithHotNewsModel:self.dataArray[indexPath.row]];
    return cell;
}

- (void)getData{
    [SVProgressHUD show];
    NSDictionary * params = @{
                            @"PageIndex":@(self.page),
                            @"PageSize":@10
                              };
    [[NetWorkManager manager] GET:Page_HotNews tokenParams:params complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        NSArray * arr = dic[@"List"];
        self.page ++;
        for (int i = 0; i<arr.count; i++) {
            HotNewsModel * model = [[HotNewsModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    } error:^(JSError *error) {
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        if (error.code.integerValue == 103) {
            if (self.dataArray.count == 0) {
                [self showNullViewWithMessage:@"暂无热点信息..."];
            }else{
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
