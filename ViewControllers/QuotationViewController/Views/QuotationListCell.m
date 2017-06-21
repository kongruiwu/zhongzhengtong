//
//  QuotationListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "QuotationListCell.h"

@implementation QuotationListCell

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
    self.groundView = [Factory creatViewWithColor:GroundColor];
    self.nameLabel = [Factory creatLabelWithText:@"大龙集团"
                                       fontValue:font750(32)
                                       textColor:KTColor_MainBlack
                                   textAlignment:NSTextAlignmentLeft];
    self.timeLabel = [Factory creatLabelWithText:@"今天9:56"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentRight];
    self.priceLabel = [Factory creatLabelWithText:@"建议买入价：50.32元"
                                        fontValue:font750(26)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentLeft];
    self.countLabel = [Factory creatLabelWithText:@"建议仓位：满仓"
                                        fontValue:font750(26)
                                        textColor:KTColor_darkGray
                                    textAlignment:NSTextAlignmentLeft];
    self.descLabel = [Factory creatLabelWithText:@"入选理由撒大啊时间打手机大家收到啦快结束啊撒打算打算的"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines =1;
    self.downButton = [Factory creatButtonWithTitle:@"展开"
                                    backGroundColor:[UIColor clearColor]
                                          textColor:HomeBtn3
                                           textSize:font750(24)];
    [self.downButton setTitle:@"收起" forState:UIControlStateSelected];
    [self.downButton setTitleColor:HomeBtn4 forState:UIControlStateSelected];
    self.downButton.userInteractionEnabled  = NO ;
    self.lineView = [Factory creatLineView];
    
    [self addSubview:self.groundView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.countLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.downButton];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(48)));
        make.top.equalTo(@(Anno750(48)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(48)));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(48)));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(20));
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(420)));
        make.centerY.equalTo(self.priceLabel.mas_centerY);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(48)));
        make.right.equalTo(@(-Anno750(80)));
        make.top.equalTo(self.priceLabel.mas_bottom).offset(Anno750(20));
    }];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLabel.mas_right);
        make.bottom.equalTo(self.descLabel.mas_bottom);
        make.height.equalTo(@(Anno750(24)));
    }];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.top.equalTo(@(Anno750(24)));
        make.bottom.equalTo(self.descLabel.mas_bottom).offset(Anno750(24));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];
    
}
- (void)updateWithQuotationModel:(QuotationModel *)model{
    NSString * string = [NSString stringWithFormat:@"%@(%@)",model.stockName,model.stockCode];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:KTColor_lightGray range:NSMakeRange(model.stockName.length, string.length - model.stockName.length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Anno750(26)] range:NSMakeRange(model.stockName.length, string.length - model.stockName.length)];
    self.nameLabel.attributedText = att;
    
    string = [NSString stringWithFormat:@"建议买入价：%@",model.stockinprice];
    att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(string.length - model.stockinprice.length, model.stockinprice.length)];
    self.priceLabel.attributedText = att;
    
    string = [NSString stringWithFormat:@"建议仓位：%@",model.postionString];
    att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttribute:NSForegroundColorAttributeName value:MainRed range:NSMakeRange(string.length - model.postionString.length, model.postionString.length)];
    self.countLabel.attributedText = att;
    
    CGSize size = [Factory getSize:model.selectedRemark maxSize:CGSizeMake(999999, Anno750(24)) font:[UIFont systemFontOfSize:font750(24)]];
    BOOL rec = NO;
    if (size.width >= Anno750(750 - 128) || [model.selectedRemark containsString:@"\n"]) {
        rec = YES;
    }
    self.downButton.hidden = !rec;
    self.descLabel.text = model.selectedRemark;
    
    self.timeLabel.text = model.selectedTime;
    self.downButton.selected = model.isOpen;
    if (model.isOpen) {
        self.descLabel.numberOfLines = 0 ;
    }else{
        self.descLabel.numberOfLines = 1 ; 
    }
}
@end
