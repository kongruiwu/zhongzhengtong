//
//  CustomSlideViewController.h
//  NewRenWang
//
//  Created by YJ on 17/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomSlideViewController;
@protocol CustomSlideViewControllerDelegate <NSObject>
@optional
/** 滚动偏移量*/
- (void)customSlideViewController:(CustomSlideViewController *)slideViewController slideOffset:(CGPoint)slideOffset;
- (void)customSlideViewController:(CustomSlideViewController *)slideViewController slideIndex:(NSInteger)slideIndex;
@end

@protocol CustomSlideViewControllerDataSource <NSObject>
/** 子控制器*/
- (UIViewController *)slideViewController:(CustomSlideViewController *)slideViewController viewControllerAtIndex:(NSInteger)index;
/* 子控制器数量 */
- (NSInteger)numberOfChildViewControllersInSlideViewController:(CustomSlideViewController *)slideViewController;
@end

@interface CustomSlideViewController : UIViewController
@property (nonatomic, weak) id <CustomSlideViewControllerDelegate> delgate;
@property (nonatomic, weak) id <CustomSlideViewControllerDataSource> dataSource;
@property (nonatomic, assign) NSInteger seletedIndex;
- (void)reloadData;
@end
