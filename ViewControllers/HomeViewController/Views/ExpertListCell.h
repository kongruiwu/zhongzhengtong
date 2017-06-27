//
//  ExpertListCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "QuestionModel.h"

@protocol ExpertListCellDelegate <NSObject>

- (void)openNameLabel:(UIButton *)button;

@end

@interface ExpertListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * groundview;
@property (nonatomic, strong) UILabel * questUserName;
@property (nonatomic, strong) UILabel * questionLabel;
@property (nonatomic, strong) UILabel * questTime;
@property (nonatomic, strong) UIButton * downButton;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UIButton * nameDown;
@property (nonatomic, strong) UIButton * clearButton;
@property (nonatomic, assign) id delegate;
- (void)updateWithQuestionModel:(QuestionModel *)model;
@end
