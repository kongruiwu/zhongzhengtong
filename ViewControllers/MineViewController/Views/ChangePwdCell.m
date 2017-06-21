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
    
    if ([self.delegate respondsToSelector:@selector(userGetCode)]) {
        [self.delegate userGetCode];
    }
}

@end
