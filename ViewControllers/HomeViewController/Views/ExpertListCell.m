//
//  ExpertListCell.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "ExpertListCell.h"
#import <UIImageView+WebCache.h>
@implementation ExpertListCell

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
    self.clearButton = [Factory creatButtonWithNormalImage:@"" selectImage:@""];
    [self.clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.userIcon = [Factory creatImageViewWithImage:@"userIcon"];
    self.userIcon.layer.cornerRadius = Anno750(30);
    self.userIcon.layer.masksToBounds = YES;
    self.nameDown = [Factory creatButtonWithNormalImage:@"down" selectImage:@"up"];
    self.nameLabel = [Factory creatLabelWithText:@"从近期中央银行的一系列政策操作和对外太多来"
                                       fontValue:font750(28)
                                       textColor:KTColor_MainBlack
                                   textAlignment:NSTextAlignmentLeft];
    self.nameLabel.numberOfLines = 1;
    self.timeLabel = [Factory creatLabelWithText:@"今天 9:56"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];
    self.userName = [Factory creatLabelWithText:@"超级玛丽"
                                      fontValue:font750(26)
                                      textColor:TagColor
                                  textAlignment:NSTextAlignmentLeft];
    self.questUserName = [Factory creatLabelWithText:@"超级玛丽"
                                           fontValue:font750(26)
                                           textColor:TagColor
                                       textAlignment:NSTextAlignmentLeft];
    self.questTime = [Factory creatLabelWithText:@"今天 9:56"
                                       fontValue:font750(24)
                                       textColor:KTColor_lightGray
                                   textAlignment:NSTextAlignmentLeft];;
    self.questionLabel = [Factory creatLabelWithText:@"从近期中央银行的一系列政策操作和对外太多来从近期中央银行的一系列政策操作和对外太多来从近期中央银行的一系列政策操作和对外太多来"
                                           fontValue:font750(28)
                                           textColor:KTColor_darkGray
                                       textAlignment:NSTextAlignmentLeft];
    self.questionLabel.numberOfLines = 2;
    self.downButton = [Factory creatButtonWithNormalImage:@"down" selectImage:@"up"];
    self.downButton.userInteractionEnabled  = NO ;
    self.groundview = [Factory creatViewWithColor:GroundColor];
    self.lineView = [Factory creatLineView];
    [self addSubview:self.groundview];
    [self addSubview:self.userName];
    [self addSubview:self.userIcon];
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.questTime];
    [self addSubview:self.questUserName];
    [self addSubview:self.questionLabel];
    [self addSubview:self.downButton];
    [self addSubview:self.lineView];
    [self addSubview:self.nameDown];
    [self addSubview:self.clearButton];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(Anno750(24)));
        make.top.equalTo(@(Anno750(30)));
        make.height.equalTo(@(Anno750(70)));
        make.width.equalTo(@(Anno750(70)));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userIcon.mas_right).offset(Anno750(20));
        make.top.equalTo(self.userIcon.mas_top);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.userName.mas_bottom).offset(Anno750(10));
        make.right.equalTo(@(-Anno750(64)));
    }];
    [self.nameDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(Anno750(6));
        make.bottom.equalTo(self.nameLabel.mas_bottom);
        make.height.equalTo(@(Anno750(24)));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(24)));
        make.centerY.equalTo(self.userName.mas_centerY);
    }];
    [self.questUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_left).offset(Anno750(20));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(40));
    }];
    [self.questTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-Anno750(48)));
        make.centerY.equalTo(self.questUserName.mas_centerY);
    }];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questUserName.mas_left);
        make.right.equalTo(@(-Anno750(64)));
        if (self.questUserName.hidden) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(40));
        }else{
            make.top.equalTo(self.questUserName.mas_bottom).offset(Anno750(15));
        }
    }];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.questionLabel.mas_right).offset(Anno750(6));
        make.bottom.equalTo(self.questionLabel.mas_bottom);
        make.height.equalTo(@(Anno750(24)));
    }];
    [self.groundview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(Anno750(20));
        make.bottom.equalTo(self.questionLabel.mas_bottom).offset(Anno750(20));
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(@(-Anno750(24)));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@(Anno750(24)));
        make.right.equalTo(@(-Anno750(24)));
        make.height.equalTo(@0.5);
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(self.nameLabel.mas_bottom).offset(Anno750(10));
    }];
    
}

- (void)updateWithQuestionModel:(QuestionModel *)model{
    [self.userIcon sd_setImageWithURL:[Factory getImageUlr:model.Pic] placeholderImage:[UIImage imageNamed:@"userIcon"]];
    self.userName.text = model.UserName;
    self.timeLabel.text = [Factory getTodayTimeType:model.QTime];
    self.nameLabel.text = model.Question;
    CGSize namesize = [Factory getSize:model.Question maxSize:CGSizeMake(9999, Anno750(30)) font:[UIFont systemFontOfSize:font750(28)]];
    self.nameDown.hidden = namesize.width > Anno750(750 - 174)? NO:YES;
    if (model.nameOpen) {
        self.nameLabel.numberOfLines = 0;
    }else{
        self.nameLabel.numberOfLines = 1;
    }
    self.nameDown.selected = model.nameOpen;
    if ( model.Answer == nil ||model.Answer.length == 0 ) {
        self.questionLabel.text = @"老师在忙 稍后为你解析...";
        self.questionLabel.textColor = KTColor_lightGray;
        self.questionLabel.numberOfLines = 1;
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        self.questionLabel.font = [UIFont systemFontOfSize:font750(24)];
        self.questTime.hidden = YES;
        self.questUserName.hidden = YES;
        self.downButton.hidden = YES;
    }else{
        self.questTime.hidden = NO;
        self.questUserName.hidden = NO;
        self.downButton.hidden = NO;
        self.questionLabel.textAlignment = NSTextAlignmentLeft;
        self.questionLabel.font = [UIFont systemFontOfSize:font750(28)];
        self.questionLabel.textColor = KTColor_darkGray;
        
        self.questUserName.text = model.StrategyTitle;
        self.questTime.text = [Factory getTodayTimeType:model.ATime];
        self.questionLabel.text = model.Answer;
        
        CGSize size = [Factory getSize:model.Answer maxSize:CGSizeMake(99999, Anno750(30)) font:[UIFont systemFontOfSize:font750(28)]];
        self.downButton.hidden = size.width >= Anno750(750 - 198) ? NO :YES;
        
        if (model.isOpen) {
            self.questionLabel.numberOfLines = 0;
        }else{
            self.questionLabel.numberOfLines = 2;
        }
        self.downButton.selected = model.isOpen;
    }
}
- (void)clearButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(openNameLabel:)]) {
        [self.delegate openNameLabel:button];
    }
}

@end
