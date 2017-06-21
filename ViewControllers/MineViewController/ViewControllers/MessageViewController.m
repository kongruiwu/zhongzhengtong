//
//  MessageViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListCell.h"
#import "MessageListViewController.h"
#import "MessageModel.h"
@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSString * pushMessage;
@property (nonatomic, strong) NSString * sysMessage;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"我的消息"];
    [self drawBackButton];
    [self creatUI];
    [self getData];
}

- (void)creatUI{
    self.view.backgroundColor = GroundColor;
    
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(120);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"MessageListCell";
    MessageListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MessageListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row ==0) {
        [cell updateWithImage:@"push" title:@"推送消息" desc:self.pushMessage];
    }else{
        [cell updateWithImage:@"system" title:@"系统消息" desc:self.sysMessage];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListViewController * vc = [MessageListViewController new];
    if (indexPath.row == 0) {
        vc.isPush = YES;
    }else{
        vc.isPush = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getData{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    NSDictionary * params = @{
                            @"UserId":[UserManager instance].userInfo.ID,
                            @"TopCount":@1
                             };
    [[NetWorkManager manager] POST:Page_PushMes tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        if (arr.count>0) {
            MessageModel * model = [[MessageModel alloc]initWithDictionary:arr[0]];
            self.pushMessage = model.MsgContent;
            dispatch_group_leave(group);
        }
    } error:^(JSError *error) {
       self.pushMessage = @"";
        dispatch_group_leave(group);
    }];
    dispatch_group_enter(group);
    params = @{
              @"UserId":[UserManager instance].userInfo.ID,
              @"TopCount":@1
              };
    [[NetWorkManager manager] POST:Page_SysMes tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        if (arr.count>0) {
            MessageModel * model = [[MessageModel alloc]initWithDictionary:arr[0]];
            self.sysMessage = model.MsgContent;
            dispatch_group_leave(group);
        }
    } error:^(JSError *error) {
        self.sysMessage = @"";
        dispatch_group_leave(group);
    }];
    dispatch_queue_t mainquene = dispatch_get_main_queue();
    dispatch_group_notify(group, mainquene, ^{
        [self.tabview reloadData];
    });
}

@end
