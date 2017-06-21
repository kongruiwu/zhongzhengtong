//
//  NetWorkManager.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "NetWorkManager.h"
#import <AFNetworking.h>
@implementation NetWorkManager

+ (instancetype)manager{
    static NetWorkManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NetWorkManager alloc]init];
            manager.lastGetTokenTime = @0;
            manager.token = @"";
        }
    });
    return manager;
}
- (void)GET:(NSString *)url tokenParams:(NSDictionary *)tokenParams complete:(CompleteBlock)complete error:(ErrorBlock)errorblock{
    NSNumber * current = [NSNumber numberWithLong:time(NULL)];
    
    BOOL isTimeOut = [current longValue] > [self.lastGetTokenTime longValue] + TokenTime * 60 ? YES : NO;
    
    if ([self.lastGetTokenTime integerValue] == 0 || self.token.length == 0 || isTimeOut ) {
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,Token];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        NSDate *datenow = [NSDate date];
        NSString *strDate = [formatter stringFromDate:datenow];
        NSString * number = [NSString stringWithFormat:@"%u",(arc4random()%899999)+100000];
        //MD5签名
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",APPID,strDate,number,SIGNKEY];
        
        NSString *resultStr = [Factory MD5HashWithString:str];
        NSDictionary * params = @{@"appid":APPID,
                                  @"signTime":strDate,
                                  @"random":number,
                                  @"signCode":resultStr};
        [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if ([dic[@"Code"] integerValue] == 100) {
                self.token = dic[@"data"];
                self.lastGetTokenTime = [NSNumber numberWithLong:time(NULL)];
                [self GET:url params:tokenParams complete:complete error:errorblock];
            }
#ifdef DEBUG
            else{
                [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
            }
#endif
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
#endif
        }];
        
    }else{
        [self GET:url params:tokenParams complete:complete error:errorblock];
    }
}
- (void)GET:(NSString *)url params:(NSDictionary *)params complete:(CompleteBlock)complete error:(ErrorBlock)errorblock{
        AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
        [manger.requestSerializer setValue:self.token forHTTPHeaderField:@"Token"];
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
        DLog(@"=================================\n%@\n=================================",params);
        DLog(@"=================================\n%@\n=================================",urlStr);
        [manger GET:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if ([dic[@"Code"] intValue] == 100) {
                id respont = dic[@"data"];
                complete(respont);
            }else{
                JSError * jserror = [[JSError alloc]init];
                jserror.code = [NSString stringWithFormat:@"%@",dic[@"Code"]];
                jserror.message = dic[@"msg"];
                errorblock(jserror);
    #ifdef DEBUG
                [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",jserror.code,jserror.message] duration:2.0f];
    #endif
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            JSError * jserror = [[JSError alloc]init];
            jserror.code = [NSString stringWithFormat:@"%ld",error.code];
            jserror.message = error.description;
            errorblock(jserror);
    #ifdef DEBUG
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",jserror.code,jserror.message] duration:2.0f];
    #endif
        }];
    
}
- (void)POST:(NSString *)url tokenParams:(NSDictionary *)tokenParams complete:(CompleteBlock)complete error:(ErrorBlock)errorblock{
    NSNumber * current = [NSNumber numberWithLong:time(NULL)];
    
    BOOL isTimeOut = [current longValue] > [self.lastGetTokenTime longValue] + TokenTime * 60 ? YES : NO;
    
    if ([self.lastGetTokenTime integerValue] == 0 || self.token.length == 0 || isTimeOut ) {
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,Token];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        NSDate *datenow = [NSDate date];
        NSString *strDate = [formatter stringFromDate:datenow];
        NSString * number = [NSString stringWithFormat:@"%u",(arc4random()%899999)+100000];
        //MD5签名
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@",APPID,strDate,number,SIGNKEY];
        
        NSString *resultStr = [Factory MD5HashWithString:str];
        NSDictionary * params = @{@"appid":APPID,
                                  @"signTime":strDate,
                                  @"random":number,
                                  @"signCode":resultStr};
        [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if ([dic[@"Code"] integerValue] == 100) {
                self.token = dic[@"data"];
                self.lastGetTokenTime = [NSNumber numberWithLong:time(NULL)];
                [self POST:url params:tokenParams complete:complete error:errorblock];
            }
#ifdef DEBUG
            else{
                [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
            }
#endif
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
#endif
        }];
        
    }else{
        [self POST:url params:tokenParams complete:complete error:errorblock];
    }
}
- (void)POST:(NSString *)url params:(NSDictionary *)params complete:(CompleteBlock)complete error:(ErrorBlock)errorblock{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    [manger.requestSerializer setValue:self.token forHTTPHeaderField:@"Token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
    DLog(@"=================================\n%@\n=================================",params);
    DLog(@"=================================\n%@\n=================================",urlStr);
    [manger POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if ([dic[@"Code"] intValue] == 100) {
            id respont = dic[@"data"];
            complete(respont);
        }else{
            JSError * jserror = [[JSError alloc]init];
            jserror.code = [NSString stringWithFormat:@"%@",dic[@"Code"]];
            jserror.message = dic[@"msg"];
            errorblock(jserror);
#ifdef DEBUG
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",jserror.code,jserror.message] duration:2.0f];
#endif
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        JSError * jserror = [[JSError alloc]init];
        jserror.code = [NSString stringWithFormat:@"%ld",error.code];
        jserror.message = error.description;
        errorblock(jserror);
#ifdef DEBUG
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:[NSString stringWithFormat:@"错误码：%@  \n 错误信息 %@",jserror.code,jserror.message] duration:2.0f];
#endif
    }];
    
    
}
- (void)requestToken{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    NSString * urlStr = [NSString stringWithFormat:@"%@%@",BaseUrl,Token];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *strDate = [formatter stringFromDate:datenow];
    NSString * number = [NSString stringWithFormat:@"%u",(arc4random()%899999)+100000];
    //MD5签名
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",APPID,strDate,number,SIGNKEY];
    
    NSString *resultStr = [Factory MD5HashWithString:str];
    NSDictionary * params = @{@"appid":APPID,
                              @"signTime":strDate,
                              @"random":number,
                              @"signCode":resultStr};
    [manager POST:urlStr parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if ([dic[@"Code"] integerValue] == 100) {
            self.token = dic[@"data"];
            self.lastGetTokenTime = [NSNumber numberWithLong:time(NULL)];
        }else{
#ifdef DEBUG
            [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
#endif
            }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
        [ToastView presentToastWithin:[UIApplication sharedApplication].keyWindow withIcon:APToastIconNone text:@"Token获取失败" duration:2.0f];
#endif
    }];
}


@end
