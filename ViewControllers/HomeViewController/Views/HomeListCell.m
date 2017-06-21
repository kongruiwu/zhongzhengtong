//
//  HomeListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HomeListCell.h"


@implementation HomeButton

- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage * image = self.imageView.image;
    self.imageView.frame = CGRectMake((Anno750(329) - image.size.width)/2, Anno750(50), image.size.width, image.size.height);
    self.titleLabel.frame = CGRectMake(0, Anno750(70) + image.size.height, Anno750(329), Anno750(30));
}

@end


@implementation HomeListCell

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
    self.FristBtn = [self creatHomeButton];
    self.secodBtn = [self creatHomeButton];
    [self addSubview:self.FristBtn];
    [self addSubview:self.secodBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.FristBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
        make.height.equalTo(@(Anno750(220)));
        make.width.equalTo(@(Anno750(329)));
    }];
    [self.secodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(20)));
        make.height.equalTo(@(Anno750(220)));
        make.width.equalTo(@(Anno750(329)));
    }];
}
- (HomeButton *)creatHomeButton{
    HomeButton * button = [HomeButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(HomeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:Anno750(28)];
    button.layer.cornerRadius = 2.0f;
    return button;
}
- (void)updateWithFristModel:(HomeBtnModel *)model secodModel:(HomeBtnModel *)secM{
    [self updateBtn:self.FristBtn WithModel:model];
    [self updateBtn:self.secodBtn WithModel:secM];
}
- (void)updateBtn:(HomeButton *)btn WithModel:(HomeBtnModel *)model{
    [btn setBackgroundColor:model.color];
    [btn setTitle:model.title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:model.imgName] forState:UIControlStateNormal];
}
- (void)HomeBtnClick:(UIButton *)btn{

    if ([self.delegate respondsToSelector:@selector(pushToNextvc:)]) {
        [self.delegate pushToNextvc:btn];
    }
}

@end
