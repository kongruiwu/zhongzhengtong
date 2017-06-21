//
//  ForgetPwdViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "ChangePwdCell.h"
#import "WkWebViewController.h"
@interface ForgetPwdViewController ()<UITableViewDelegate,UITableViewDataSource,ChangePwdCellDelegate>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSArray * placeHolders;
@property (nonatomic, strong) UITextField * phoneTextF;
@property (nonatomic, strong) UITextField * codeTextF;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIButton * selctBtn;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UIButton * getCodeBtn;
@property (nonatomic, assign) int time;

@end

@implementation ForgetPwdViewController

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    switch (self.logType) {
        case LOGINTYPEFOGET:
        {
            [self setNavTitle:@"忘记密码"];
        }
            break;
        case LOGINTYPESETPWD:
        {
            [self setNavTitle:@"重置密码"];
        }
            break;
        case LOGINTYPEREGISTER:
        {
            [self setNavTitle:@"注册"];
        }
            break;
        default:
            break;
    }
    
    [self creatUI];
}

- (void)creatUI{
    self.placeHolders = @[@"输入手机号",@"验证码"];
    if (self.logType == LOGINTYPESETPWD) {
        self.placeHolders = @[@"请输入6-18位新密码",@"确认新密码"];
    }else if(self.logType == LOGINTYPEREGISTER){
        self.placeHolders = @[@"输入手机号",@"输入密码"];
    }
    
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
    return Anno750(180);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * footer = [Factory creatViewWithColor:[UIColor clearColor]];
    NSString * title = @"下一步";
    if (self.logType == LOGINTYPESETPWD) {
        title = @"修改密码";
    }else if(self.logType == LOGINTYPEREGISTER){
        title = @"立即注册";
    }
    UIButton * nextBtn = [Factory creatButtonWithTitle:title
                                       backGroundColor:[UIColor clearColor]
                                             textColor:MainRed
                                              textSize:font750(30)];
    nextBtn.layer.borderColor = MainRed.CGColor;
    nextBtn.layer.borderWidth = 1.0f;
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(120));
    [nextBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.height.equalTo(@(Anno750(80)));
        make.top.equalTo(@(Anno750(30)));
    }];
    self.nextBtn = nextBtn;
    if (self.logType == LOGINTYPEREGISTER) {
        UIButton * selctBtn = [Factory creatButtonWithNormalImage:@"unselect" selectImage:@"select"];
        UIButton * protoBtn = [Factory creatButtonWithTitle:@"我已阅读服务条款"
                                            backGroundColor:[UIColor clearColor]
                                                  textColor:KTColor_darkGray
                                                   textSize:font750(26)];
        [protoBtn addTarget:self action:@selector(pushToProtocolView) forControlEvents:UIControlEventTouchUpInside];
        NSString * proto = @"服务条款";
        NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"我已阅读%@",proto]];
        [attstr addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(4, proto.length)];
        [protoBtn setAttributedTitle:attstr forState:UIControlStateNormal];
        [footer addSubview:selctBtn];
        [footer addSubview:protoBtn];
        [protoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Anno750(64)));
            make.top.equalTo(nextBtn.mas_bottom).offset(Anno750(30));
            make.width.equalTo(@(Anno750(220)));
            make.height.equalTo(@(Anno750(30)));
        }];
        [selctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(Anno750(40)));
            make.height.equalTo(@(Anno750(40)));
            make.centerY.equalTo(protoBtn.mas_centerY);
            make.left.equalTo(@(Anno750(24)));
        }];
        self.selctBtn = selctBtn;
        [self.selctBtn addTarget:self action:@selector(agreePortocol) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"ChangePwdCell";
    ChangePwdCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ChangePwdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    if (indexPath.row == 1) {
        if (self.logType == LOGINTYPEFOGET) {
            self.time = 59;
            cell.getcode.hidden =NO;
            self.getCodeBtn = cell.getcode;
        }
        self.codeTextF = cell.inputTextf;
    }else{
        self.phoneTextF = cell.inputTextf;
        cell.getcode.hidden = YES;
    }
    cell.inputTextf.placeholder = self.placeHolders[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (void)sureBtnClick{
    if (self.logType == LOGINTYPEFOGET) {
        [self checkCode];
    }else if(self.logType == LOGINTYPEREGISTER){
        [self userRegister];
    }else{
        [self resetPassWord];
    }
}
#pragma mark 查看协议
- (void)pushToProtocolView{
    WkWebViewController * vc = [[WkWebViewController alloc]initWithTitle:@"服务协议" content:@""];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 获取验证码
- (void)userGetCode{
    [SVProgressHUD show];
    NSDictionary * params = @{
                              @"TelPhone":self.phoneTextF.text
                              };
    [[NetWorkManager manager] POST:Page_SendSms tokenParams:params complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"短信验证码已发出" duration:2.0f];
        self.getCodeBtn.enabled = NO;
        self.getCodeBtn.layer.borderColor = KTColor_lightGray.CGColor;
        [self.getCodeBtn setTitle:@"59秒后重试" forState:UIControlStateNormal];
        [self.getCodeBtn setTitleColor:KTColor_darkGray forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeButttonTime) userInfo:nil repeats:YES];
    } error:^(JSError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}
- (void)changeButttonTime{
    if (self.time == 1) {
        self.time = 59;
        self.getCodeBtn.enabled = YES;
        [self.getCodeBtn setTitleColor:MainRed forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getCodeBtn.layer.borderColor = MainRed.CGColor;
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.time -- ;
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重试",self.time] forState:UIControlStateNormal];
    }
}

#pragma mark 验证验证码
- (void)checkCode{
    NSDictionary * params =@{
                             @"TelPhone":self.phoneTextF.text,
                             @"Code":self.codeTextF.text
                             };
    [[NetWorkManager manager] POST:Page_CheckSms tokenParams:params complete:^(id result) {
        ForgetPwdViewController * vc = [ForgetPwdViewController new];
        vc.logType = LOGINTYPESETPWD;
        vc.phoneNum = self.phoneTextF.text;
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(JSError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}

#pragma mark 用户重置密码
- (void)resetPassWord{
    if (![self.phoneTextF.text isEqualToString:self.codeTextF.text]) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"两次密码不一致，请重新输入" duration:1.0f];
    }
    NSDictionary * params = @{
                              @"Phone":self.phoneNum,
                              @"NewPassword":self.phoneTextF.text,
                              @"ConfirmPassword":self.codeTextF.text
                              };
    [[NetWorkManager manager] POST:Page_ResetPwd tokenParams:params complete:^(id result) {
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"修改成功" duration:1.0f];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(JSError *error) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:error.message duration:1.0f];
    }];
}

#pragma mark 用户注册
- (void)userRegister{
    if (!self.selctBtn.selected) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"您还没有同意服务条款" duration:2.0f];
        return;
    }
    NSDictionary * params = @{
                              @"UserName":self.phoneTextF.text,
                              @"UserPws":self.codeTextF.text
                              };
    [[NetWorkManager manager] POST:Page_Register tokenParams:params complete:^(id result) {
        [ToastView presentToastWithin:self.view.window withIcon:APToastIconNone text:@"注册成功" duration:2.0f];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(JSError *error) {
        
    }];
}
#pragma mark 同意协议
- (void)agreePortocol{
    self.selctBtn.selected = !self.selctBtn.selected;
}

@end