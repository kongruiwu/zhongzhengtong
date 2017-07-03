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
@property (nonatomic, strong) UITextField * oldPwdTextF;
@property (nonatomic, strong) UITextField * pwdTextF;
@property (nonatomic, strong) UITextField * checkTextF;
@property (nonatomic, strong) UIButton * nextBtn ;
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
    UIButton * nextBtn = [Factory creatButtonWithTitle:@"修改密码"
                                       backGroundColor:[UIColor clearColor]
                                             textColor:KTColor_lightGray
                                              textSize:font750(30)];
    [nextBtn setTitleColor:MainRed forState:UIControlStateSelected];
    [nextBtn addTarget:self action:@selector(getData) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.borderWidth = 1.0f;
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    [footer addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@(Anno750(80)));
        make.top.equalTo(@(Anno750(30)));
    }];
    self.nextBtn = nextBtn;
    [RACObserve(self.nextBtn, selected) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            self.nextBtn.layer.borderColor = MainRed.CGColor;
        }else{
            self.nextBtn.layer.borderColor = KTColor_lightGray.CGColor;
        }
    }];
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ChangePwdCell";
    ChangePwdCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ChangePwdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 0) {
        self.oldPwdTextF = cell.inputTextf;
    }else if(indexPath.row == 1){
        self.pwdTextF = cell.inputTextf;
    }else if(indexPath.row == 2){
        self.checkTextF = cell.inputTextf;
    }
    cell.inputTextf.secureTextEntry = YES;
    cell.inputTextf.placeholder = self.placeHolders[indexPath.row];
    [cell.inputTextf addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    return cell;
}
- (void)getData{
    if ([self.pwdTextF.text containsString:@" "]) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"字符中不能包含空格等特殊字符，请重新输入" duration:1.0f];
        return;
    }
    
    if (self.pwdTextF.text.length< 6 || self.pwdTextF.text.length>18) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"密码长度位数为6～18位，请重新输入" duration:1.0f];
        return;
    }
    
    if (![self.checkTextF.text isEqualToString:self.pwdTextF.text]) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"两次密码输入不一致，请重新输入" duration:1.0f];
        return;
    }

    NSDictionary * params = @{
                              @"UserName":[UserManager instance].userInfo.UserName,
                              @"OldPassword":self.oldPwdTextF.text,
                              @"NewPassword":self.pwdTextF.text,
                              @"ConfirmPassword":self.checkTextF.text
                              };

    [[NetWorkManager manager] POST:Page_ChangePwd tokenParams:params complete:^(id result) {
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"修改成功" duration:1.5f];
        [self doBack];
    } error:^(JSError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)textChanged{
    if (self.oldPwdTextF.text.length>= 6 && self.pwdTextF.text.length>=6 && self.checkTextF.text.length>= 6) {
        self.nextBtn.selected = YES;
    }else{
        self.nextBtn.selected = NO;
    }
}
@end
