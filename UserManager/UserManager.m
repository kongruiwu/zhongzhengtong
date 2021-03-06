//
//  UserManager.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "UserManager.h"
#import "ADTracking.h"
#import "OpenUDID.h"
@implementation UserManager

+ (instancetype)instance{
    static UserManager * manger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manger == nil) {
            manger = [[UserManager alloc]init];
            [manger checkUserLogin];
            NSString * pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"PassWord"];
            manger.isSavePwd = pwd.length ==0 ? NO:YES;
        }
    });
    return manger;
}

- (void)updateUserInfo{
    
    if (!self.isLog) {
        return;
    }
    // NOTE: 以广告标示符为主，如果标示符为空 则使用openudid 作为设备id
    NSDictionary * params = @{@"UserName":self.userName,
                              @"MCode":self.deviceId,
                              @"UserPws":@"1"};
    [[NetWorkManager manager] GET:Page_UserInfo tokenParams:params complete:^(id result) {
        self.userInfo = [[UserModel alloc]initWithDictionary:(NSDictionary *)result];
        if ([self.delegate respondsToSelector:@selector(UserLoginJpushSetting)]) {
            [self.delegate UserLoginJpushSetting];
        }
    } error:^(JSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogOut" object:nil];
    }];
    
}
- (void)checkUserLogin{
    id name = [[NSUserDefaults standardUserDefaults] objectForKey:@"LogName"];
    self.isLog = NO;
    if (name != nil) {
        NSString * nameStr = name;
        if (nameStr.length > 0) {
            self.isLog = YES;
        }
    }
    if (self.isLog) {
        self.userName = (NSString *)name;
    }
    self.deviceId = INCASE_EMPTY([[ADTracking instance] idfaString], [OpenUDID value]);
}

- (void)userLogOut{
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"LogName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([self.delegate respondsToSelector:@selector(UserLogOutJpushSetting)]) {
        [self.delegate UserLogOutJpushSetting];
    }
    self.userInfo = nil;
    self.isLog = NO;
}

@end
