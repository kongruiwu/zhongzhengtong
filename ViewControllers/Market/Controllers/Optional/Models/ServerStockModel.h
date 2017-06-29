//
//  ServerStockModel.h
//  JinShiDai
//
//  Created by JopYin on 2017/6/19.
//  Copyright © 2017年 尹争荣. All rights reserved.
//  与行情无关的model  仅仅用于从服务器请求列表

#import "BaseModel.h"

@interface ServerStockModel : BaseModel

@property (nonatomic, copy)NSString *StockCode;

@property (nonatomic, copy)NSString *StockName;

@property (nonatomic, copy)NSString *CreateTime;

@property (nonatomic, assign)NSInteger Id;

@end
