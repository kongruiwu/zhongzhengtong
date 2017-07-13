//
//  JpushHandler.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/27.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "JpushHandler.h"
#import "MessageListViewController.h"
#import "ReferenceViewController.h"
#import "ExpertViewController.h"
@implementation JpushHandler

+ (instancetype)handler{
    static JpushHandler * handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (handler == nil) {
            handler = [[JpushHandler alloc]init];
        }
    });
    return handler;
}


- (void)handerJpushMessage:(NSDictionary *)message withForground:(BOOL)rec{
    NSDictionary * dic = message[@"aps"];
    NSNumber * type = @0;
    if (message[@"type"]) {
        type = message[@"type"];
    }
    if (rec) {//前台接收信息
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"推送信息" message:dic[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cannce = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.delegate&& [self.delegate respondsToSelector:@selector(pushToViewController:)] ) {
                [self pushToViewController:type];
            }
        }];
        [alert addAction:cannce];
        [alert addAction:sure];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }else{
        if (self.delegate&& [self.delegate respondsToSelector:@selector(pushToViewController:)] ) {
            [self.delegate pushToViewController:[type intValue]];
        }
    }
    
    
}
- (void)pushToViewController:(NSNumber *)type{
    self.currentVC = [self getCurrentVC];
    switch ([type integerValue]) {
        case JPUSHTYPESYSMESSAGE:
        {
            MessageListViewController * vc = [MessageListViewController new];
            vc.isPush = NO;
            [self.currentVC.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JPUSHTYPESTOCK:
        {
            self.currentVC.tabBarController.selectedIndex = 2;
        }
            break;
        case JPUSHTYPEREFERENCE:
        {
            ReferenceViewController * vc = [ReferenceViewController new];
            [self.currentVC.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JPUSHTYPEQUESTION:
        {
            ExpertViewController * vc = [ExpertViewController new];
            [self.currentVC.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            
            break;
    }
}
- (UIViewController *)getCurrentVC
{
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController  *nvc = tbc.selectedViewController;
    UIViewController *vc = nvc.visibleViewController;
    return vc;
}

- (void)registerDelgate:(id)obj{
    if (obj != nil) {
        self.delegate = obj;
    }
}

@end
