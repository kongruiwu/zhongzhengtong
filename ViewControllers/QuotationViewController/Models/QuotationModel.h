//
//  QuotationModel.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BaseModel.h"

@interface QuotationModel : BaseModel

@property (nonatomic, retain) NSNumber * iTotalCount;
@property (nonatomic, strong) NSString * rowId;
@property (nonatomic, strong) NSString * ID;
/**股票代码*/
@property (nonatomic, strong) NSString * stockCode;
/**股票名称*/
@property (nonatomic, strong) NSString * stockName;
@property (nonatomic, strong) NSString * selectedPrice;
@property (nonatomic, strong) NSString * maxGains;
/**入选时间*/
@property (nonatomic, strong) NSString * selectedTime;
@property (nonatomic, strong) NSString * selectedDate;
/**入选理由*/
@property (nonatomic, strong) NSString * selectedRemark;
@property (nonatomic, assign) BOOL Isdel;
@property (nonatomic, strong) NSString * strategyThreeId;
@property (nonatomic, assign) BOOL Isshow;
/**建议仓位（1-9成仓，10代表满仓）*/
@property (nonatomic, strong) NSNumber * stockpositions;
@property (nonatomic, strong) NSString * postionString;
/**建议买入价*/
@property (nonatomic, strong) NSString * stockinprice;
/**是否展开*/
@property (nonatomic, assign) BOOL isOpen;

@end
