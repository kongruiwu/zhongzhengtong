//
//  UserManager.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "ConfigHeader.h"
@interface UserManager : NSObject
+ (instancetype)instance;

/**是否登录*/
@property (nonatomic, assign) BOOL isLog;
/**用户名*/
@property (nonatomic, strong) NSString * userName;
/**设备唯一标识*/
@property (nonatomic, strong) NSString * deviceId;
/**用户信息*/
@property (nonatomic, strong) UserModel * userInfo;


- (void)updateUserInfo;
@end
