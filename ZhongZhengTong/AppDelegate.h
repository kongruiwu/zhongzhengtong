//
//  AppDelegate.h
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import <UIKit/UIKit.h>
//IOS10 注册apns 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <JPUSHService.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

