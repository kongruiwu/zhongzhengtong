//
//  LoginCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "LoginCell.h"

@implementation LoginCell

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
    self.leftLabel = [Factory creatLabelWithText:@""
                                       fontValue:font750(30)
                                       textColor:KTColor_MainBlack
                                   textAlignment:NSTextAlignmentLeft];
    self.lineView = [Factory creatLineView];
    self.textF = [[UITextField alloc]init];
    self.textF.font = [UIFont systemFontOfSize:Anno750(28)];
    self.textF.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.textF];
    [self addSubview:self.lineView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(220)));
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(Anno750(-24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)updateWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder{
    self.leftLabel.text = title;
    self.textF.placeholder = placeHolder;
}
@end
