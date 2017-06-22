//
//  HeadView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/13.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadViewButtonBlock)();

@interface HeadView : UIView

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (copy,nonatomic)HeadViewButtonBlock SHBlock;
@property (copy,nonatomic)HeadViewButtonBlock SZBlock;
@property (copy,nonatomic)HeadViewButtonBlock ZXBlock;
@property (copy,nonatomic)HeadViewButtonBlock CYBlock;

//初始化加载xib视图
+(instancetype)headView;

@end
