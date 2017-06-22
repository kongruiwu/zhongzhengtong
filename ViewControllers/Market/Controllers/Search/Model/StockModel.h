//
//  StockModel.h
//  NiuBa
//
//  Created by JopYin on 2016/10/31.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockModel : NSObject<NSCoding>

@property (nonatomic, copy)NSString *stockCode;
@property (nonatomic, copy)NSString *stockName;
@property (nonatomic, copy)NSString *JP;
@property (nonatomic, assign) NSInteger isFav;    //判断是否是指数  并非是自选

@end
