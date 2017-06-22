//
//  RankHeadView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/18.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RankHeadView;

@protocol RankHeadViewDelegate <NSObject>
//改变涨跌幅
- (void)rankHeadView:(RankHeadView *)rankHeadView changeRate:(BOOL)isFall;

@end


typedef void(^ButtonBlock)();

@interface RankHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *rateBtn;

@property (nonatomic, weak) id<RankHeadViewDelegate>delegate;

@property (copy,nonatomic)ButtonBlock rateBtnBlock;
//初始化加载xib视图
+(instancetype)headView;

@end
