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
#import "NullQuestionView.h"
@interface ExpertViewController ()<UITableViewDelegate,UITableViewDataSource,ExpertListCellDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<QuestionModel *> * dataArray;
@property (nonatomic, strong) UIButton * questBtn;
@property (nonatomic) int page;
@property (nonatomic, strong) NullQuestionView * nullQestView;

@end

@implementation ExpertViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
    [self creatNullView];
}

- (void)drawRightButton{
    UIBarButtonItem * rightBaritem = [[UIBarButtonItem alloc]initWithTitle:@"我的提问" style:UIBarButtonItemStylePlain target:self action:@selector(checkMineQuestion)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
}
- (void)creatNullView{
    self.nullQestView = [[NullQuestionView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT)];
    self.nullQestView.hidden = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PushToUserQuestionViewController)];
    [self.nullQestView addGestureRecognizer:tap];
    [self.view addSubview:self.nullQestView];
}
- (void)showNullViewWithMessage:(NSString *)message{
    self.nullQestView.hidden = NO;
    [self.view bringSubviewToFront:self.nullQestView];
}
- (void)checkMineQuestion{
    ExpertViewController * vc = [[ExpertViewController alloc]init];
    vc.isMine = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 49 - 64) style:UITableViewStylePlain];
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
    CGSize size = CGSizeMake(0, 0);
    if (self.dataArray[indexPath.row].nameOpen) {
        size = [Factory getSize:self.dataArray[indexPath.row].Question maxSize:CGSizeMake(Anno750(750 - 174), 99999) font:[UIFont systemFontOfSize:font750(28)]];
    }else{
        size = CGSizeMake(0, Anno750(28));
    }
    if (self.dataArray[indexPath.row].Answer == nil || self.dataArray[indexPath.row].Answer.length == 0) {
        return Anno750(192) + size.height;
    }
    CGSize answerSize = CGSizeMake(0, 0);
    if (self.dataArray[indexPath.row].isOpen) {
        answerSize = [Factory getSize:self.dataArray[indexPath.row].Answer maxSize:CGSizeMake(Anno750(750 - 198), 999999) font:[UIFont systemFontOfSize:font750(28)]];
    }else{
        answerSize = CGSizeMake(0, Anno750(60));
    }
    return Anno750(212) + size.height + answerSize.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ExpertListCell";
    ExpertListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ExpertListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithQuestionModel:self.dataArray[indexPath.row]];
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dataArray[indexPath.row].isOpen = ! self.dataArray[indexPath.row].isOpen;
    [self.tabview reloadData];
}
- (void)openNameLabel:(UIButton *)btn{
    ExpertListCell * cell = (ExpertListCell *)[btn superview];
    NSIndexPath * indexpath = [self.tabview indexPathForCell:cell];
    self.dataArray[indexpath.row].nameOpen = !self.dataArray[indexpath.row].nameOpen;
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
                [self showNullViewWithMessage:@"暂无用户提问..."];
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

- (void)PushToUserQuestionViewController{
    [self.navigationController pushViewController:[FeedbackViewController new] animated:YES];
}
@end
