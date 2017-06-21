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

@end

@implementation ForgetPwdViewController

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
        [protoBtn addTarget:self action:@selector(checkProtocol) forControlEvents:UIControlEventTouchUpInside];
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
            cell.getcode.hidden =NO;
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
        ForgetPwdViewController * vc = [ForgetPwdViewController new];
        vc.logType = LOGINTYPESETPWD;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.logType == LOGINTYPEREGISTER){
        [self userRegister];
    }else{
        
    }
}
- (void)pushToProtocolView{
    WkWebViewController * vc = [[WkWebViewController alloc]initWithTitle:@"服务协议" content:@""];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)userGetCode{
    NSDictionary * params = @{
                              @"TelPhone":self.phoneTextF.text
                              };
    [[NetWorkManager manager] POST:Page_SendSms tokenParams:params complete:^(id result) {
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"短信验证码已发出" duration:2.0f];
    } error:^(JSError *error) {
        
    }];
}
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
        [ToastView presentToastWithin:self.view withIcon:APToastIconNone text:@"注册成功" duration:2.0f];
        [self dismissViewControllerAnimated:YES completion:nil];
    } error:^(JSError *error) {
        
    }];
}
- (void)agreePortocol{
    self.selctBtn.selected = !self.selctBtn.selected;
}
- (void)checkProtocol{
    
}
@end
