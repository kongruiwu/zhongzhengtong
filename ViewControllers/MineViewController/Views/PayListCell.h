//
//  PayListCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface PayListCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImg;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UITextField * countTextf;
//@property (nonatomic, strong) UIButton * reduceButton;
//@property (nonatomic, strong) UIButton * addButton;
@property (nonatomic, strong) UIView * lineView;
- (void)showLeftIcon;
- (void)updateWithTitle:(NSString *)title desc:(NSString *)desc;
@end
