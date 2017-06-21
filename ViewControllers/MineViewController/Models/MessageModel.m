//
//  MessageModel.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/20.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        self.isOpen = NO;
    }
    return self;
}


@end
