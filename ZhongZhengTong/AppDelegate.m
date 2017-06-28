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
#import "DataProvide.h"
#import "StockModel.h"
#import "YDConfigurationHelper.h"
#import "SearchStock.h"
#import <WXApi.h>
@interface AppDelegate ()<WXApiDelegate,UserMangerDelegate>

@property (nonatomic, strong)NSMutableArray *SHArr;      //上证指数
@property (nonatomic, strong)NSMutableArray *SZArr;      //深证指数
@property (nonatomic, strong)NSMutableArray *HuShenArr;  //沪深A股

@property (nonatomic, strong) NSTimer * timer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkUserLoginStatus];
    [self updateDataBase];       //每日更新一次数据库
    [self RequestSetting];
    [self toolsSetting];
    [self JpushSettingWithDic:launchOptions];
    self.window = [[UIWindow alloc]initWithFrame:UI_BOUNDS];
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Frist"]) {
        [self.window setRootViewController:[FristViewController new]];
    }else{
        [self.window setRootViewController:[RootViewController new]];
    }
    return YES;
}
- (void)checkUserLoginStatus{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkUserInfo) userInfo:nil repeats:YES];
}
- (void)RequestSetting{
    [[NetWorkManager manager] requestToken];
    [[UserManager instance] updateUserInfo];
    [UserManager instance].delegate = self;
}
- (void)toolsSetting{
    [WXApi registerApp:WXAPPKEY];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
}
- (void)JpushSettingWithDic:(NSDictionary *)launchOptions{
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKey channel:@"App Store" apsForProduction:YES advertisingIdentifier:nil];
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
}

- (void)checkUserInfo{
    [[UserManager instance] updateUserInfo];
}
- (void)UserLoginJpushSetting{
    [JPUSHService setTags:nil alias:[UserManager instance].userInfo.ID fetchCompletionHandle:nil];
}
- (void)UserLogOutJpushSetting{
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:nil];
}
- (void)userLogOut{
    if (![UserManager instance].isLog) {
        return;
    }
    [[UserManager instance] userLogOut];
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    UINavigationController  *nvc = tbc.selectedViewController;
    UIViewController *vc = nvc.visibleViewController;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号已经在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cannceAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[UserManager instance] userLogOut];
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:[LoginViewController new]];
        [vc presentViewController:nav animated:YES completion:nil];
    }];
    [alert addAction:cannceAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 更新数据库---每日只更新一次
- (void)updateDataBase {
    NSDate *  date=[NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [format setTimeZone:timeZone];
    NSString *stringDate = [format stringFromDate:date];
    NSString *stirng = [YDConfigurationHelper getStringValueForConfigurationKey:@"isToday"];
    if (![stirng isEqualToString:stringDate]){
        [YDConfigurationHelper setStringValueForConfigurationKey:@"isToday" withValue:stringDate];
        [self getStocks];
    }
}

#pragma mark - 更新具体的股票数据库
- (void)getStocks {
    //深证指数
    [[DataProvide sharedStore] getShenZhenExpWithBlock:^(id data) {
        if ([data isKindOfClass:[NSArray class]]) {
            [self.SZArr addObjectsFromArray:data];
            NSInteger SZNum = [YDConfigurationHelper getIntergerValueForConfigurationKey:@"SZExp"];
            if (self.SZArr.count != SZNum) {
                //                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //全局并行队列 可
                dispatch_queue_t queue = dispatch_queue_create("updateStock", DISPATCH_QUEUE_SERIAL);     //串行队列
                dispatch_async(queue, ^{
                    for (int i = 0; i<self.SZArr.count; i++){
                        StockModel *model = [[StockModel alloc] init];
                        model.isFav = 2;
                        [model setValuesForKeysWithDictionary:self.SZArr[i]];
                        //                        [[SearchStock shareManager] replaceStock:model];  //多线程操作数据库会导致崩溃或丢失数据
                        [[SearchStock shareManager] replaceStockInQueue:model];
                    }
                    [YDConfigurationHelper setIntergerValueForConfigurationKey:@"SZExp" withValue:self.SZArr.count];
                });
            }
        }
    } failure:^(NSString *error) {
    }];
    //上证指数
    [[DataProvide sharedStore] getShangZhenExpWithBlock:^(id data) {
        if ([data isKindOfClass: [NSArray class]])
        {
            [self.SHArr addObjectsFromArray:data];
            NSInteger SHNum = [YDConfigurationHelper getIntergerValueForConfigurationKey:@"SHExp"];
            if (self.SHArr.count != SHNum) {
                dispatch_queue_t queue = dispatch_queue_create("updateStock", DISPATCH_QUEUE_SERIAL);     //串行队列
                dispatch_async(queue, ^{
                    for (int i = 0; i<self.SHArr.count; i++)
                    {
                        StockModel *model = [[StockModel alloc] init];
                        model.isFav = 1;
                        [model setValuesForKeysWithDictionary:self.SHArr[i]];
                        [[SearchStock shareManager] replaceStockInQueue:model];
                    }
                    [YDConfigurationHelper setIntergerValueForConfigurationKey:@"SHExp" withValue:self.SHArr.count];
                });
            }
        }
    } failure:^(NSString *error) {
        
    }];
    //沪深A股
    [[DataProvide sharedStore] getAllStockWithBlock:^(id data) {
        if ([data isKindOfClass: [NSArray class]])
        {
            [self.HuShenArr addObjectsFromArray:data];
            NSInteger stocksNum = [YDConfigurationHelper getIntergerValueForConfigurationKey:@"HuShenA"];
            if (self.HuShenArr.count != stocksNum) {
                dispatch_queue_t queue = dispatch_queue_create("updateStock", DISPATCH_QUEUE_SERIAL);     //串行队列
                dispatch_async(queue, ^{
                    for (int i = 0; i<self.HuShenArr.count; i++)
                    {
                        StockModel *model = [[StockModel alloc] init];
                        model.isFav = 0;
                        [model setValuesForKeysWithDictionary:self.HuShenArr[i]];
                        [[SearchStock shareManager] replaceStockInQueue:model];
                    }
                    [YDConfigurationHelper setIntergerValueForConfigurationKey:@"HuShenA" withValue:self.HuShenArr.count];
                });
            }
        }
    } failure:^(NSString *error) {
        
    }];
}



#pragma mark -懒加载股票和指数数组
-(NSMutableArray *)SZArr {
    if (_SZArr == nil) {
        _SZArr = [NSMutableArray array];
    }
    return _SZArr;
}
-(NSMutableArray *)SHArr {
    if (_SHArr == nil) {
        _SHArr = [NSMutableArray array];
    }
    return _SHArr;
}
-(NSMutableArray *)HuShenArr {
    if (_HuShenArr == nil) {
        _HuShenArr = [NSMutableArray array];
    }
    return _HuShenArr;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [[JpushHandler handler] handerJpushMessage:userInfo withForground:YES];
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [[JpushHandler handler] handerJpushMessage:userInfo withForground:NO];
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [[JpushHandler handler] handerJpushMessage:userInfo withForground:NO];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    [[JpushHandler handler] handerJpushMessage:userInfo withForground:NO];
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [JPUSHService setBadge:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
