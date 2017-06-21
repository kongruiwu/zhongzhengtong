//
//  AppDelegate.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/15.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigHeader.h"
#import "RootViewController.h"
#import "NetWorkManager.h"
#import <IQKeyboardManager.h>
#import "FristViewController.h"
#import "LoginViewController.h"
#import <WXApi.h>
@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign)BOOL isShow;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkUserInfo) userInfo:nil repeats:YES];
    
    [[NetWorkManager manager] requestToken];
    [[UserManager instance] updateUserInfo];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    self.window = [[UIWindow alloc]initWithFrame:UI_BOUNDS];
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Frist"]) {
        [self.window setRootViewController:[FristViewController new]];
    }else{
        [self.window setRootViewController:[RootViewController new]];
    }
    [WXApi registerApp:WXAPPKEY];
    
    return YES;
}

- (void)checkUserInfo{
    [[UserManager instance] updateUserInfo];
}
- (void)userLogOut{
    if (self.isShow) {
        return;
    }
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    UINavigationController  *nvc = tbc.selectedViewController;
    UIViewController *vc = nvc.visibleViewController;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号已经在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cannceAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isShow = NO;
        [[UserManager instance] userLogOut];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [vc presentViewController:nav animated:YES completion:nil];
    }];
    [alert addAction:cannceAction];
    [vc presentViewController:alert animated:YES completion:nil];
    self.isShow = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
