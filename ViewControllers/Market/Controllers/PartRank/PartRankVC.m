//
//  PartRankVC.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "PartRankVC.h"
#import "ShangZhenVC.h"
#import "HeaderOptionalView.h"
#import "CustomSlideViewController.h"

@interface PartRankVC ()<CustomSlideViewControllerDataSource,CustomSlideViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) ShangZhenVC *oneVC;

@property (nonatomic,strong) ShangZhenVC *twoVC;

@property (nonatomic,strong) ShangZhenVC *threeVC;

@property (nonatomic,strong) ShangZhenVC *fourVC;

@property (nonatomic, weak) CustomSlideViewController *slideViewController;
@property (nonatomic, weak) HeaderOptionalView *optionalView;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation PartRankVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)setOrderType:(NSString *)orderType {
    _orderType = orderType;
    self.oneVC.orderType = orderType;
    self.twoVC.orderType = orderType;
    self.threeVC.orderType = orderType;
    self.fourVC.orderType = orderType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self drawBackButton];
    [self setNavTitle:@"个股排行"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addChildViewController:self.oneVC];
    [self addChildViewController:self.twoVC];
    [self addChildViewController:self.threeVC];
    [self addChildViewController:self.fourVC];
    
    
    self.titles = @[@"上证",@"深证",@"中小板",@"创业板"].mutableCopy;
 // 设置子视图
     [self setUpViews];
}

 - (void)setUpViews {
     if (self.titles.count == 0) {
         return ;
     }
     
     for (int i = 0; i < self.titles.count; i++) {
         if (i == 0) {
             [self.controllers addObject:self.oneVC];
         } else if (i == 1) {
             [self.controllers addObject:self.twoVC];
         
         } else if (i == 2) {
             [self.controllers addObject:self.threeVC];
         
         } else {
             [self.controllers addObject:self.fourVC];
         
         }
         self.optionalView.titles = self.titles.copy;
         WEAKSELF();
         self.optionalView.homeHeaderOptionalViewItemClickHandle = ^(HeaderOptionalView *view, NSString *currentTitle, NSInteger currentIndex) {
             weakSelf.slideViewController.seletedIndex = currentIndex;
         };
     }
     [self.slideViewController reloadData];
 }
 
 - (CustomSlideViewController *)slideViewController {
     if (_slideViewController == nil) {
         CustomSlideViewController *slideVC = [[CustomSlideViewController alloc] init];
         [slideVC willMoveToParentViewController:self];
         [self addChildViewController:slideVC];
         [self.view addSubview:slideVC.view];
         slideVC.view.frame = CGRectMake(0, self.optionalView.height, UI_WIDTH, UI_HEGIHT - self.optionalView.height);
         slideVC.dataSource = self;
         slideVC.delgate = self;
         _slideViewController = slideVC;
     }
     return _slideViewController;
 }
 
 
 #pragma mark - 主页头部视图
 - (HeaderOptionalView *)optionalView {
     if (_optionalView == nil) {
         HeaderOptionalView *optional = [[HeaderOptionalView alloc] init];
         optional.frame = CGRectMake(0, 0, UI_WIDTH, 40);
         [self.view addSubview:optional];
         _optionalView = optional;
         optional.backgroundColor = [UIColor whiteColor];
     }
     return _optionalView;
 }
 
 #pragma mark - <CustomSlideViewControllerDataSource>
 - (NSInteger)numberOfChildViewControllersInSlideViewController:(CustomSlideViewController *)slideViewController
 {
     return self.controllers.count;
 }
 - (UIViewController *)slideViewController:(CustomSlideViewController *)slideViewController viewControllerAtIndex:(NSInteger)index {
     return self.controllers[index];
 }
 
 - (void)customSlideViewController:(CustomSlideViewController *)slideViewController slideOffset:(CGPoint)slideOffset {
     self.optionalView.contentOffset = slideOffset;
 }
 
 
 - (NSMutableArray *)controllers {
     if (!_controllers) {
         _controllers = [NSMutableArray array];
     }
     return _controllers;
 }
 
 - (NSMutableArray *)titles {
     if (!_titles) {
         _titles = [NSMutableArray array];
     }
     return _titles;
 }

#pragma mark - CNNavigationBarDelegate
- (void)navigationBarLeftButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (ShangZhenVC *)oneVC {
    if (!_oneVC) {
        _oneVC = [[ShangZhenVC alloc] init];
        self.oneVC.stockType = 1;
    }
    return _oneVC;
}

- (ShangZhenVC *)twoVC {
    if (!_twoVC) {
        _twoVC = [[ShangZhenVC alloc] init];
        _twoVC.stockType = 4;
    }
    return _twoVC;
}

- (ShangZhenVC *)threeVC {
    if (!_threeVC) {
        _threeVC = [[ShangZhenVC alloc] init];
        _threeVC.stockType = 15;
    }
    return _threeVC;
}

- (ShangZhenVC *)fourVC {
    if (!_fourVC) {
        _fourVC = [[ShangZhenVC alloc] init];
        _fourVC.stockType = 16;
    }
    return _fourVC;
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
