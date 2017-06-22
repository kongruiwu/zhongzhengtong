//
//  HeaderOptionalView.h
//  NewRenWang
//
//  Created by YJ on 17/1/17.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderOptionalView : UIView
/** 标题数组*/
@property (nonatomic, strong) NSArray <NSString *>*titles;
/** 点击item回调*/
@property (nonatomic, copy) void(^homeHeaderOptionalViewItemClickHandle)(HeaderOptionalView *optialView, NSString *title, NSInteger currentIndex);
/** 偏移量*/
@property (nonatomic, assign) CGPoint contentOffset;
@end
