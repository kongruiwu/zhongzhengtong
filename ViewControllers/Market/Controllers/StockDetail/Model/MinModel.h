//
//  MinModel.h
//  GuShang
//
//  Created by JopYin on 2016/11/29.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MinModel : NSObject

@property (nonatomic,copy)NSString *time;               //时间
@property (nonatomic,copy)NSString *price;              //最新价
@property (nonatomic,copy)NSString *VOL;                //成交量（手）        总的累积成交量
@property (nonatomic,copy)NSString *amount;             //成交额             总的累积成交额
@property (nonatomic,copy)NSString *avgPrice;           //均价
@property (nonatomic,assign)CGFloat preVol;             //上一分钟的总成交量

@end
