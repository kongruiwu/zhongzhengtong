//
//  JpushHandler.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, JPUSHTYPE){
    JPUSHTYPENULL = 0 ,     //默认无 直接打开app
    JPUSHTYPESYSMESSAGE,    //系统消息
    JPUSHTYPESTOCK,         //牛股来了
    JPUSHTYPEREFERENCE,     //核心内参
    JPUSHTYPEQUESTION       //专家诊股
};


@protocol JpushHanderDlegate <NSObject>

- (void)pushToViewController:(JPUSHTYPE)type;

@end

@interface JpushHandler : NSObject

@property (nonatomic, assign) id<JpushHanderDlegate> delegate;

@property (nonatomic, strong) UIViewController * currentVC;

+ (instancetype)handler;
//注册代理
- (void)registerDelgate:(id)obj;

- (void)handerJpushMessage:(NSDictionary *)message withForground:(BOOL)rec;
@end
