//
//  NSArray+SHYUtil.h
//  BigTimeStrategy
//
//  @Author: wsh on 16/6/15.
//  Copyright © 2016年 安徽黄埔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SHYUtil)

/**
 *  检测数组是否越界
 *
 *  @param index 请求的数组中的对象下表
 *
 *  @return 返回对象
 */
- (id)objectAtIndexCheck:(NSUInteger)index;

@end
