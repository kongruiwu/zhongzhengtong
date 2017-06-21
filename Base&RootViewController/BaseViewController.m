//
//  BaseViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = MainRed;
    [self creatNullView];
    // Do any additional setup after loading the view.
}
- (void)creatNullView{
    self.nullView = [[NothingView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    [self.view addSubview:self.nullView];
    self.nullView.hidden = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getData)];
    [self.nullView addGestureRecognizer:tap];
}
- (void)getData{
    
}
- (void)showNullViewWithMessage:(NSString *)message{
    self.nullView.hidden = NO;
    [self.view bringSubviewToFront:self.nullView];
    self.nullView.message =  message;
}
- (void)doBack{
    switch (self.backType) {
        case SelectorBackTypeDismiss:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case SelectorBackTypePopBack:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case SelectorBackTypePoptoRoot:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
- (void)navSetting{
    
    self.navigationController.navigationBar.barTintColor = MainRed;
}
- (void)RefreshSetting{
    [self.refreshHeader setTitle:@"继续下拉" forState:MJRefreshStateIdle];
    [self.refreshHeader setTitle:@"松开就刷新" forState:MJRefreshStatePulling];
    [self.refreshHeader setTitle:@"刷新中 ..." forState:MJRefreshStateRefreshing];
    self.refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    
    [self.refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [self.refreshFooter setTitle:@"就是要加载" forState:MJRefreshStateWillRefresh];
    [self.refreshFooter setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [self.refreshFooter setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
}

- (void)setNavTitle:(NSString *)title{
    UILabel * titleLabel = [Factory creatLabelWithText:title
                                               fontValue:font750(34)
                                               textColor:[UIColor whiteColor]
                                           textAlignment:NSTextAlignmentCenter];
    titleLabel.frame = CGRectMake(0, 0, 100, 40);
    self.navigationItem.titleView = titleLabel;
    
}
- (void)drawMainLeftNavBarItem{
    UIImage * image = [[UIImage imageNamed:@"navbarBack_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(navLeftClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)navLeftClick{
    
}
- (void)drawBackButton{
    UIImage * image = [[UIImage imageNamed:@"navbarBack_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end
