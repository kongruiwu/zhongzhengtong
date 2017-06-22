//
//  StockDetailHeadView.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/20.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuoteModel.h"

@protocol StockDetailKLineDelegate <NSObject>

- (void)fenShiLine;
- (void)dayKLine;
- (void)weekLine;
- (void)monthKLine;
- (void)hourKLine;

@end


@interface StockDetailHeadView : UIView

@property (nonatomic,weak)id<StockDetailKLineDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *KLineView;

+(instancetype)headView;

/**
    更新上部分的内容
 */
- (void)updateUI:(QuoteModel *)model;

//赋值资金金流入
- (void)updateZiJin:(NSString *)ziJin;

@end
