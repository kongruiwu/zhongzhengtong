//
//  RootViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "RootViewController.h"
#import "MineViewController.h"
#import "EquityViewController.h"
#import "QuotationViewController.h"
#import "HomeViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
}

- (void)creatUI{
    
    
    
    NSArray * titles = @[@"首页",@"行情",@"牛股",@"我的"];
    NSArray * images = @[@"mine",@"quotation",@"equity",@"mine"];
    NSArray * selectImages = @[@"mine_selected",@"quotation_selected",@"equity_selected",@"mine_selected"];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MainRed, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    UINavigationController * nav_home = [[UINavigationController alloc]initWithRootViewController:[HomeViewController new]];
    nav_home.title = titles[0];
    nav_home.tabBarItem.image = [[UIImage imageNamed:images[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav_home.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * nav_equt = [[UINavigationController alloc]initWithRootViewController:[EquityViewController new]];
    nav_equt.title = titles[1];
    nav_equt.tabBarItem.image = [[UIImage imageNamed:images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav_equt.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * nav_quot = [[UINavigationController alloc]initWithRootViewController:[QuotationViewController new]];
    nav_quot.title = titles[2];
    nav_quot.tabBarItem.image = [[UIImage imageNamed:images[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav_quot.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController * nav_mine = [[UINavigationController alloc]initWithRootViewController:[MineViewController new]];
    nav_mine.title = titles[3];
    nav_mine.tabBarItem.image = [[UIImage imageNamed:images[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav_mine.tabBarItem.selectedImage = [[UIImage imageNamed:selectImages[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[nav_home,nav_equt,nav_quot,nav_mine];
    
    
    }

@end
