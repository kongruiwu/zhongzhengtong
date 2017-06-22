//
//  MineViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MineViewController.h"
#import "MineListCell.h"
#import "MineHeader.h"
#import "MessageViewController.h"
#import "VersionViewController.h"
#import "ChangePwdViewController.h"
#import "PayMoenyViewController.h"
#import <WXApi.h>
//测试
#import "LoginViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tabview;
@property (nonatomic, strong) MineHeader * header;
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic, strong) NSArray * images;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, 20)];
    clearView.backgroundColor = [UIColor clearColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.view addSubview:clearView];
    [self.header updateUseinfo];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    self.titles = @[@"我的消息",@"修改密码",@"客服热线",@"关于版本"];
    self.images = @[@"message",@"changepwd",@"hotline",@"version"];
    
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI{
    self.view.backgroundColor = GroundColor;
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT- 49) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(340);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        self.header = [[MineHeader alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, Anno750(340))];
        [self.header.buyBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
        [self.header updateUseinfo];
        return self.header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return Anno750(20);
    }else if(section == 1){
        return Anno750(440);
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView * footer = [Factory creatViewWithColor:GroundColor];
        footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(440));
        UIButton * canncebtn = [Factory creatButtonWithTitle:@"退出登录"
                                             backGroundColor:[UIColor whiteColor]
                                                   textColor:MainRed
                                                    textSize:font750(32)];
        [footer addSubview:canncebtn];
        [canncebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@(Anno750(100)));
            make.bottom.equalTo(@0);
        }];
        [canncebtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
        return footer;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"cellid";
    MineListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MineListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.section == 0) {
        [cell updateWithTitle:self.titles[indexPath.row] image:self.images[indexPath.row]];
        if (indexPath.row == 2) {
            cell.descLabel.text = @"400-608-8879";
        }
    }else{
        [cell updateWithTitle:self.titles[indexPath.section * 3 +indexPath.row] image:self.images[indexPath.section * 3 +indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[MessageViewController new] animated:YES];
        }else if(indexPath.row == 1){
            [self.navigationController pushViewController:[ChangePwdViewController new] animated:YES];
        }else {
            [Factory callPhoneStr:@"400-608-8879" withVC:self];
        }
    }else if(indexPath.section == 1){
        [self.navigationController pushViewController:[VersionViewController new] animated:YES];
    }
}
- (void)payMoney{
    JumpToBizProfileReq * req = [[JumpToBizProfileReq alloc]init];
    req.profileType = WXBizProfileType_Device;
    req.username = WeCharUserID;
    [WXApi sendReq:req];
}
- (void)userLogin{
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
