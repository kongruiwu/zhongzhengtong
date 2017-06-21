//
//  QuotationViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "QuotationViewController.h"
#import "QuotationListCell.h"
#import "QuotationModel.h"
@interface QuotationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation QuotationViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"牛股来了"];
    [self creatUI];
    [self getData];
    [self addRefreshHeader];
}
- (void)addRefreshHeader{
    self.refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.tabview.mj_header = self.refreshHeader;
}
- (void)creatUI{
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64 - 49) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuotationModel * model = self.dataArray[indexPath.row];
    if (model.isOpen) {
        CGSize size = [Factory getSize:model.selectedRemark maxSize:CGSizeMake(Anno750(750 - 128), 99999) font:[UIFont systemFontOfSize:font750(24)]];
        return Anno750(240 - 24)+ size.height;
    }
    return Anno750(240);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"QuotationListCell";
    QuotationListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[QuotationListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithQuotationModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuotationModel * model = self.dataArray[indexPath.row];
    model.isOpen = !model.isOpen;
    [self.tabview reloadData];
}
- (void)getData{
    [SVProgressHUD show];
    [self.dataArray removeAllObjects];
    NSDictionary * params = @{@"UserId":[UserManager instance].userInfo.ID,
                              @"VersionType":@3};
    [[NetWorkManager manager] GET:Page_Quotation tokenParams:params complete:^(id result) {
        self.nullView.hidden = YES;
        NSArray * arr = (NSArray *)result;
        for (int i = 0; i<arr.count; i++) {
            QuotationModel * model = [[QuotationModel alloc]initWithDictionary:arr[i]];
            [self.dataArray addObject:model];
        }
        [self.tabview reloadData];
    } error:^(JSError *error) {
        if (error.code.integerValue == 103) {
            [self showNullViewWithMessage:@"暂时没有数据..."];
        }else{
            [self showNullViewWithMessage:@"网络请求超时..."];
        }
    }];
}

@end
