//
//  BaseViewController.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import <MJRefresh.h>
@interface BaseViewController : UIViewController
@property (nonatomic, strong) MJRefreshNormalHeader * refreshHeader;
@property (nonatomic, strong) MJRefreshAutoNormalFooter * refreshFooter;
@property (nonatomic) SelectorBackType backType;

- (void)doBack;
- (void)RefreshSetting;
- (void)setNavTitle:(NSString *)title;
- (void)drawBackButton;
@end
