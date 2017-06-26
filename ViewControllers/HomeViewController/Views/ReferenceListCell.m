//
//  ReferenceListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ReferenceListCell.h"
#import <UIImageView+WebCache.h>
@implementation ReferenceListCell

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
    self.leftImg = [Factory creatImageViewWithImage:@"userIcon"];
    self.nameLabel = [Factory creatLabelWithText:@"从近期中央银行的一系列政策操作和对外太多来看货"
                                       fontValue:font750(30)
                                       textColor:KTColor_MainBlack
                                   textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 2;
    self.timeLabel = [Factory creatLabelWithText:@"今天 9:56"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.lineView = [Factory creatLineView];
    
    [self addSubview:self.leftImg];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(30)));
        make.width.equalTo(@(Anno750(145)));
        make.height.equalTo(@(Anno750(145)));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.leftImg.hidden) {
            make.left.equalTo(@(Anno750(24)));
        }else{
            make.left.equalTo(self.leftImg.mas_right).offset(Anno750(24));
        }
        make.top.equalTo(self.leftImg.mas_top);
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(@(Anno750(-30)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}
- (void)updateWithReferenceModel:(ReferenceModel *)model{
    if (model.Pic ==nil || model.Pic.length == 0) {
        self.leftImg.hidden = YES;
    }else{
        [self.leftImg sd_setImageWithURL:[Factory getImageUlr:model.Pic]];
    }
    self.nameLabel.text = model.Title;
    self.timeLabel.text = [Factory getTodayTimeType:model.CreateDate];
}
- (void)updateWithMasterModel:(MasterModel *)model{
    if (model.Newsthumb ==nil || model.Newsthumb.length == 0) {
        self.leftImg.hidden = YES;
    }else{
        [self.leftImg sd_setImageWithURL:[Factory getImageUlr:model.Newsthumb]];
    }
    self.nameLabel.text = model.Newstitle;
    self.timeLabel.text = [Factory getTodayTimeType:model.CreatTime];
}
@end
