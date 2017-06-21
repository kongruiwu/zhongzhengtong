//
//  PayMoenyViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PayMoenyViewController.h"
#import "PayListCell.h"
#import "WkWebViewController.h"
@interface PayMoenyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tabview;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation PayMoenyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    [self setNavTitle:@"服务续费"];
    [self creatUI];
}
- (void)creatUI{
    self.tabview = [Factory creatTabviewWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT) style:UITableViewStylePlain];
    self.tabview.delegate = self;
    self.tabview.dataSource = self;
    [self.view addSubview:self.tabview];
    
    UIView * footer = [Factory creatViewWithColor:[UIColor clearColor]];
    UIButton * payBtn = [Factory creatButtonWithTitle:@"确认支付"
                                      backGroundColor:[UIColor clearColor]
                                            textColor:MainRed
                                             textSize:font750(30)];
    payBtn.layer.borderColor = MainRed.CGColor;
    payBtn.layer.borderWidth = 1.0f;
    UIButton * selctBtn = [Factory creatButtonWithNormalImage:@"unselect" selectImage:@"select"];
    UIButton * protoBtn = [Factory creatButtonWithTitle:@"我已同意《支付协议》"
                                        backGroundColor:[UIColor clearColor]
                                              textColor:KTColor_darkGray
                                               textSize:font750(26)];
    [protoBtn addTarget:self action:@selector(pushToProtoView) forControlEvents:UIControlEventTouchUpInside];
    NSString * proto = @"支付协议";
    NSMutableAttributedString * attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"我已同意《%@》",proto]];
    [attstr addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(5, proto.length)];
    [protoBtn setAttributedTitle:attstr forState:UIControlStateNormal];
    
    footer.frame = CGRectMake(0, 0, UI_WIDTH, Anno750(180));
    [footer addSubview:payBtn];
    [footer addSubview:selctBtn];
    [footer addSubview:protoBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@(Anno750(80)));
        make.top.equalTo(@(Anno750(40)));
    }];
    [protoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(64)));
        make.top.equalTo(payBtn.mas_bottom).offset(Anno750(30));
        make.width.equalTo(@(Anno750(280)));
        make.height.equalTo(@(Anno750(30)));
    }];
    [selctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Anno750(40)));
        make.height.equalTo(@(Anno750(40)));
        make.centerY.equalTo(protoBtn.mas_centerY);
        make.left.equalTo(@(Anno750(24)));
    }];
    self.tabview.tableFooterView = footer;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return Anno750(110);
    }
    return Anno750(90);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellid = @"PayListCell";
    PayListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[PayListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    switch (indexPath.row) {
        case 0:
        {
            [cell showLeftIcon];
        }
            break;
        case 1:
        {
            [cell updateWithTitle:@"帐号名称" desc:@"xpf12345"];
        }
            break;
        case 2:
        {
            [cell updateWithTitle:@"付费方式" desc:@"按月付费"];
            [Factory setLabel:cell.descLabel BorderColor:MainRed with:1.0f cornerRadius:0];
            cell.descLabel.textColor = MainRed;
            cell.descLabel.textAlignment = NSTextAlignmentCenter;
            [cell.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(Anno750(150)));
                make.height.equalTo(@(Anno750(50)));
            }];
        }
            break;
        case 3:
        {
            [cell updateWithTitle:@"价格" desc:@"980元／月"];
            NSString * price = @"980";
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元/月",price]];
            [attStr addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(0, price.length)];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font750(24)] range:NSMakeRange(price.length, attStr.length - price.length)];
            cell.descLabel.attributedText = attStr;
            
        }
            break;
        case 4:
        {
            [cell updateWithTitle:@"支付方式" desc:@"微信支付"];
        }
            break;
        case 5:
        {
            [cell updateWithTitle:@"开通期限" desc:@""];
            cell.descLabel.hidden =YES;
//            cell.reduceButton.hidden = NO;
            cell.countTextf.hidden = NO;
//            cell.addButton.hidden = NO;
        }
            break;
        case 6:
        {
            [cell updateWithTitle:@"应付总额" desc:@"980元"];
            NSString * price = @"980";
            NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元/月",price]];
            [attStr addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(0, price.length)];
            [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font750(24)] range:NSMakeRange(price.length, attStr.length - price.length)];
            cell.descLabel.attributedText = attStr;
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)pushToProtoView{
    WkWebViewController * vc = [[WkWebViewController alloc]initWithTitle:@"支付协议" content:@""];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
