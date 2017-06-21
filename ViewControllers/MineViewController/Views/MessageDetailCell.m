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
                                       fontValue:font750(30)
                                       textColor:KTColor_darkGray
                                   textAlignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 2;
    self.timeLabel = [Factory creatLabelWithText:@"2017-04-28 15：31"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.lineView = [Factory creatLineView];
    self.downBtn = [Factory creatButtonWithNormalImage:@"down" selectImage:@"up"];
    
    [self addSubview:self.descLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.downBtn];
    
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
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(30)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(self.descLabel.mas_bottom);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
@end
