//
//  ExpertViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ExpertViewController.h"
#import "ExpertListCell.h"
#import "FeedbackViewController.h"
#import "QuestionModel.h"
@interface ExpertViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<QuestionModel *> * dataArray;
@property (nonatomic, strong) UIButton * questBtn;
@property (nonatomic) int page;

@end

@implementation ExpertViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"专家诊股"];
    if (self.isMine) {
        [self setNavTitle:@"我的提问"];
    }
    [self drawBackButton];
    [self creatUI];
    [self getData];
    [self addRefreshView];
    if (!self.isMine) {
        [self creatQuestionButton];
        [self drawRightButton];
    }
    
}

- (void)drawRightButton{
    UIBarButtonItem * rightBaritem = [[UIBarButtonItem alloc]initWithTitle:@"我的提问" style:UIBarButtonItemStylePlain target:self action:@selector(checkMineQuestion)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
}
- (void)checkMineQuestion{
    ExpertViewController * vc = [[ExpertViewController alloc]init];
    vc.isMine = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 49) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (void)creatQuestionButton{
    self.questBtn = [Factory creatButtonWithNormalImage:@"question" selectImage:nil];
    [self.questBtn addTarget:self action:@selector(PushToUserQuestionViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.questBtn];
    [self.questBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-Anno750(150)));
        make.right.equalTo(@(-Anno750(50)));
        make.width.equalTo(@(Anno750(100)));
        make.height.equalTo(@(Anno750(100)));
    }];
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
    if (self.dataArray[indexPath.row].Answer == nil || self.dataArray[indexPath.row].Answer.length == 0) {
        return Anno750(220);
    }
    if (self.dataArray[indexPath.row].isOpen) {
        CGSize size = [Factory getSize:self.dataArray[indexPath.row].Answer maxSize:CGSizeMake(Anno750(750 - 198), 999999) font:[UIFont systemFontOfSize:font750(28)]];
        return Anno750(240) + size.height;
    }
    return Anno750(300);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ExpertListCell";
    ExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ExpertListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithQuestionModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dataArray[indexPath.row].isOpen = ! self.dataArray[indexPath.row].isOpen;
    [self.tabview reloadData];
}
- (void)getData{
    [SVProgressHUD show];
    NSDictionary * dic = @{
                              @"PageIndex":@(self.page),
                              @"PageSize":@10,
                              @"Versions":@3,
                              @"CreateAuthor":[UserManager instance].userInfo.ID
                              };
    NSMutableDictionary * params = [[NSMutableDictionary alloc]initWithDictionary:dic];
    NSString * pageUrl = Page_AllQuest;
    if (self.isMine) {
        pageUrl = Page_MineQuest;
        [params setValue:@5 forKey:@"TopCount"];
    }
    [[NetWorkManager manager] GET:pageUrl tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        self.page++;
        for (int i = 0; i<arr.count; i++) {
            QuestionModel * model = [[QuestionModel alloc]initWithDictionary:arr[i]];
            if (i == 2) {
                model.Answer = @"";
            }
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
                [self showNullViewWithMessage:@"暂无用户提问..."];
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

- (void)PushToUserQuestionViewController{
    [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
}
@end
