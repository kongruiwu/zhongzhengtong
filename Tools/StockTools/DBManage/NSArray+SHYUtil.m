//
//  NSArray+SHYUtil.m
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import "NSArray+SHYUtil.h"

@implementation NSArray (SHYUtil)

#pragma mark - 检测数组是否越界
- (id)objectAtIndexCheck:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
