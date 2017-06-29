//
//  FenBiModel.h
//  NewRenWang
//
//  Created by JopYin on 2017/2/7.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenBiModel : NSObject

@property (nonatomic,copy)NSString *time;               //时间
@property (nonatomic,copy)NSString *Price;              //最新价
@property (nonatomic,copy)NSString *VOL;                //成交量（手）
@property (nonatomic,copy)NSString *amount;             //成交额
@property (nonatomic,copy)NSString *buyOne;             //买一
@property (nonatomic,copy)NSString *sellOne;             //卖一

@property (nonatomic,copy)NSString *preClose;             //昨收

@end
