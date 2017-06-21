//
//  LoginCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
@interface LoginCell : UITableViewCell

@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UITextField * textF;
@property (nonatomic, strong) UIView * lineView;
- (void)updateWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;
@end
