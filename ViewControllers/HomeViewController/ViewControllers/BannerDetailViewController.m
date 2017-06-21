//
//  BannerDetailViewController.m
//  ZhongZhengTong
//
//  Created by 吴孔锐 on 2017/6/19.
//  Copyright © 2017年 wurui. All rights reserved.
//

#import "BannerDetailViewController.h"
#import <WebKit/WebKit.h>
#import "BannerModel.h"
@interface BannerDetailViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * webView;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) BannerModel * model;
@end

@implementation BannerDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden =YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawBackButton];
    [self setNavTitle:self.bannerTitle];
    [self getData];
    
}
- (void)creatUI{
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UI_WIDTH, UI_HEGIHT - 64)];
    [self.webView loadHTMLString:self.model.Content baseURL:nil];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'" completionHandler:nil];
    
    //修改字体颜色
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#666666'" completionHandler:nil];
    
}
- (void)getData{
    NSDictionary * params = @{@"SDId":self.bannerID};
    [[NetWorkManager manager] GET:Page_BannerInfo tokenParams:params complete:^(id result) {
        NSArray * arr = (NSArray *)result;
        if (arr.count == 0) {
            return ;
        }
        self.model = [[BannerModel alloc]initWithDictionary:arr[0]];
        [self creatUI];
    } error:^(JSError *error) {
        
    }];
}

@end
