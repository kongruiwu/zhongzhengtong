//
//  UserModel.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super initWithDictionary:dic];
    if (self) {
        //本地保存记录
        [[NSUserDefaults standardUserDefaults] setValue:self.UserName forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

@end
