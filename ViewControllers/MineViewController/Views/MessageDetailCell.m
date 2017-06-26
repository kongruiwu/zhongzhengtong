//
//  MessageDetailCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageDetailCell.h"

@implementation MessageDetailCell

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
    self.descLabel = [Factory creatLabelWithText:@"尊敬的用户，您订阅的大时代进计划涨了尊敬的用户，您订阅的大时代进计划涨了尊敬的用户，您订阅的大时代进计划涨了尊敬的用户，您订阅的大时代进计划涨了"
                                       fontValue:font750(28)
                                       textColor:KTColor_darkGray
                                   textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 2;
    self.timeLabel = [Factory creatLabelWithText:@"2017-04-28 15：31"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.lineView = [Factory creatLineView];
    self.openLabel = [Factory creatLabelWithText:@"展开"
                                       fontValue:font750(24)
                                       textColor:HomeBtn3 textAlignment:NSTextAlignmentRight];
    
    [self addSubview:self.descLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.openLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(54)));
        make.top.equalTo(@(Anno750(30)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(self.descLabel.mas_bottom).offset(Anno750(20));
    }];
    [self.openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(Anno750(-10)));
        make.bottom.equalTo(self.descLabel.mas_bottom);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithMessageModel:(MessageModel *)model{
    self.descLabel.text = model.MsgContent;
    self.timeLabel.text = [Factory getTodayTimeType:model.SendDate];
    CGSize size = [Factory getSize:model.MsgContent maxSize:CGSizeMake(999999, Anno750(28)) font:[UIFont systemFontOfSize:font750(28)]];
    self.openLabel.hidden = size.width >= 2 * Anno750(750 - 78) ? NO : YES;
    if (model.isOpen) {
        self.descLabel.numberOfLines = 0;
        self.openLabel.text = @"收起";
        self.openLabel.textColor = HomeBtn4;
    }else{
        self.descLabel.numberOfLines = 2;
        self.openLabel.text = @"展开";
        self.openLabel.textColor = HomeBtn3;
    }
}
@end
