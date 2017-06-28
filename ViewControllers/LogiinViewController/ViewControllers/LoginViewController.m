//
//  LoginViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCell.h"
#import "ForgetPwdViewController.h"
#import "RootViewController.h"
@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) UITextField * nameT;
@property (nonatomic, strong) UITextField * pwdT;
@property (nonatomic, strong) UIButton * loginBtn;


@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)creatUI{
    
    UIView * clearView = [Factory creatViewWithColor:[UIColor clearColor]];
    clearView.frame = CGRectMake(0, 0, UI_WIDTH, 20);
    [self.view addSubview:clearView];
    
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStyleGrouped];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Anno750(400);
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Anno750(735);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * header  = [Factory creatViewWithColor:[UIColor whiteColor]];
    header.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(400));
    UIImageView * logoImg = [Factory creatImageViewWithImage:@"textlogo"];
    UIButton * registBtn = [Factory creatButtonWithTitle:@"注册"
                                         backGroundColor:[UIColor clearColor]
                                               textColor:KTColor_darkGray
                                                textSize:font750(30)];
    [registBtn addTarget:self action:@selector(pushToregisterviewController) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:logoImg];
    [header addSubview:registBtn];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(450)));
        make.height.equalTo(@(Anno750(100)));
    }];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(30)));
        make.top.equalTo(@(Anno750(90)));
        make.width.equalTo(@(Anno750(80)));
        make.height.equalTo(@(Anno750(40)));
    }];
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [Factory creatViewWithColor:[UIColor whiteColor]];
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(735));
    UIButton * loginBtn = [Factory creatButtonWithTitle:@"登录"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_lightGray
                                               textSize:font750(32)];
    loginBtn.layer.borderWidth = 1.0f;
    [loginBtn setTitleColor:MainRed forState:UIControlStateSelected];
    self.loginBtn = loginBtn;
    [RACObserve(self.loginBtn, selected) subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            self.loginBtn.layer.borderColor = MainRed.CGColor;
        }else{
            self.loginBtn.layer.borderColor = KTColor_lightGray.CGColor;
        }
    }];
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    UIButton * savePwd = [Factory creatButtonWithTitle:@"  记住密码"
                                       backGroundColor:[UIColor clearColor]
                                             textColor:KTColor_darkGray
                                              textSize:font750(26)];
    [savePwd setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [savePwd setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    savePwd.selected = [UserManager instance].isSavePwd;
    [savePwd addTarget:self action:@selector(savePassword:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * forgetBtn = [Factory creatButtonWithTitle:@"忘记密码？"
                                         backGroundColor:[UIColor clearColor]
                                               textColor:MainRed
                                                textSize:font750(28)];
    [forgetBtn addTarget:self action:@selector(pushToforgetPwdViewController) forControlEvents:UIControlEventTouchUpInside];
    UIButton * phoneBtn = [Factory creatButtonWithTitle:@"客服电话：400-608-8879"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_darkGray
                                               textSize:font750(26)];
    [phoneBtn addTarget:self action:@selector(callPhone) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:loginBtn];
    [footer addSubview:savePwd];
    [footer addSubview:forgetBtn];
    [footer addSubview:phoneBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(50)));
        make.height.equalTo(@(Anno750(80)));
    }];
    [savePwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(loginBtn.mas_bottom).offset(Anno750(40));
        make.width.equalTo(@(Anno750(180)));
        make.height.equalTo(@(Anno750(30)));
    }];
    
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(Anno750(40));
        make.width.equalTo(@(Anno750(150)));
        make.height.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(24)));
    }];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-Anno750(50)));
        make.width.equalTo(@(Anno750(330)));
        make.height.equalTo(@(Anno750(30)));
    }];
    
    [self checkLoginBtnSate];
    return footer;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Anno750(100);
}
- (void)callPhone{
    [Factory callPhoneStr:@"400-608-8879" withVC:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"LoginCell";
    LoginCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[LoginCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    [cell.textF addTarget:self action:@selector(textchaged:) forControlEvents:UIControlEventEditingChanged];
    if (indexPath.row == 0) {
        [cell updateWithTitle:@"帐号" placeHolder:@"请输入用户名"];
        NSString * name = @"";
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]) {
            name = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
        }
        cell.textF.text = name;
        self.nameT = cell.textF;
    }else{
        [cell updateWithTitle:@"登录密码" placeHolder:@"请输入密码"];
        self.pwdT = cell.textF;
        cell.textF.secureTextEntry = YES;
        if ([UserManager instance].isSavePwd) {
            cell.textF.text =[[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"];
        }
    }
    return cell;
}
- (void)pushToregisterviewController{
    [self pushToNextViewControl:1];
}
- (void)pushToforgetPwdViewController{
    [self pushToNextViewControl:0];
}
- (void)pushToNextViewControl:(NSInteger)index{
    ForgetPwdViewController * vc = [ForgetPwdViewController new];
    vc.logType = index;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)userLogin{
    [SVProgressHUD show];
    [[NSUserDefaults standardUserDefaults] setValue:self.nameT.text forKey:@"UserName"];
    if ([UserManager instance].isSavePwd) {
        [[NSUserDefaults standardUserDefaults] setValue:self.pwdT.text forKey:@"PassWord"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary * params = @{
                              @"UserName":self.nameT.text,
                              @"UserPws":self.pwdT.text,
                              @"MCode":[UserManager instance].deviceId
                              };
    [[NetWorkManager manager] GET:Page_login tokenParams:params complete:^(id result) {
        NSDictionary * dic = (NSDictionary *)result;
        [UserManager instance].userInfo = [[UserModel alloc]initWithDictionary:dic];
        [[UserManager instance] checkUserLogin];
        [self dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication].keyWindow setRootViewController:[RootViewController new]];
        }];
        
    } error:^(JSError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)savePassword:(UIButton *)button{
    button.selected = !button.selected;
    if (!button.selected) {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"PassWord"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:self.pwdT.text forKey:@"PassWord"];
    }
    [UserManager instance].isSavePwd = button.selected;
}

-(void)textchaged:(UITextField *)textf{
    if (self.nameT.text.length > 0 && self.pwdT.text.length>0) {
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.selected = NO;
    }
}
- (void)checkLoginBtnSate{
    if (self.nameT.text.length > 0 && self.pwdT.text.length>0) {
        self.loginBtn.selected = YES;
    }else{
        self.loginBtn.selected = NO;
    }
}
@end
