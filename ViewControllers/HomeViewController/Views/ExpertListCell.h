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
@interface ExpertListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * groundview;
@property (nonatomic, strong) UILabel * questUserName;
@property (nonatomic, strong) UILabel * questionLabel;
@property (nonatomic, strong) UILabel * questTime;
@property (nonatomic, strong) UILabel * openLabel;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithQuestionModel:(QuestionModel *)model;
@end
