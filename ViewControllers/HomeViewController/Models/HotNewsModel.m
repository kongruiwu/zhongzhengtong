//
//  HotNewsModel.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "HotNewsModel.h"

@implementation HotNewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        self.isOpen = NO;
    }
    return self;
}
@end
