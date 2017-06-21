//
//  QuotationModel.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "QuotationModel.h"

@implementation QuotationModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        self.stockinprice = [NSString stringWithFormat:@"%@元",dic[@"stockinprice"]];
        NSString * string = @"";
        self.isOpen = NO;
        switch (self.stockpositions.integerValue) {
            case 1:
                string = @"一成";
                break;
            case 2:
                string = @"二成";
                break;
            case 3:
                string = @"三成";
                break;
            case 4:
                string = @"四成";
                break;
            case 5:
                string = @"五成";
                break;
            case 6:
                string = @"六成";
                break;
            case 7:
                string = @"七成";
                break;
            case 8:
                string = @"八成";
                break;
            case 9:
                string = @"九成";
                break;
            case 10:
                string = @"满仓";
                break;
            default:
                break;
        }
        self.postionString = string;
    }
    return self;
}

@end
