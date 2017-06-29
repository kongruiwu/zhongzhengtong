//
//  FSDetailTableViewCell.h
//  YunZhangCaiJing
//
//  @Author: JopYin on 16/3/31.
//  Copyright © 2016年 JopYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenBiModel.h"

@interface FSDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UILabel *volumeLabel;

@property (strong, nonatomic)FenBiModel *model;

@end
