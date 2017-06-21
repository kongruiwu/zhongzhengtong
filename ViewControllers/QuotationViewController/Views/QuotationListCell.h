//
//  QuotationListCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "QuotationModel.h"
@interface QuotationListCell : UITableViewCell
@property (nonatomic, strong) UIView * groundView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * priceLabel;
@property (nonatomic, strong) UILabel * countLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * downButton;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithQuotationModel:(QuotationModel *)model;
@end
