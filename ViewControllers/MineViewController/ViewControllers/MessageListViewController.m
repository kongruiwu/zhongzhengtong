//
//  MessageListViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageDetailCell.h"
#import "MessageModel.h"
@interface MessageListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray<MessageModel *> * dataArray;
@property (nonatomic) int page;

@end

@implementation MessageListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPush) {
        [self setNavTitle:@"推送消息"];
    }else{
        [self setNavTitle:@"系统消息"];
    }
    
    [self drawBackButton];
    [self creatUI];
    [self getData];
    [self addRefreshView];
    [self drawRightButton];
}

- (void)drawRightButton{
    UIBarButtonItem * rightBaritem = [[UIBarButtonItem alloc]initWithTitle:@"一键清除" style:UIBarButtonItemStylePlain target:self action:@selector(cleanAllMessage)];
    self.navigationItem.rightBarButtonItem = rightBaritem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font750(28)],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

- (void)creatUI{
    self.page = 1;
    self.dataArray = [NSMutableArray new];
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 49) style:UITableViewStylePlain];
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
    
    if (self.dataArray[indexPath.row].isOpen) {
        CGSize size = [Factory getSize:self.dataArray[indexPath.row].MsgContent maxSize:CGSizeMake(Anno750(750 - 78), 999999) font:[UIFont systemFontOfSize:font750(28)]];
        return Anno750(120)+ size.height;
    }
    return Anno750(180);
}
//设置cell为可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self cleanMessageID:self.dataArray[indexPath.row].ID isShow:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tabview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"MessageDetailCell";
    MessageDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MessageDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell updateWithMessageModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = [Factory getSize:self.dataArray[indexPath.row].MsgContent maxSize:CGSizeMake(999999, Anno750(28)) font:[UIFont systemFontOfSize:font750(28)]];
    if (size.width >= 2 * Anno750(750 - 78) ? NO : YES) {
        return;
    }

    self.dataArray[indexPath.row].isOpen = !self.dataArray[indexPath.row].isOpen;
    [self.tabview reloadData];
}
- (void)updatedata{
    self.page = 1;
    [self.dataArray removeAllObjects];
    [self getData];
}
- (void)LoadMoreData{
    [self getData];
}
- (void)getData{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"UserId":[UserManager instance].userInfo.ID,
                              @"PageIndex":@(self.page),
                              @"PageSize":@10
                              };
    NSString * pageUrl = Page_SysList;
    if (self.isPush) {
        pageUrl = Page_PushList;
    }
    [[NetWorkManager manager] GET:pageUrl tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        self.page++;
        for (int i = 0; i<arr.count; i++) {
            MessageModel * model = [[MessageModel alloc]initWithDictionary:arr[i]];
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
                [self showNullViewWithMessage:@"暂时还没有您的消息..."];
            }else{
                [self.refreshFooter endRefreshingWithNoMoreData];
                [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"没有更多了" duration:1.0f];
            }
            
        }else{
            [self showNullViewWithMessage:@"网络好像有问题..."];
        }
    }];
}
- (void)cleanAllMessage{
    NSArray<MessageModel *> * arr = [NSArray arrayWithArray:self.dataArray];
    for (int i = 0; i<arr.count; i++) {
        [self cleanMessageID:arr[i].ID isShow:NO];
    }
    [self.dataArray removeAllObjects];
    [self showNullViewWithMessage:@"暂时还没有您的消息..."];
}
- (void)cleanMessageID:(NSString *)messageID isShow:(BOOL)rec{
    NSDictionary * params = @{
                              @"Id":messageID
                              };
    [[NetWorkManager manager] POST:Page_DelMess tokenParams:params complete:^(id result) {
        if (rec) {
            [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"删除成功" duration:1.0f];
        }
    } error:^(JSError *error) {
        
    }];
}
@end
