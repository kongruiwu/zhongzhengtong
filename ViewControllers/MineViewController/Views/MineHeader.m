//
//  MineHeader.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MineHeader.h"
#import <UIImageView+WebCache.h>
@implementation MineHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{

    self.groundImg = [Factory creatImageViewWithImage:@"mineBg"];
    self.userIcon = [Factory creatImageViewWithImage:@"userIcon"];
    self.userIcon.layer.cornerRadius = Anno750(70);
    self.userIcon.layer.masksToBounds = YES;
    self.nameLabel = [Factory creatLabelWithText:@"巴菲特"
                                       fontValue:font750(32)
                                       textColor:[UIColor whiteColor]
                                   textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [Factory creatLabelWithText:@"到期日期：2017-07-05"
                                       fontValue:font750(26)
                                       textColor:[UIColor whiteColor]
                                   textAlignment:NSTextAlignmentLeft];
    self.buyBtn = [Factory creatButtonWithTitle:@"关注公众号"
                                backGroundColor:[UIColor whiteColor]
                                      textColor:MainRed
                                       textSize:font750(26)];
    self.buyBtn.layer.cornerRadius = 2.0f;
    [self addSubview:self.groundImg];
    [self addSubview:self.userIcon];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.buyBtn];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.groundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@(Anno750(170)));
        make.height.equalTo(@(Anno750(140)));
        make.width.equalTo(@(Anno750(140)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIcon.mas_top);
        make.left.equalTo(self.userIcon.mas_right).offset(Anno750(30));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(15));
    }];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(Anno750(25));
        make.width.equalTo(@(Anno750(200)));
        make.height.equalTo(@(Anno750(50)));
    }];
}

- (void)updateUseinfo{
    self.nameLabel.text = [UserManager instance].userInfo.UserName;
    if ([UserManager instance].userInfo.OverdueDate && [UserManager instance].userInfo.OverdueDate.length >0) {
        self.timeLabel.hidden = NO;
        self.timeLabel.text = [NSString stringWithFormat:@"到期时间：%@",[UserManager instance].userInfo.OverdueDate];
    }else{
        self.timeLabel.hidden = YES;
    }
    [self.userIcon sd_setImageWithURL:[Factory getImageUlr:[UserManager instance].userInfo.Pic] placeholderImage:[UIImage imageNamed:@"userIcon"]];
}
@end
