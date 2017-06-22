//
//  StockModel.m
//  NiuBa
//
//  Created by JopYin on 2016/10/31.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "StockModel.h"

@implementation StockModel

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_stockCode forKey:@"stockCode"];
    [coder encodeObject:_stockName forKey:@"stockName"];
    [coder encodeObject:_JP forKey:@"JP"];
    [coder encodeInteger:@(_isFav) forKey:@"isFav"];

}

- (id)initWithCoder:(NSCoder *)coder {
    _stockCode  = [[coder decodeObjectForKey:@"stockCode"] copy];
    _stockName  = [[coder decodeObjectForKey:@"stockName"] copy];
    _JP         = [[coder decodeObjectForKey:@"JP"] copy];
    _isFav      = [[[coder decodeObjectForKey:@"isFav"]copy] integerValue];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] init];
}


@end
