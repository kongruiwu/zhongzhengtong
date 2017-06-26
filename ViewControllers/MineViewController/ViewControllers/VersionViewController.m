//
//  VersionViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/16.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    [self setNavTitle:@"关于版本"];
    [self creatUI];
}
- (void)creatUI{
    UIImageView * img = [Factory creatImageViewWithImage:@"LOGO"];
    NSString * appversion = [NSString stringWithFormat:@"当前版本号:V%@",[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    UILabel * versionLabel = [Factory creatLabelWithText:appversion
                                               fontValue:font750(28)
                                               textColor:KTColor_darkGray
                                           textAlignment:NSTextAlignmentCenter];
//    UIButton * checkUpdate = [Factory creatButtonWithTitle:@"检查更新"
//                                           backGroundColor:[UIColor clearColor]
//                                                 textColor:MainRed
//                                                  textSize:font750(30)];
//    checkUpdate.layer.borderColor = MainRed.CGColor;
//    checkUpdate.layer.borderWidth = 1.0f;
//    
    [self.view addSubview:img];
    [self.view addSubview:versionLabel];
//    [self.view addSubview:checkUpdate];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@(Anno750(300)));
        make.width.equalTo(@(Anno750(165)));
        make.height.equalTo(@(Anno750(165)));
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(img.mas_bottom).offset(Anno750(30));
        make.centerX.equalTo(@0);
    }];
//    [checkUpdate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(@(Anno750(-120)));
//        make.centerX.equalTo(@0);
//        make.width.equalTo(@(Anno750(280)));
//        make.height.equalTo(@(Anno750(80)));
//    }];
}

@end
