//
//  HotNewsCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HotNewsModel.h"
@interface HotNewsCell : UITableViewCell

@property (nonatomic, strong) UIView * topline;
@property (nonatomic, strong) UIView * bottomline;
@property (nonatomic, strong) UIImageView * centerImg;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * tagLabel;

- (void)updateFristCell:(BOOL)rec;
- (void)updateWithHotNewsModel:(HotNewsModel *)model;
@end
