//
//  MessageDetailCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "MessageModel.h"
@interface MessageDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, strong) UILabel * openLabel;

- (void)updateWithMessageModel:(MessageModel *)model;
@end
