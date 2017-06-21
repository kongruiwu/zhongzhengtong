//
//  NetWorkManager.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"
#import "ConfigHeader.h"
#import "JSError.h"
#import "ToastView.h"
//TOKEN 过期时间 15分钟
#define TokenTime   15
typedef void(^CompleteBlock)(id result);
typedef void(^ErrorBlock)(JSError * error);

@interface NetWorkManager : NSObject



@property (nonatomic, strong) NSString * token;
//最后一次获取token时间
@property (nonatomic, strong) NSNumber * lastGetTokenTime;

+ (instancetype)manager;
//获取token
- (void)requestToken;


- (void)GET:(NSString *)url tokenParams:(NSDictionary *)tokenParams complete:(CompleteBlock)complete error:(ErrorBlock)errorblock;
- (void)POST:(NSString *)url tokenParams:(NSDictionary *)tokenParams complete:(CompleteBlock)complete error:(ErrorBlock)errorblock;
@end
