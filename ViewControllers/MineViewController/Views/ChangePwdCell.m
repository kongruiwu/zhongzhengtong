//
//  ChangePwdCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ChangePwdCell.h"

@implementation ChangePwdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)creatUI{
    self.time = 59;
    self.inputTextf = [[UITextField alloc]init];
    self.inputTextf.textAlignment = NSTextAlignmentLeft;
    self.inputTextf.font = [UIFont systemFontOfSize:font750(28)];
    self.lineView = [Factory creatLineView];
    
    self.getcode = [Factory creatButtonWithTitle:@"获取验证码"
                                 backGroundColor:[UIColor clearColor]
                                       textColor:MainRed
                                        textSize:font750(26)];
    self.getcode.layer.borderColor = MainRed.CGColor;
    self.getcode.layer.borderWidth = 1.0f;
    [self.getcode addTarget:self action:@selector(getTheCode) forControlEvents:UIControlEventTouchUpInside];
    self.getcode.hidden = YES;
    [self addSubview:self.inputTextf];
    [self addSubview:self.lineView];
    [self addSubview:self.getcode];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.inputTextf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    [self.getcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(160)));
        make.height.equalTo(@(Anno750(50)));
    }];
}
- (void)getTheCode{
    self.getcode.enabled = NO;
    self.getcode.layer.borderColor = KTColor_lightGray.CGColor;
    [self.getcode setTitle:@"59秒后重试" forState:UIControlStateNormal];
    [self.getcode setTitleColor:KTColor_darkGray forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeButttonTime) userInfo:nil repeats:YES];
    
    if ([self.delegate respondsToSelector:@selector(userGetCode)]) {
        [self.delegate userGetCode];
    }
}

- (void)changeButttonTime{
    if (self.time == 1) {
        self.time = 59;
        self.getcode.enabled = YES;
        [self.getcode setTitleColor:MainRed forState:UIControlStateNormal];
        [self.getcode setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getcode.layer.borderColor = MainRed.CGColor;
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.time -- ;
        [self.getcode setTitle:[NSString stringWithFormat:@"%d秒后重试",self.time] forState:UIControlStateNormal];
    }
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
@end
