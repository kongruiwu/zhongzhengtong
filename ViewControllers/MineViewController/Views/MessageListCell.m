//
//  MessageListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

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
    self.leftImg = [Factory creatImageViewWithImage:@""];
    self.nameLabel = [Factory creatLabelWithText:@"系统消息"
                                       fontValue:font750(30)
                                       textColor:KTColor_MainBlack
                                   textAlignment:NSTextAlignmentLeft];
    self.descLabel = [Factory creatLabelWithText:@"尊敬的用户，您订阅的大时代进计划涨了"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.nextIcon = [Factory creatArrowImage];
    self.lineView = [Factory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.nextIcon];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(70)));
        make.height.equalTo(@(Anno750(70)));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.top.equalTo(self.leftImg.mas_top);
    }];
    [self.nextIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-24)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        make.bottom.equalTo(self.leftImg.mas_bottom);
        make.right.equalTo(@(Anno750(-60)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
}

- (void)updateWithImage:(NSString *)img title:(NSString *)title desc:(NSString *)desc{
    self.leftImg.image = [UIImage imageNamed:img];
    if (desc == nil|| desc.length == 0) {
        self.descLabel.text = @"暂无最新信息";
    }else{
        self.descLabel.text = desc;
    }
    self.nameLabel.text = title;
}

@end
