//
//  HotNewsCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotNewsCell.h"

@implementation HotNewsCell

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
    self.topline = [Factory creatLineView];
    self.bottomline = [Factory creatLineView];
    self.centerImg = [Factory creatImageViewWithImage:@"hot"];
    self.contentLabel = [Factory creatLabelWithText:@"撒打算打算打算打算打算打算打算的啊 dasd啊啥的撒大时代啊啥的啊啥的啊啥的啊啥大三大四的啊啥的啊啥的撒大三大三大时代啊啊啥大三的"
                                          fontValue:font750(28)
                                          textColor:KTColor_MainBlack
                                      textAlignment:NSTextAlignmentLeft];
    self.contentLabel.numberOfLines = 0;
    self.timeLabel = [Factory creatLabelWithText:@"10:17"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.tagLabel = [Factory creatLabelWithText:@"房产"
                                      fontValue:font750(24)
                                      textColor:MainRed
                                  textAlignment:NSTextAlignmentCenter];
    [Factory setLabel:self.tagLabel BorderColor:MainRed with:1.0f cornerRadius:2.0f];
    

    [self addSubview:self.topline];
    [self addSubview:self.centerImg];
    [self addSubview:self.bottomline];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.tagLabel];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.centerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(24)));
        make.height.equalTo(@(Anno750(24)));
    }];
    [self.topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(self.centerImg.mas_top);
        make.centerX.equalTo(self.centerImg);
        make.width.equalTo(@1);
    }];
    [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerImg.mas_bottom);
        make.bottom.equalTo(@0);
        make.centerX.equalTo(self.centerImg);
        make.width.equalTo(@1);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerImg.mas_right).offset(Anno750(24));
        make.right.equalTo(@(Anno750(-24)));
        make.top.equalTo(@(Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(Anno750(24));
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-24)));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(Anno750(24));
        make.height.equalTo(@(Anno750(40)));
        make.width.equalTo(@(Anno750(80)));
    }];

}
- (void)updateFristCell:(BOOL)rec{
    if (rec) {
        self.centerImg.image = [UIImage imageNamed:@"hot_select"];
        self.timeLabel.textColor  = MainRed;
        self.topline.hidden = YES;
    }else{
        self.centerImg.image = [UIImage imageNamed:@"hot"];
        self.timeLabel.textColor = KTColor_lightGray;
        self.topline.hidden = NO;
    }
    
}
- (void)updateWithHotNewsModel:(HotNewsModel *)model{
    self.contentLabel.text = model.NEWSTITLE;
    NSString * time = [model.CREATEDATE substringWithRange:NSMakeRange(11, 5)];
    self.timeLabel.text = time;
    self.tagLabel.text = model.NEWSTYPE;


}
@end
