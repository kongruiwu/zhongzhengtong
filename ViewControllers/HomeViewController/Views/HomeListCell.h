//
//  HomeListCell.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigHeader.h"
#import "HomeBtnModel.h"
@interface HomeButton : UIButton

@end

@protocol HomeListDelegate <NSObject>

- (void)pushToNextvc:(UIButton *)btn;

@end

@interface HomeListCell : UITableViewCell

@property (nonatomic, strong) HomeButton * FristBtn;
@property (nonatomic, strong) HomeButton * secodBtn;
@property (nonatomic, assign) id<HomeListDelegate> delegate;

- (void)updateWithFristModel:(HomeBtnModel *)model secodModel:(HomeBtnModel *)secM;

@end
