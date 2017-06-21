//
//  PayListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "PayListCell.h"

@implementation PayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
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
    self.leftImg = [Factory creatImageViewWithImage:@"textlogo"];
    self.leftLabel = [Factory creatLabelWithText:@""
                                       fontValue:font750(30)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.descLabel = [Factory creatLabelWithText:@""
                                       fontValue:font750(28)
                                       textColor:KTColor_darkGray
                                   textAlignment:NSTextAlignmentRight];
    self.lineView = [Factory creatLineView];
//    self.reduceButton = [Factory creatButtonWithTitle:@"-"
//                                      backGroundColor:[UIColor lightGrayColor]
//                                            textColor:KTColor_darkGray
//                                             textSize:Anno750(30)];
//    self.reduceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.reduceButton.layer.cornerRadius = Anno750(15);
//    self.addButton = [Factory creatButtonWithTitle:@"+"
//                                   backGroundColor:[UIColor lightGrayColor]
//                                         textColor:KTColor_darkGray
//                                          textSize:Anno750(30)];
//    self.addButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.addButton.layer.cornerRadius = Anno750(15);
    self.countTextf = [[UITextField alloc]init];
    self.countTextf.textColor = KTColor_MainBlack;
    self.countTextf.text = @"1";
    self.countTextf.textAlignment = NSTextAlignmentCenter;
    self.countTextf.layer.borderColor = KTColor_lightGray.CGColor;
    self.countTextf.layer.borderWidth = 1.0f;
    [self addSubview:self.leftImg];
    [self addSubview:self.descLabel];
    [self addSubview:self.leftLabel];
    [self addSubview:self.lineView];
//    [self addSubview:self.reduceButton];
//    [self addSubview:self.addButton];
    [self addSubview:self.countTextf];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.centerY.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(20)));
        make.centerY.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
//    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(@(-Anno750(24)));
//        make.centerY.equalTo(@0);
//        make.width.equalTo(@(Anno750(30)));
//        make.height.equalTo(@(Anno750(30)));
//    }];
    [self.countTextf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(@0);
        make.width.equalTo(@(Anno750(100)));
        make.height.equalTo(@(Anno750(50)));
    }];
//    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.countTextf.mas_left).offset(-Anno750(20));
//        make.centerY.equalTo(@0);
//        make.height.equalTo(@(Anno750(30)));
//        make.width.equalTo(@(Anno750(30)));
//    }];
}

- (void)showLeftIcon{
    self.leftImg.hidden = NO;
    self.leftLabel.hidden = YES;
    self.descLabel.hidden = YES;
//    self.reduceButton.hidden = YES;
//    self.addButton.hidden = YES;
    self.descLabel.hidden = YES;
    self.countTextf.hidden = YES;
}
- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc{
    [Factory setLabel:self.descLabel BorderColor:[UIColor clearColor] with:0 cornerRadius:0];
    self.descLabel.textColor = KTColor_darkGray;
    self.descLabel.textAlignment = NSTextAlignmentRight;
    self.leftImg.hidden = YES;
    self.leftLabel.hidden = NO;
    self.descLabel.hidden = NO;
//    self.reduceButton.hidden = YES;
//    self.addButton.hidden  = YES;
    self.countTextf.hidden = YES;
    self.leftLabel.text = title;
    self.descLabel.text = desc;
}

@end
