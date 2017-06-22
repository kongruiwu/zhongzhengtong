//
//  FindStockDelegate.h
//  NewRenWang
//
//  Created by JopYin on 2017/1/19.
//  Copyright © 2017年 尹争荣. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StockModel;

@protocol FindStockDelegate <NSObject>

- (void)pushStockDetailWithModel:(StockModel *)model;

@end
