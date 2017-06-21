//
//  ChangePwdViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ChangePwdCell.h"
@interface ChangePwdViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSArray * placeHolders;

@end

@implementation ChangePwdViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"修改密码"];
    [self drawBackButton];
    [self creatUI];
}

- (void)creatUI{
    self.placeHolders = @[@"原密码",@"请输入6-18位新密码",@"确认新密码"];
    self.view.backgroundColor = GroundColor;
    
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.placeHolders.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(20);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Anno750(120);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [Factory creatViewWithColor:[UIColor clearColor]];
    UIButton * nextBtn = [Factory creatButtonWithTitle:@"下一步"
                                       backGroundColor:[UIColor clearColor]
                                             textColor:MainRed
                                              textSize:font750(30)];
    nextBtn.layer.borderColor = MainRed.CGColor;
    nextBtn.layer.borderWidth = 1.0f;
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    [footer addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@(Anno750(80)));
        make.top.equalTo(@(Anno750(30)));
    }];
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ChangePwdCell";
    ChangePwdCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ChangePwdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.inputTextf.placeholder = self.placeHolders[indexPath.row];
    return cell;
}


@end
