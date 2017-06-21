//
//  HomeViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeViewController.h"
#import <SDCycleScrollView.h>
#import "HomeListCell.h"
#import "HomeBtnModel.h"
#import "HotNewsViewController.h"
#import "ReferenceViewController.h"
#import "ExpertViewController.h"
#import "BannerModel.h"
#import "BannerDetailViewController.h"
#import "LoginViewController.h"
#import "MasterCheatsViewController.h"



@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,HomeListDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) SDCycleScrollView * bannerViw;

@property (nonatomic, strong) NSMutableArray * HomeModels;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSMutableArray<BannerModel *> * banners;


@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UserManager instance].isLog) {
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [self presentViewController:nav animated:NO completion:nil];
    }
    [self creatUI];
    [self drawLeftNavButton];
    [self getBannerData];
}
- (void)drawLeftNavButton{
    UIImage * image = [[UIImage imageNamed:@"left_nav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImage * rightImg = [[UIImage imageNamed:@"right_nav"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)creatUI{
    self.banners = [NSMutableArray new];
    self.HomeModels = [NSMutableArray new];
    self.titles = @[@"牛股来了",@"热点追踪",@"核心内参",@"高手秘籍",@"专家诊股",@"我的APP"];
    NSArray * colors = @[HomeBtn1,HomeBtn2,HomeBtn3,HomeBtn4,HomeBtn5,HomeBtn6];
    for (int i = 0; i<self.titles.count; i++) {
        HomeBtnModel * model = [[HomeBtnModel alloc]init];
        model.title = self.titles[i];
        model.imgName = [NSString stringWithFormat:@"btn%d",i+1];
        model.color = colors[i];
        [self.HomeModels addObject:model];
    }
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Anno750(30);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(365);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.bannerViw = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(365)) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    self.bannerViw.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerViw.autoScrollTimeInterval = 3.0f;
    return self.bannerViw;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.HomeModels.count/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(240);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"HomeListCell";
    HomeListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[HomeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithFristModel:self.HomeModels[indexPath.row * 2] secodModel:self.HomeModels[indexPath.row * 2 +1]];
    cell.delegate =self;
    return cell;
}
- (void)pushToNextvc:(UIButton *)btn{
    NSString * title = btn.titleLabel.text;
    NSInteger index = [self.titles indexOfObject:title];
    switch (index) {
        case 0:
            [self.tabBarController setSelectedIndex:2];
            break;
        case 1:
        {
            HotNewsViewController * hotvc = [HotNewsViewController new];
            [self.navigationController pushViewController:hotvc animated:YES];
        }
            break;
        case 2:
        {
            [self.navigationController pushViewController:[ReferenceViewController new] animated:YES];
        }
            break;
        case 3:
            [self.navigationController pushViewController:[MasterCheatsViewController new] animated:YES];
            break;
        case 4:
        {
            [self.navigationController pushViewController:[ExpertViewController new] animated:YES];
        }
            break;
        case 5:
        {
            [self.tabBarController setSelectedIndex:3];
        }
            break;
        default:
            break;
    }
}

- (void)getBannerData{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"TopCount": @5
                              };
    [[NetWorkManager manager] GET:Page_Banner tokenParams:params complete:^(id result) {
        NSArray * arr =  (NSArray *)result;
        NSMutableArray * imgs = [NSMutableArray new];
        NSMutableArray * titles = [NSMutableArray new];
        for (int i = 0; i<arr.count; i++) {
            BannerModel * model = [[BannerModel alloc]initWithDictionary:arr[i]];
            [self.banners addObject:model];
            [titles addObject:model.Title];
            NSMutableString * imgurl = [NSMutableString stringWithFormat:@"%@%@",BaseImgUrl,[Factory encodeUrlString:model.Posterimg]];
            [imgurl stringByReplacingOccurrencesOfString:@"%5C" withString:@"/"];
            [imgs addObject:[NSString stringWithFormat:@"%@",imgurl]];
        }
        self.bannerViw.imageURLStringsGroup = imgs;
        self.bannerViw.titlesGroup = titles;
        [SVProgressHUD dismiss];
    } error:^(JSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerDetailViewController * vc = [BannerDetailViewController new];
    vc.bannerID = self.banners[index].Id;
    vc.bannerTitle = self.banners[index].Title;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
