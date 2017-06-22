//
//  MarketViewController.m
//  NewRenWang
//
//  Created by JopYin on 2017/1/10.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import "MarketViewController.h"
#import "OptionViewController.h"
#import "RankViewController.h"
#import "FindStockVC.h"
#import "ConfigHeader.h"

typedef NS_ENUM(NSInteger,QuotationType) {
    QuotationType_Optional ,
    QuotationType_Quote
};

@interface MarketViewController ()

@property (nonatomic, strong) OptionViewController *optionalVC;   // 自选股的控制器

@property (nonatomic, strong) RankViewController *quoteVC;      // 行情控制器

@property (nonatomic, strong) UIViewController *currentVC;   // 界面显示的控制器（临时保存作用）

@property (nonatomic, strong) UISegmentedControl *segmentBtn; // 自选和行情切换的按钮

@end

@implementation MarketViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =NO;
}

- (void)choose:(id)sender {
    NSInteger selectedSegment = _segmentBtn.selectedSegmentIndex;
    if ((self.currentVC == self.optionalVC && selectedSegment == QuotationType_Optional) || (self.currentVC == self.quoteVC && selectedSegment == QuotationType_Quote)) {
        return;
    }
    if (selectedSegment == QuotationType_Optional) {    // 自选股
        [self replaceController:self.currentVC newController:self.optionalVC];
    } else if(selectedSegment == QuotationType_Quote) { // 行情
        
        [self replaceController:self.currentVC newController:self.quoteVC];
    }
}
#pragma mark -oldController 即将在界面消失的控制器  newController 即将显示在界面的控制器
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController {
    [self addChildViewController:newController]; //此方法之前系统自动调用 [newController willMoveToParentViewController:self];
    __weak id weakSelf = self;
    [oldController willMoveToParentViewController:nil];
    [self transitionFromViewController:oldController toViewController:newController duration:0.0001f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:weakSelf];
            [oldController removeFromParentViewController]; //此方法调用之后系统自动调用[oldController didMoveToParentViewController:self];
            _currentVC = newController;
        } else {
            _currentVC = oldController;
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    
    CGFloat statueHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    NSArray * segmentArray = @[@"自选",@"行情"];
    _segmentBtn = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentBtn.frame = CGRectMake((UI_WIDTH-120)/2, (64 - 25)/2+statueHeight, 120, 25);
    _segmentBtn.backgroundColor = [UIColor whiteColor];
    _segmentBtn.layer.cornerRadius = 5.0f;
    _segmentBtn.tintColor = MainRed;//[UIColor colorWithHexString:@"#114068"];
    [_segmentBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];  //选中segment的字体颜色
    [_segmentBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:KTColor_lightGray} forState:UIControlStateNormal];
    _segmentBtn.selectedSegmentIndex = 0;
    [_segmentBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentBtn;
    
    UIButton* someButton= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 21)];
    UIImage* image= [UIImage imageNamed:@"Navi_search"] ;
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:NO];
    [someButton addTarget:self action:@selector(navigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    [self.navigationItem setRightBarButtonItem:someBarButtonItem];
    
    
    [self addChildViewController:self.optionalVC];
    self.currentVC = self.optionalVC;
    [self.view addSubview:self.optionalVC.view];
}

#pragma mark - CNNavigationBarDelegate
- (void)navigationBarRightButton{
//    if (![NetworkRequestTools isExistenceNetWork]) {
//        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNetFailure text:@"网络不可用" duration:2.0f];
//        return;
//    }
    FindStockVC *find = [[FindStockVC alloc] init];
    [self.navigationController  pushViewController:find animated:YES];
}

#pragma mark - 懒加载控制器 
- (OptionViewController *)optionalVC {
    if (_optionalVC == nil) {
        _optionalVC = [[OptionViewController alloc] init];
        _optionalVC.view.frame = self.view.bounds;
    }
    return _optionalVC;
}
- (RankViewController *)quoteVC {
    if (_quoteVC == nil) {
        _quoteVC = [[RankViewController alloc] init];
        _quoteVC.view.frame = self.view.bounds;
    }
    return _quoteVC;
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
