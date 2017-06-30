//
//  QuoteModel.m
//  GuShang
//
//  Created by JopYin on 2016/11/22.
//  Copyright © 2016年 尹争荣. All rights reserved.
//

#import "QuoteModel.h"

@implementation QuoteModel

- (NSMutableArray *)buyPrice{
    if (!_buyPrice) {
        _buyPrice = [[NSMutableArray alloc] init];
    }
    return _buyPrice;
}

- (NSMutableArray *)buyVOL{
    if (!_buyVOL) {
        _buyVOL = [[NSMutableArray alloc] init];
    }
    return _buyVOL;
}

- (NSMutableArray *)sellPrice{
    if (!_sellPrice) {
        _sellPrice = [[NSMutableArray alloc] init];
    }
    return _sellPrice;
}

- (NSMutableArray *)sellVOL{
    if (!_sellVOL) {
        _sellVOL = [[NSMutableArray alloc] init];
    }
    return _sellVOL;
}
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        if (dic[@"StockCode"]) {
            self.stockCode  = dic[@"StockCode"];
        }
    }
    return self;
}
@end
