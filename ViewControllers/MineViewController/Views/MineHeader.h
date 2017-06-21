//
//  MineHeader.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface MineHeader : UIView
@property (nonatomic, strong) UIImageView * groundImg;
@property (nonatomic, strong) UIImageView * userIcon;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * buyBtn;


- (void)updateUseinfo;
@end
