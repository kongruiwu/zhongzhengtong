//
//  ReferenceListCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "ReferenceModel.h"
#import "MasterModel.h"
@interface ReferenceListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithReferenceModel:(ReferenceModel *)model;
- (void)updateWithMasterModel:(MasterModel *)model;
@end